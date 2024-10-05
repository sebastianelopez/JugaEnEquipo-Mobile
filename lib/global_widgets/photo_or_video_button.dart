import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class PhotoOrVideoButton extends StatefulWidget {
  const PhotoOrVideoButton({
    super.key,
  });

  @override
  State<PhotoOrVideoButton> createState() => _PhotoOrVideoButtonState();
}

class _PhotoOrVideoButtonState extends State<PhotoOrVideoButton> {
  List<XFile>? _mediaFileList;

  void _setImageFileListFromFile(XFile? value) {
    _mediaFileList = value == null ? null : <XFile>[value];
  }

  dynamic _pickImageError;

  String? _retrieveDataError;

  final ImagePicker _picker = ImagePicker();

  //Image Picker function to get image from gallery
  Future getImageFromGallery() async {
    try {
      final List<XFile> pickedFileList = await _picker.pickMultiImage();
      setState(() {
        _mediaFileList = pickedFileList;
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  //Image Picker function to get image from camera
  Future getImageFromCamera() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
      );
      setState(() {
        _setImageFileListFromFile(pickedFile);
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  //Show options to get image from camera or gallery
  Future _showOptions() async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: const Text('Photo Gallery'),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from gallery
              getImageFromGallery();
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Camera'),
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

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Widget _previewImages() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_mediaFileList != null) {
      return Semantics(
        label: 'image_picker_example_picked_images',
        child: GridView.builder(
          key: UniqueKey(),
          itemBuilder: (BuildContext context, int index) {
            return Semantics(
              label: 'image_picker_example_picked_image',
              child: kIsWeb
                  ? Image.network(_mediaFileList![index].path)
                  : Image.file(
                      height: 80,
                      width: MediaQuery.of(context).size.width /
                          _mediaFileList!.length,
                      File(_mediaFileList![index].path),
                      errorBuilder: (BuildContext context, Object error,
                          StackTrace? stackTrace) {
                        return const Center(
                            child: Text('This image type is not supported'));
                      },
                    ),
            );
          },
          itemCount: _mediaFileList!.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _mediaFileList!
                .length, // Adjust the number of columns as needed
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4,
          ),
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 100.h,
          width: double.infinity,
          child: _previewImages(),
        ),
        ElevatedButton(
          onPressed: _showOptions,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shape: const BeveledRectangleBorder(),
          ),
          child: Container(
            height: 50.h,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey[300]!,
                  width: 1.0.h,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.image,
                  size: 24.h,
                ),
                const Text('Photo / Video')
              ],
            ),
          ),
        ),
      ],
    );
  }
}
