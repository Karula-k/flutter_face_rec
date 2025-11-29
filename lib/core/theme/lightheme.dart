import 'package:flutter/material.dart';
import 'package:flutter_face_rec/core/theme/color/color_base.dart';
import 'package:flutter_face_rec/core/theme/typhography.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  fontFamily: 'PlusJakartaSans',
  colorScheme: ColorScheme(
      surfaceTint: Colors.transparent,
      onSurfaceVariant: Colors.transparent,
      brightness: Brightness.light,
      primary: MyColors.primary,
      onPrimary: MyColors.backgroundWhite,
      secondary: MyColors.secondary,
      onSecondary: MyColors.neutral.shade900,
      error: MyColors.error,
      onError: MyColors.backgroundWhite,
      surface: MyColors.backgroundWhite,
      onSurface: MyColors.neutral.shade900,
      background: MyColors.primary,
      onBackground: MyColors.backgroundWhite),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
        backgroundColor: MyColors.primary,
        foregroundColor: MyColors.backgroundWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
        foregroundColor: MyColors.primary,
        side: BorderSide(color: MyColors.primary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        )),
  ),
  inputDecorationTheme: InputDecorationTheme(
    hintStyle:
        CustomTypography.bodyL.copyWith(color: MyColors.neutral.shade400),
    border: MaterialStateOutlineInputBorder.resolveWith(
      (states) {
        if (states.contains(MaterialState.error)) {
          return OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
                color: MyColors.error), // Color when there's an error
          );
        }
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
              color: MyColors.neutral.shade300), // Color when there's an error
        );
      },
    ),
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: MyColors.backgroundWhite,
    elevation: 0.2,
    behavior: SnackBarBehavior.floating,
  ),
  dividerTheme: DividerThemeData(
    color: MyColors.neutral.shade200,
  ),
  appBarTheme: AppBarTheme(
      centerTitle: true,
      titleTextStyle: CustomTypography.bodyXLSemiBold.copyWith(height: 1),
      foregroundColor: MyColors.neutral.shade900),
  radioTheme: RadioThemeData(
    fillColor:
        MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return MyColors.primary; // Color when selected
      }
      if (states.contains(MaterialState.hovered)) {
        return MyColors.secondary; // Color when hovered
      }
      return MyColors.neutral; // Default color
    }),
  ),
  cardTheme: CardTheme(elevation: 0),
  dialogTheme: DialogTheme(
    elevation: 0.2,
    titleTextStyle: CustomTypography.bodyXLBold,
    contentTextStyle: CustomTypography.bodyL,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
  datePickerTheme: DatePickerThemeData(
    dayStyle: CustomTypography.bodyL.copyWith(color: MyColors.neutral.shade700),
    backgroundColor: MyColors.backgroundWhite,
    headerBackgroundColor: MyColors.backgroundWhite,
    headerForegroundColor: MyColors.neutral.shade700,
    rangePickerHeaderForegroundColor: MyColors.neutral,
    dayForegroundColor: MaterialStateProperty.resolveWith(
      (states) {
        if (states.contains(MaterialState.disabled)) {
          return MyColors.neutral.shade200;
        } else if (states.contains(MaterialState.selected) |
            states.contains(MaterialState.focused)) {
          return MyColors.backgroundWhite;
        } else {
          return MyColors.neutral.shade700;
        }
      },
    ),
    yearForegroundColor: MaterialStateProperty.resolveWith(
      (states) {
        if (states.contains(MaterialState.disabled)) {
          return MyColors.neutral.shade200;
        } else if (states.contains(MaterialState.selected) |
            states.contains(MaterialState.focused)) {
          return MyColors.backgroundWhite;
        } else {
          return MyColors.neutral.shade700;
        }
      },
    ),
    rangeSelectionOverlayColor: MaterialStateProperty.resolveWith(
      (states) {
        if (states.contains(MaterialState.disabled)) {
          return MyColors.neutral.shade200;
        } else if (states.contains(MaterialState.selected) |
            states.contains(MaterialState.focused)) {
          return MyColors.backgroundWhite;
        } else {
          return MyColors.neutral.shade700;
        }
      },
    ),
    rangeSelectionBackgroundColor: MyColors.primary.shade300,
    dividerColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    inputDecorationTheme: InputDecorationTheme(
        hintStyle: CustomTypography.bodyM,
        labelStyle: CustomTypography.bodyS,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        fillColor: MyColors.backgroundWhite,
        filled: true,
        counterStyle: CustomTypography.bodyL.copyWith(color: MyColors.neutral)),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(16),
      ),
    ),
  ),
  tabBarTheme: TabBarTheme(
    labelColor: MyColors.neutral,
    labelStyle: CustomTypography.bodyXLBold.copyWith(height: 1),
    unselectedLabelColor: MyColors.neutral.shade600,
    unselectedLabelStyle: CustomTypography.bodyXLBold.copyWith(height: 1),
    indicatorSize: TabBarIndicatorSize.tab,
    dividerColor: Colors.transparent,
    indicator: BoxDecoration(
        color: MyColors.primary.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: MyColors.primary.shade300)),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8), topRight: Radius.circular(8))),
  ),
);
