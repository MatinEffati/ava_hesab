import 'package:ava_hesab/config/app_colors.dart';
import 'package:ava_hesab/core/utils/constants.dart';
import 'package:ava_hesab/core/utils/sizes.dart';
import 'package:flutter/material.dart';

class AppThemes {
  static final lightTheme = ThemeData(
    useMaterial3: false,
    brightness: Brightness.light,
    primaryColor: AppColorsLight.primaryColor,
    scaffoldBackgroundColor: AppColorsLight.backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColorsLight.backgroundColor,
      titleTextStyle: TextStyle(
        fontFamily: Constants.fontFamily,
        color: AppColorsLight.textLightDefault,
        fontWeight: FontWeight.w700,
        fontSize: 20,
      ),
    ),
    textTheme: const TextTheme(
      labelSmall: TextStyle(
        fontWeight: FontWeight.w400,
        color: AppColorsLight.textLightDefault,
        fontFamily: Constants.fontFamily,
        fontSize: 14,
      ),
      bodySmall: TextStyle(
        fontWeight: FontWeight.w400,
        color: AppColorsLight.textLightDefault,
        fontFamily: Constants.fontFamily,
        fontSize: 14,
      ),
      bodyMedium: TextStyle(
        fontFamily: Constants.fontFamily,
        color: AppColorsLight.textLightDefault,
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),
      bodyLarge: TextStyle(
        fontFamily: Constants.fontFamily,
        color: AppColorsLight.textLightDefault,
        fontWeight: FontWeight.w700,
        fontSize: 20,
      ),
      labelMedium: TextStyle(
        color: AppColorsLight.textLightDefault,
        fontFamily: Constants.fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      titleMedium: TextStyle(
        fontFamily: Constants.fontFamily,
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: AppColorsLight.textLightDefault,
      ),
      headlineLarge: TextStyle(
        color: AppColorsLight.textLightDefault,
        fontFamily: Constants.fontFamily,
        fontSize: 30,
        fontWeight: FontWeight.w900,
      ),
    ),
    // textSelectionTheme: const TextSelectionThemeData(
    //   cursorColor: AppColorsLight.textLightDefault, //<-- SEE HERE
    // ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(20),
      fillColor: AppColorsLight.surfaceMain,
      filled: true,
      hintStyle: const TextStyle(
        color: AppColorsLight.gray,
        fontFamily: Constants.fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Sizes.borderRadius),
        borderSide: const BorderSide(width: 1, color: AppColorsLight.borderDanger),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Sizes.borderRadius),
        borderSide: const BorderSide(width: 1, color: AppColorsLight.primaryColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Sizes.borderRadius),
        borderSide: const BorderSide(width: 1, color: AppColorsLight.borderDefault),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Sizes.borderRadius),
        borderSide: const BorderSide(width: 1, color: AppColorsLight.borderDefault),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Sizes.borderRadius),
        borderSide: const BorderSide(width: 1, color: AppColorsLight.borderDisable),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(
          color: AppColorsLight.textOnPrimary,
          fontFamily: Constants.fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        backgroundColor: AppColorsLight.primaryColor,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Sizes.borderRadius)),
        elevation: 0,
      ),
    ),
    tabBarTheme: const TabBarTheme(
      indicatorColor: AppColorsLight.primaryColor,
      labelColor: AppColorsLight.primaryColor,
      labelStyle: TextStyle(
        color: AppColorsLight.textOnPrimary,
        fontFamily: Constants.fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
      unselectedLabelStyle: TextStyle(
        color: AppColorsLight.textLightDefault,
        fontFamily: Constants.fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
      dividerColor: AppColorsLight.borderDefault,
      dividerHeight: 0.5,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColorsLight.textLightDefault,
        disabledBackgroundColor: AppColorsLight.surfaceDisabled,
        disabledForegroundColor: AppColorsLight.surfaceDisabled,
        minimumSize: const Size(50, 48),
        elevation: 0,
        textStyle: const TextStyle(
          color: AppColorsLight.textOnPrimary,
          fontFamily: Constants.fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    // navigationBarTheme: NavigationBarThemeData(
    //   backgroundColor: AppColorsLight.backgroundColor,
    //   indicatorColor: AppColorsLight.lightBlue,
    //   labelTextStyle: MaterialStateProperty.resolveWith(
    //     ((states) => getBottomSheetItemStateColor(states)),
    //   ),
    // ),
    // textButtonTheme: TextButtonThemeData(
    //   style: TextButton.styleFrom(
    //     foregroundColor: Colors.grey,
    //     disabledBackgroundColor: AppColorsLight.surfaceDisabled,
    //     disabledForegroundColor: AppColorsLight.surfaceDisabled,
    //     minimumSize: const Size(50, 48),
    //     elevation: 0,
    //   ),
    // ),
  );
}
