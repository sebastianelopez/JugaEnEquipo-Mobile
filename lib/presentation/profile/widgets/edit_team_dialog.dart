import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jugaenequipo/datasources/models/models.dart';
import 'package:jugaenequipo/presentation/profile/business_logic/team_profile_provider.dart';
import 'package:jugaenequipo/theme/app_theme.dart';
import 'package:image_picker/image_picker.dart';

class EditTeamDialog extends StatefulWidget {
  final TeamProfileModel team;
  final TeamProfileProvider provider;

  const EditTeamDialog({
    super.key,
    required this.team,
    required this.provider,
  });

  @override
  State<EditTeamDialog> createState() => _EditTeamDialogState();
}

class _EditTeamDialogState extends State<EditTeamDialog> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  File? _selectedImage;
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

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _save() async {
    String? imageBase64;
    if (_selectedImage != null) {
      final bytes = await _selectedImage!.readAsBytes();
      final base64Image = base64Encode(bytes);
      String mimeType = 'image/png';
      final extension = _selectedImage!.path.split('.').last.toLowerCase();
      if (extension == 'jpg' || extension == 'jpeg') {
        mimeType = 'image/jpeg';
      } else if (extension == 'gif') {
        mimeType = 'image/gif';
      }
      imageBase64 = 'data:$mimeType;base64,$base64Image';
    }

    final success = await widget.provider.updateTeam(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      image: imageBase64,
    );

    if (mounted) {
      if (success) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Team updated successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error updating team')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        padding: EdgeInsets.all(20.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(Icons.edit, color: AppTheme.primary, size: 24.h),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      'Edit Team',
                      style: TextStyle(
                        fontSize: 20.h,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 120.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.primary, width: 2),
                  ),
                  child: _selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            _selectedImage!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : widget.team.image != null &&
                              widget.team.image!.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                widget.team.image!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(Icons.add_photo_alternate,
                                        size: 48.h, color: AppTheme.primary),
                              ),
                            )
                          : Icon(Icons.add_photo_alternate,
                              size: 48.h, color: AppTheme.primary),
                ),
              ),
              SizedBox(height: 16.h),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Team Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 4,
              ),
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  SizedBox(width: 12.w),
                  ElevatedButton(
                    onPressed: widget.provider.isPerformingAction ? null : _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                    ),
                    child: widget.provider.isPerformingAction
                        ? SizedBox(
                            width: 20.w,
                            height: 20.h,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

