// Lexicodeck - CS310 Group 18, Step 2.2
// UI only: nothing is saved. Buttons only move between pages.
import 'package:flutter/material.dart';

import 'app_colors.dart'; // our colors
import 'app_spacing.dart'; // our padding / gap sizes
import 'app_text_styles.dart'; // our text styles and font

// =====================================================================
// SHARED PART (all three of us): app start + theme
// =====================================================================

// The app starts here.
void main() {
  runApp(const LexicodeckApp());
}

// The Settings page calls this to turn dark mode on or off.
// It is empty at first; LexicodeckApp fills it in initState.
void Function(bool isDark) changeDarkMode = (bool isDark) {};

// true = dark mode is on. The Settings switch reads this.
bool darkModeOn = false;

// The whole app. Stateful, because the theme (light/dark) can change.
class LexicodeckApp extends StatefulWidget {
  const LexicodeckApp({super.key});

  @override
  State<LexicodeckApp> createState() => _LexicodeckAppState();
}

class _LexicodeckAppState extends State<LexicodeckApp> {
  @override
  void initState() {
    super.initState();
    // Now changeDarkMode really changes the theme: it sets darkModeOn
    // and setState rebuilds the app with the other theme.
    changeDarkMode = (bool isDark) {
      setState(() {
        darkModeOn = isDark;
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // hides the "DEBUG" label
      title: 'Lexicodeck',
      // Light theme: Poppins font, colors made from our blue.
      theme: ThemeData(
        fontFamily: AppTextStyles.font,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
      ),
      // Dark theme: same, but dark colors.
      darkTheme: ThemeData(
        fontFamily: AppTextStyles.font,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      // Which theme to use right now.
      themeMode: darkModeOn ? ThemeMode.dark : ThemeMode.light,
      home: const WelcomeScreen(), // first page
    );
  }
}
