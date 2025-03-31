import 'package:flutter/material.dart';
import 'package:rickandmorty/common/theme/app_colors.dart';

class AppTheme {
  // Светлая тема
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.green,
    highlightColor: AppColors.lightBgSecondary,
    scaffoldBackgroundColor: AppColors.lightBgPrimary,
    colorScheme: const ColorScheme.light(
      primary: AppColors.green,
      secondary: AppColors.green,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.textPrimaryLight, fontSize: 16),
      bodyMedium: TextStyle(color: AppColors.textSecondaryLight, fontSize: 14),
      bodySmall: TextStyle(color: AppColors.textTertiaryLight, fontSize: 12),
      titleLarge: TextStyle(color: AppColors.textPrimaryLight, fontSize: 20),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.lightBgPrimary,
      selectedItemColor: AppColors.green,
      unselectedItemColor: AppColors.textPrimaryLight,
      showSelectedLabels: true,
      showUnselectedLabels: true,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightBgPrimary,
      foregroundColor: AppColors.lightBgPrimary,
      titleTextStyle: TextStyle(
        color: AppColors.textPrimaryLight,
        fontSize: 20,
      ),
      shadowColor: Colors.transparent,
      iconTheme: IconThemeData(color: AppColors.textPrimaryLight),
      surfaceTintColor: Colors.transparent,
    ),
    dividerColor: AppColors.lightBgPrimary,
    dividerTheme: const DividerThemeData(
      color: AppColors.lightBgPrimary,
      thickness: 2,
    ),
    tabBarTheme: TabBarTheme(
      labelColor: AppColors.textPrimaryLight,
      indicatorColor: AppColors.textPrimaryLight,
      unselectedLabelColor: AppColors.textTertiaryLight,
      overlayColor:
          WidgetStateProperty.all(AppColors.textPrimaryLight.withOpacity(0.1)),
      dividerHeight: 0,
    ),
    searchBarTheme: const SearchBarThemeData(
      hintStyle: WidgetStatePropertyAll(
        TextStyle(color: AppColors.textTertiaryLight),
      ),
      shadowColor: null,
      elevation: WidgetStatePropertyAll(0),
      backgroundColor: WidgetStatePropertyAll(AppColors.lightBgSecondary),
    ),
  );

  // Темная тема
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.green,
    highlightColor: AppColors.darkBgSecondary,
    scaffoldBackgroundColor: AppColors.darkBgPrimary,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.green,
      secondary: AppColors.green,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.textPrimary, fontSize: 16),
      bodyMedium: TextStyle(color: AppColors.textSecondary, fontSize: 14),
      bodySmall: TextStyle(color: AppColors.textTertiary, fontSize: 12),
      titleLarge: TextStyle(color: AppColors.textPrimary, fontSize: 20),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkBgSecondary,
      selectedItemColor: AppColors.green,
      unselectedItemColor: AppColors.textPrimary,
      showSelectedLabels: true,
      showUnselectedLabels: true,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBgPrimary,
      foregroundColor: AppColors.darkBgPrimary,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(color: AppColors.textPrimary, fontSize: 20),
      iconTheme: IconThemeData(color: AppColors.textPrimary),
    ),
    dividerColor: AppColors.darkBgSecondary,
    dividerTheme: const DividerThemeData(
      color: AppColors.darkBgSecondary,
      thickness: 1,
    ),
    tabBarTheme: TabBarTheme(
      labelColor: AppColors.textPrimary,
      indicatorColor: AppColors.textPrimary,
      unselectedLabelColor: AppColors.textTertiary,
      overlayColor:
          WidgetStateProperty.all(AppColors.textPrimary.withOpacity(0.1)),
      dividerHeight: 0,
    ),
    searchBarTheme: const SearchBarThemeData(
      hintStyle: WidgetStatePropertyAll(
        TextStyle(color: AppColors.textTertiary),
      ),
      shadowColor: null,
      elevation: WidgetStatePropertyAll(0),
      backgroundColor: WidgetStatePropertyAll(AppColors.darkBgSecondary),
    ),
  );
}
