import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jugaenequipo/datasources/api_service.dart';
import 'package:jugaenequipo/datasources/post_use_cases/add_post_resource_use_case.dart';
import 'package:jugaenequipo/datasources/user_use_cases/update_user_profile_image.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';
import 'package:jugaenequipo/providers/providers.dart';
import 'package:provider/provider.dart';
import 'package:mime/mime.dart';

enum ImageType { post, imageProfile }

class ImagePickerProvider extends ChangeNotifier {
  List<File>? mediaFileList;
  List<String>? mediaFileListIds = [];
  File? profileImage;

  void _setImageFile(File? value) {
    profileImage = value;
  }

  void clearMediaFileList() {
    mediaFileList?.clear();
    mediaFileListIds = [];
    notifyListeners();
  }

  dynamic _pickImageError;

  String? _retrieveDataError;

  final ImagePicker _picker = ImagePicker();

  bool isVideo(String path) {
    final mimeType = lookupMimeType(path);
    return mimeType?.startsWith('video/') ?? false;
  }

  Future getImageFromGallery(bool isMulti) async {
    try {
      if (isMulti) {
        final List<XFile> pickedFileList = await _picker.pickMultiImage();

        if (pickedFileList.isEmpty) return;

        mediaFileList =
            pickedFileList.map((xfile) => File(xfile.path)).toList();
        notifyListeners();
      } else {
        final XFile? pickedFile = await _picker.pickImage(
          source: ImageSource.gallery,
        );

        if (pickedFile == null) return;

        final File cleanFile = File(pickedFile.path);
        _setImageFile(cleanFile);
      }
    } catch (e) {
      _pickImageError = e;
    }
  }

  Future getImageFromCamera() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
      );
      if (pickedFile == null) return;

      final File cleanFile = File(pickedFile.path);
      _setImageFile(cleanFile);
    } catch (e) {
      _pickImageError = e;
    }
  }

  //Show options to get image from camera or gallery
  Future showOptions(BuildContext context,
      {required ImageType imageType, String? postId}) async {
    var savedContext = context;
    showDialog(
      context: savedContext,
      builder: (context) => SimpleDialog(
        children: [
          SimpleDialogOption(
            child: Text(AppLocalizations.of(context)!.photoGalleryOption),
            onPressed: () async {
              Navigator.of(context).pop();

              // get image from gallery
              if (imageType == ImageType.post) {
                await getImageFromGallery(true).then((_) async {
                  if ((mediaFileList != null && mediaFileList!.isEmpty) ||
                      postId == null) {
                    return;
                  }
                  mediaFileList?.forEach((file) async {
                    var mediaId = uuid.v4();
                    mediaFileListIds?.add(mediaId);
                    final isVideo = this.isVideo(file.path);
                    await addPostResource(postId, mediaId, file, isVideo);
                  });
                });
              } else if (imageType == ImageType.imageProfile) {
                getImageFromGallery(false).then((_) async {
                  if (profileImage == null) return;
                  final result = await updateUserProfileImage(profileImage!);
                  profileImage = null;
                  // ignore: use_build_context_synchronously
                  _handleImageSelection(result, savedContext);
                });
              }
            },
          ),
          SimpleDialogOption(
            child: Text(AppLocalizations.of(context)!.cameraOption),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from camera
              getImageFromCamera();
            },
          ),
        ],
      ),
    );
  }

  void _handleImageSelection(Result result, BuildContext context) {
    switch (result) {
      case Result.success:
        Provider.of<UserProvider>(context, listen: false).updateUser();

        break;
      case Result.unauthorized:
        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text(AppLocalizations.of(context)!.unauthorizedError),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Aceptar'),
                ),
              ],
            );
          },
        );
        break;
      case Result.error:
        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text(
                  'Ocurrió un error inesperado. Por favor, inténtalo de nuevo.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Aceptar'),
                ),
              ],
            );
          },
        );

        break;
    }
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Widget previewImages() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (mediaFileList != null) {
      return Semantics(
        label: 'image_picker_example_picked_images',
        child: GridView.count(
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 5,
          key: UniqueKey(),
          children: mediaFileList!.map((file) {
            return kIsWeb
                ? Image.network(file.path)
                : Image.file(
                    height: 80,
                    width: 80,
                    File(file.path),
                    errorBuilder: (BuildContext context, Object error,
                        StackTrace? stackTrace) {
                      return const Center(
                          child: Text('This image type is not supported'));
                    },
                  );
          }).toList(),
        ),
      );
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
    }
  }
}
