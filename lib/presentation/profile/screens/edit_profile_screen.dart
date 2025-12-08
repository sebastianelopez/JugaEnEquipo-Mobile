import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/datasources/user_use_cases/search_social_networks_use_case.dart';
import 'package:jugaenequipo/datasources/user_use_cases/update_user_background_image_use_case.dart';
import 'package:jugaenequipo/presentation/profile/business_logic/profile_provider.dart';
import 'package:jugaenequipo/providers/user_provider.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:jugaenequipo/global_widgets/widgets.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  final String? userId;

  const EditProfileScreen({super.key, this.userId});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _descriptionController;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  List<SocialNetworkModel>? _availableSocialNetworks;
  bool _loadingSocialNetworks = false;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController();
    _loadAvailableSocialNetworks();
  }

  void _initializeDescription(ProfileProvider profileProvider) {
    if (_descriptionController.text.isEmpty) {
      _descriptionController.text = profileProvider.description ?? '';
    }
  }

  Future<void> _loadAvailableSocialNetworks() async {
    setState(() {
      _loadingSocialNetworks = true;
    });
    try {
      final networks = await searchSocialNetworks();
      setState(() {
        _availableSocialNetworks = networks;
      });
    } catch (e) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      if (l10n == null) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.errorLoadingSocialNetworks(e.toString())),
          behavior: SnackBarBehavior.fixed,
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      setState(() {
        _loadingSocialNetworks = false;
      });
    }
  }

  Future<String?> _pickAndConvertImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile == null) return null;

      final File imageFile = File(pickedFile.path);
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);
      final mimeType = pickedFile.mimeType ?? 'image/png';
      return 'data:$mimeType;base64,$base64Image';
    } catch (e) {
      if (!mounted) return null;
      final l10n = AppLocalizations.of(context);
      if (l10n == null) return null;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.errorPickingImage(e.toString())),
          behavior: SnackBarBehavior.fixed,
          duration: const Duration(seconds: 3),
        ),
      );
      return null;
    }
  }

  Future<void> _updateBackgroundImage() async {
    final base64Image = await _pickAndConvertImage();
    if (base64Image == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final success = await updateUserBackgroundImage(base64Image);
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      if (l10n == null) return;
      if (success) {
        final profileProvider =
            Provider.of<ProfileProvider>(context, listen: false);
        await profileProvider.refreshData();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.backgroundImageUpdatedSuccessfully),
            behavior: SnackBarBehavior.fixed,
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.failedToUpdateBackgroundImage),
            behavior: SnackBarBehavior.fixed,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      if (l10n == null) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.errorPickingImage(e.toString())),
          behavior: SnackBarBehavior.fixed,
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _saveDescription() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final profileProvider =
          Provider.of<ProfileProvider>(context, listen: false);
      final success = await profileProvider.updateDescription(
        _descriptionController.text,
      );
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      if (l10n == null) return;
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.descriptionUpdatedSuccessfully),
            behavior: SnackBarBehavior.fixed,
            duration: const Duration(seconds: 2),
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.failedToUpdateDescription),
            behavior: SnackBarBehavior.fixed,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      if (l10n == null) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.errorPickingImage(e.toString())),
          behavior: SnackBarBehavior.fixed,
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _addSocialNetwork(SocialNetworkModel network) async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return;
    final usernameController = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.addSocialNetwork(network.name)),
        content: TextField(
          controller: usernameController,
          decoration: InputDecoration(
            labelText: l10n.usernameLabel,
            hintText: l10n.enterSocialNetworkUsername(network.name),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onSurface,
            ),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, usernameController.text),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.primary,
            ),
            child: Text(l10n.addButton),
          ),
        ],
      ),
    );

    if (result == null || result.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      if (!mounted) return;
      final profileProvider =
          Provider.of<ProfileProvider>(context, listen: false);
      final success = await profileProvider.addSocialNetworkToUser(
        network.id,
        result,
      );
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      if (l10n == null) return;
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.socialNetworkAddedSuccessfully(network.name)),
            behavior: SnackBarBehavior.fixed,
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.failedToAddSocialNetwork(network.name)),
            behavior: SnackBarBehavior.fixed,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      if (l10n == null) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.errorPickingImage(e.toString())),
          behavior: SnackBarBehavior.fixed,
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = widget.userId ?? userProvider.user?.id;

    final l10n = AppLocalizations.of(context)!;
    if (userId == null) {
      return Scaffold(
        backgroundColor: AppTheme.primary,
        appBar: BackAppBar(label: l10n.editProfileTitle),
        body: Center(child: Text(l10n.userNotFound)),
      );
    }

    return ChangeNotifierProvider(
      create: (context) => ProfileProvider(
        userId: userId,
        initialUser: widget.userId == null ? userProvider.user : null,
      ),
      child: Consumer<ProfileProvider>(
        builder: (context, profileProvider, _) {
          // Initialize description when provider is ready
          if (!profileProvider.isLoading &&
              profileProvider.profileUser != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _initializeDescription(profileProvider);
            });
          }

          final userSocialNetworks = profileProvider.socialNetworks;

          final l10n = AppLocalizations.of(context)!;
          return Scaffold(
            backgroundColor: AppTheme.primary,
            appBar: BackAppBar(
              label: l10n.editProfileTitle,
            ),
            body: (_isLoading || profileProvider.isLoading)
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Background Image Section
                        Card(
                          child: Padding(
                            padding: EdgeInsets.all(16.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.backgroundImageLabel,
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                ElevatedButton.icon(
                                  onPressed: _updateBackgroundImage,
                                  icon: const Icon(Icons.image,
                                      color: Colors.white),
                                  label: Text(
                                    l10n.changeBackgroundImage,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primary,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 12.h, horizontal: 16.w),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        // Description Section
                        Card(
                          child: Padding(
                            padding: EdgeInsets.all(16.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.descriptionLabel,
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                TextField(
                                  controller: _descriptionController,
                                  maxLines: 5,
                                  decoration: InputDecoration(
                                    hintText: l10n.tellUsAboutYourself,
                                    border: const OutlineInputBorder(),
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                ElevatedButton(
                                  onPressed: _saveDescription,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primary,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 12.h, horizontal: 16.w),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                  ),
                                  child: Text(
                                    l10n.saveDescription,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        // Social Networks Section
                        Card(
                          child: Padding(
                            padding: EdgeInsets.all(16.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.socialNetworksLabel,
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                // Current social networks
                                if (userSocialNetworks.isNotEmpty) ...[
                                  Text(
                                    l10n.yourNetworks,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  ...userSocialNetworks.map((network) =>
                                      ListTile(
                                        leading: Icon(Icons.link),
                                        title: Text(network.name),
                                        subtitle: network.username != null
                                            ? Text('@${network.username}')
                                            : null,
                                        trailing: IconButton(
                                          icon: const Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () async {
                                            if (!context.mounted) return;
                                            final l10n =
                                                AppLocalizations.of(context);
                                            if (l10n == null) return;
                                            final confirm =
                                                await showDialog<bool>(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: Text(l10n.removeNetwork),
                                                content: Text(l10n
                                                    .areYouSureRemoveNetwork(
                                                        network.name)),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, false),
                                                    style: TextButton.styleFrom(
                                                      foregroundColor:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .onSurface,
                                                    ),
                                                    child: Text(l10n.cancel),
                                                  ),
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, true),
                                                    style: TextButton.styleFrom(
                                                      foregroundColor:
                                                          Colors.red,
                                                    ),
                                                    child: Text(l10n.remove),
                                                  ),
                                                ],
                                              ),
                                            );
                                            if (confirm == true) {
                                              setState(() {
                                                _isLoading = true;
                                              });
                                              try {
                                                if (!context.mounted) return;
                                                final profileProvider = Provider
                                                    .of<ProfileProvider>(
                                                        context,
                                                        listen: false);
                                                final success =
                                                    await profileProvider
                                                        .removeSocialNetworkFromUser(
                                                            network.id);
                                                if (!context.mounted) return;
                                                final l10n =
                                                    AppLocalizations.of(
                                                        context);
                                                if (l10n == null) return;
                                                if (success) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(l10n
                                                          .socialNetworkRemoved(
                                                              network.name)),
                                                      behavior: SnackBarBehavior
                                                          .fixed,
                                                      duration: const Duration(
                                                          seconds: 2),
                                                    ),
                                                  );
                                                }
                                              } finally {
                                                if (mounted) {
                                                  setState(() {
                                                    _isLoading = false;
                                                  });
                                                }
                                              }
                                            }
                                          },
                                        ),
                                      )),
                                  SizedBox(height: 16.h),
                                ],
                                // Available social networks to add
                                if (_loadingSocialNetworks)
                                  const Center(
                                      child: CircularProgressIndicator())
                                else if (_availableSocialNetworks != null) ...[
                                  Text(
                                    l10n.addNetwork,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Wrap(
                                    spacing: 8.w,
                                    runSpacing: 8.h,
                                    children: _availableSocialNetworks!
                                        .where((network) => !userSocialNetworks
                                            .any((sn) => sn.id == network.id))
                                        .map((network) => Chip(
                                              label: Text(network.name),
                                              onDeleted: () =>
                                                  _addSocialNetwork(network),
                                              deleteIcon: const Icon(Icons.add),
                                            ))
                                        .toList(),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }
}
