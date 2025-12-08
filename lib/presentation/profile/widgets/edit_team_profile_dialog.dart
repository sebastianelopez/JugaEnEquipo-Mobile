import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/presentation/profile/business_logic/team_profile_provider.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:jugaenequipo/l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';

class EditTeamProfileDialog extends StatefulWidget {
  final TeamProfileModel team;
  final TeamProfileProvider provider;

  const EditTeamProfileDialog({
    super.key,
    required this.team,
    required this.provider,
  });

  @override
  State<EditTeamProfileDialog> createState() => _EditTeamProfileDialogState();
}

class _EditTeamProfileDialogState extends State<EditTeamProfileDialog> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  File? _selectedProfileImage;
  File? _selectedBackgroundImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.team.name);
    _descriptionController =
        TextEditingController(text: widget.team.description ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickProfileImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedProfileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickBackgroundImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedBackgroundImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _save() async {
    String? imageBase64;
    if (_selectedProfileImage != null) {
      final bytes = await _selectedProfileImage!.readAsBytes();
      final base64Image = base64Encode(bytes);
      String mimeType = 'image/png';
      final extension =
          _selectedProfileImage!.path.split('.').last.toLowerCase();
      if (extension == 'jpg' || extension == 'jpeg') {
        mimeType = 'image/jpeg';
      } else if (extension == 'gif') {
        mimeType = 'image/gif';
      }
      imageBase64 = 'data:$mimeType;base64,$base64Image';
    }

    // Update team info
    final success = await widget.provider.updateTeam(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      image: imageBase64,
    );

    if (context.mounted && success) {
      // Update background image if selected
      if (_selectedBackgroundImage != null) {
        final bytes = await _selectedBackgroundImage!.readAsBytes();
        final base64Image = base64Encode(bytes);
        String mimeType = 'image/png';
        final extension =
            _selectedBackgroundImage!.path.split('.').last.toLowerCase();
        if (extension == 'jpg' || extension == 'jpeg') {
          mimeType = 'image/jpeg';
        } else if (extension == 'gif') {
          mimeType = 'image/gif';
        }
        final backgroundBase64 = 'data:$mimeType;base64,$base64Image';
        await widget.provider.updateBackgroundImageFromBase64(backgroundBase64);
      }
      if (!mounted) return;
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.teamUpdatedSuccessfully),
          backgroundColor: AppTheme.success,
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.errorUpdatingTeam),
          backgroundColor: AppTheme.error,
        ),
      );
    }
  }

  Future<void> _deleteTeam() async {
    if (!widget.provider.canDeleteTeam()) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteTeam),
        content: Text(AppLocalizations.of(context)!.deleteTeamConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.error,
            ),
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final success = await widget.provider.deleteTeam();
      if (mounted) {
        Navigator.of(context).pop(); // Close edit dialog
        if (success) {
          Navigator.of(context).pop(true); // Close profile screen
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text(AppLocalizations.of(context)!.teamDeletedSuccessfully),
              backgroundColor: AppTheme.success,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.errorDeletingTeam),
              backgroundColor: AppTheme.error,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.primary,
                    AppTheme.primary.withOpacity(0.8),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.edit, color: Colors.white, size: 28.h),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      localizations.editProfile,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.h,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),
            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Profile Image Section
                    Text(
                      localizations.profileImage,
                      style: TextStyle(
                        fontSize: 16.h,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.secondary,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    GestureDetector(
                      onTap: _pickProfileImage,
                      child: Container(
                        height: 140.h,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppTheme.primary,
                            width: 2,
                          ),
                        ),
                        child: _selectedProfileImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Image.file(
                                  _selectedProfileImage!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : widget.team.image != null &&
                                    widget.team.image!.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(14),
                                    child: Image.network(
                                      widget.team.image!,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) => Icon(
                                              Icons.add_photo_alternate,
                                              size: 48.h,
                                              color: AppTheme.primary),
                                    ),
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add_photo_alternate,
                                          size: 48.h, color: AppTheme.primary),
                                      SizedBox(height: 8.h),
                                      Text(
                                        localizations.changeProfileImage,
                                        style: TextStyle(
                                          fontSize: 12.h,
                                          color: AppTheme.secondary,
                                        ),
                                      ),
                                    ],
                                  ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    // Background Image Section
                    Text(
                      localizations.backgroundImage,
                      style: TextStyle(
                        fontSize: 16.h,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.secondary,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    GestureDetector(
                      onTap: _pickBackgroundImage,
                      child: Container(
                        height: 120.h,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppTheme.accent,
                            width: 2,
                          ),
                        ),
                        child: _selectedBackgroundImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Image.file(
                                  _selectedBackgroundImage!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : widget.provider.backgroundImageUrl != null &&
                                    widget
                                        .provider.backgroundImageUrl!.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(14),
                                    child: Image.network(
                                      widget.provider.backgroundImageUrl!,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) => Icon(
                                              Icons.image,
                                              size: 48.h,
                                              color: AppTheme.accent),
                                    ),
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.image,
                                          size: 48.h, color: AppTheme.accent),
                                      SizedBox(height: 8.h),
                                      Text(
                                        localizations.changeBackgroundImage,
                                        style: TextStyle(
                                          fontSize: 12.h,
                                          color: AppTheme.secondary,
                                        ),
                                      ),
                                    ],
                                  ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    // Team Name
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: localizations.teamName,
                        prefixIcon: Icon(Icons.group, color: AppTheme.primary),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: AppTheme.primary, width: 2),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    // Description
                    TextField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: localizations.description,
                        prefixIcon:
                            Icon(Icons.description, color: AppTheme.primary),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: AppTheme.primary, width: 2),
                        ),
                      ),
                      maxLines: 4,
                    ),
                    SizedBox(height: 32.h),
                    // Delete Team Button (only for creator)
                    if (widget.provider.canDeleteTeam()) ...[
                      Divider(height: 32.h),
                      Text(
                        localizations.dangerZone,
                        style: TextStyle(
                          fontSize: 14.h,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.error,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      OutlinedButton.icon(
                        onPressed: _deleteTeam,
                        icon: Icon(Icons.delete_outline, color: AppTheme.error),
                        label: Text(
                          localizations.deleteTeam,
                          style: TextStyle(color: AppTheme.error),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppTheme.error, width: 1.5),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                    ],
                    // Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(localizations.cancel),
                        ),
                        SizedBox(width: 12.w),
                        ElevatedButton(
                          onPressed:
                              widget.provider.isPerformingAction ? null : _save,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primary,
                            padding: EdgeInsets.symmetric(
                              horizontal: 24.w,
                              vertical: 12.h,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: widget.provider.isPerformingAction
                              ? SizedBox(
                                  width: 20.w,
                                  height: 20.h,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : Text(localizations.save),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
