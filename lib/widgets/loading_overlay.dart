import 'package:flutter/material.dart';
import 'package:flutter_face_rec/core/theme/color/color_base.dart';
import 'package:flutter_face_rec/core/theme/typhography.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final String message;
  final Widget child;
  final Color? overlayColor;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message = 'Loading...',
    this.overlayColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: overlayColor ?? Colors.black.withOpacity(0.5),
            child: Center(
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          MyColors.primary,
                        ),
                        strokeWidth: 3,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        message,
                        style: CustomTypography.bodyLSemiBold.copyWith(
                          color: MyColors.neutral.shade700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
