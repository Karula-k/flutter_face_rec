import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_face_rec/core/theme/color/color_base.dart';
import 'package:flutter_face_rec/core/theme/typhography.dart';

class ImagePreviewWidget extends StatelessWidget {
  final File? imageFile;
  final String placeholderText;
  final VoidCallback? onRetake;
  final VoidCallback? onRemove;
  final double? height;

  const ImagePreviewWidget({
    super.key,
    this.imageFile,
    required this.placeholderText,
    this.onRetake,
    this.onRemove,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 300,
      width: double.infinity,
      decoration: BoxDecoration(
        color: MyColors.neutral.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: MyColors.neutral.shade300,
          width: 2,
        ),
      ),
      child: imageFile != null
          ? Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.file(
                    imageFile!,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (onRetake != null)
                        CircleAvatar(
                          backgroundColor: Colors.black54,
                          radius: 20,
                          child: IconButton(
                            onPressed: onRetake,
                            icon: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      if (onRemove != null) ...[
                        const SizedBox(width: 8),
                        CircleAvatar(
                          backgroundColor: Colors.black54,
                          radius: 20,
                          child: IconButton(
                            onPressed: onRemove,
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_outlined,
                    size: 64,
                    color: MyColors.neutral.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    placeholderText,
                    style: CustomTypography.bodyL.copyWith(
                      color: MyColors.neutral.shade500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
    );
  }
}
