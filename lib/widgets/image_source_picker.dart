import 'package:flutter/material.dart';
import 'package:flutter_face_rec/core/theme/color/color_base.dart';
import 'package:flutter_face_rec/core/theme/typhography.dart';

class ImageSourcePicker {
  static void show({
    required BuildContext context,
    required VoidCallback onCameraSelected,
    required VoidCallback onGallerySelected,
    String title = 'Select Image Source',
    String subtitle = 'Choose how you want to add an image',
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _ImageSourcePickerSheet(
        title: title,
        subtitle: subtitle,
        onCameraSelected: onCameraSelected,
        onGallerySelected: onGallerySelected,
      ),
    );
  }
}

class _ImageSourcePickerSheet extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onCameraSelected;
  final VoidCallback onGallerySelected;

  const _ImageSourcePickerSheet({
    required this.title,
    required this.subtitle,
    required this.onCameraSelected,
    required this.onGallerySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: CustomTypography.headingSSemiBold,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: CustomTypography.bodyL.copyWith(
                color: MyColors.neutral.shade600,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _SourceOption(
                    icon: Icons.camera_alt_outlined,
                    label: 'Camera',
                    subtitle: 'Take a new photo',
                    onTap: () {
                      Navigator.of(context).pop();
                      onCameraSelected();
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _SourceOption(
                    icon: Icons.photo_library_outlined,
                    label: 'Gallery',
                    subtitle: 'Choose from gallery',
                    onTap: () {
                      Navigator.of(context).pop();
                      onGallerySelected();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SourceOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const _SourceOption({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: MyColors.neutral.shade300),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: MyColors.primary.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 32,
                color: MyColors.primary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: CustomTypography.bodyLSemiBold,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: CustomTypography.bodyS.copyWith(
                color: MyColors.neutral.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
