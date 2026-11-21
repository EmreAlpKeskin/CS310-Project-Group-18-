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

// =====================================================================
// SHARED PART (all three of us): reusable widgets + data
// =====================================================================

// Opens a new page on top of the current one. The back arrow closes it.
void openPage(BuildContext context, Widget page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

// PageContent: the layout every page uses.
// Top bar with the page title, then the page's widgets in a ListView.
// ListView scrolls, so nothing overflows on small phones.
class PageContent extends StatelessWidget {
  final String title; // text in the top bar
  final List<Widget> children; // widgets of the page
  final bool showTabs; // true = show the bottom bar

  const PageContent({super.key, required this.title, required this.children, this.showTabs = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title, style: AppTextStyles.bold)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.page),
          children: children,
        ),
      ),
      bottomNavigationBar: showTabs ? const BottomTabs() : null,
    );
  }
}

// BottomTabs: the bar at the bottom of Home, Decks, Stats and Settings.
// Three buttons: Decks, Stats, Settings.
class BottomTabs extends StatelessWidget {
  const BottomTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // Expanded: the 3 buttons share the width equally.
      child: Row(
        children: [
          Expanded(child: TabButton(Icons.style, 'Decks', () => openPage(context, const DeckListScreen()))),
          Expanded(
              child: TabButton(Icons.bar_chart, 'Stats', () => openPage(context, const StatisticsScreen()))),
          Expanded(
              child: TabButton(Icons.settings, 'Settings', () => openPage(context, const SettingsScreen()))),
        ],
      ),
    );
  }
}

// TabButton: one button of the bottom bar (icon on top, label under it).
class TabButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed; // what happens when tapped
  const TabButton(this.icon, this.label, this.onPressed, {super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      // MainAxisSize.min: the Column is only as tall as the icon + text.
      child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(icon), Text(label)]),
    );
  }
}

// ActionButton: the big blue full-width button.
class ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed; // can be empty (button does nothing)
  const ActionButton(this.text, {super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // full width
      child: ElevatedButton(
        onPressed: onPressed ?? () {}, // if no onPressed is given, do nothing
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white, // text color
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        child: Text(text),
      ),
    );
  }
}

// InputBox: a text field with a label and a border.
// password: true hides the text with dots.
// validator: checks the text; its message is shown in red under the field.
class InputBox extends StatelessWidget {
  final String label; // title of the field
  final String hint; // grey example text inside the field
  final bool password;
  final String? Function(String?)? validator;

  const InputBox(this.label, {super.key, this.hint = '', this.password = false, this.validator});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14), // gap under each field
      child: TextFormField(
        obscureText: password,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}

// Validator for fields that can't be empty.
// Returns an error text if empty, null if OK.
String? requiredField(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'This field is required';
  }
  return null;
}

// DeckTile: one deck shown as a Card (flag, name, card counts).
// The flag picture is a network image (needs internet).
// onHome: true  -> play button, opens Review Session (used on Home)
// onHome: false -> gear button, opens Deck Detail (used on Decks page)
class DeckTile extends StatelessWidget {
  final Deck deck;
  final bool onHome;
  const DeckTile(this.deck, {super.key, this.onHome = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        // SizedBox keeps the flag small, even if it can't load.
        leading: SizedBox(width: 40, height: 30, child: Image.network(deck.flagUrl)),
        title: Text(deck.name, style: AppTextStyles.bold),
        subtitle: Text('${deck.cardCount} cards, ${deck.dueCount} due'),
        trailing: onHome
            ? IconButton(
                icon: const Icon(Icons.play_arrow),
                onPressed: () => openPage(context, const ReviewScreen()),
              )
            : IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () => openPage(context, DeckDetailScreen(deck: deck)),
              ),
      ),
    );
  }
}

