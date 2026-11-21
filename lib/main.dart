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


// Shows a "Done!" popup with a message.
// OK closes the popup and goes back one page.
void showDoneDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Done!'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(dialogContext); // close the popup
            Navigator.pop(context); // go back one page
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

// Flashcard: one word card (word, translation, example sentence).
class Flashcard {
  final String word;
  final String translation;
  final String example; // optional, empty if not given

  const Flashcard(this.word, this.translation, {this.example = ''});
}

// Deck: a group of flashcards between two languages.
class Deck {
  final String name;
  final String flagUrl; // link to a flag picture on the internet
  final int cardCount; // total cards (shown as text)
  final int dueCount; // cards to review today (shown as text)
  final List<Flashcard> cards;

  const Deck(this.name, this.flagUrl, this.cardCount, this.dueCount, this.cards);
}

// Sample decks shown in the app (fake data, nothing is saved).
// Deck(name, flag link, card count, due count, cards)
const List<Deck> sampleDecks = [
  Deck('English - Turkish', 'https://flagcdn.com/w80/tr.png', 130, 30, [
    Flashcard('Kitap', 'Book', example: 'I am reading a book.'),
    Flashcard('Elma', 'Apple'),
    Flashcard('Armut', 'Pear'),
    Flashcard('Su', 'Water', example: 'Can I have some water?'),
  ]),
  Deck('Japanese - English', 'https://flagcdn.com/w80/jp.png', 40, 31, [
    Flashcard('Neko', 'Cat'),
    Flashcard('Mizu', 'Water'),
    Flashcard('Hon', 'Book'),
  ]),
];

// #####################################################################
// CAGAN'S PAGES: Welcome, Home, Review Session, Settings
// #####################################################################

// Page 1, Welcome: first page, with Log in / Sign up / guest buttons.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          // Scrolls on small phones, so nothing overflows.
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.large),
            child: Column(
              children: [
                // Local image from the assets/images folder.
                Image.asset('assets/images/cards_stack.png', height: 150),
                const SizedBox(height: AppSpacing.medium),
                const Text('lexicodeck', style: AppTextStyles.logo),
                const SizedBox(height: AppSpacing.small),
                const Text('Learn words, one card at a time.'),
                const SizedBox(height: 50),
                ActionButton('Log in', onPressed: () => openPage(context, const LoginScreen())),
                const SizedBox(height: 12),
                ActionButton('Sign up', onPressed: () => openPage(context, const SignUpScreen())),
                // Guest: goes straight to Home.
                TextButton(
                    onPressed: () => openPage(context, const HomeScreen()),
                    child: const Text('Continue as a guest')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Page 4, Home: streak card and your decks.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PageContent(title: 'Home', showTabs: true, children: [
      const Text('Welcome to Lexicodeck!', style: AppTextStyles.title),
      const SizedBox(height: AppSpacing.medium),
      // Streak card: fire icon + "5 day streak".
      const Card(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.page),
          child: Row(children: [
            Icon(Icons.local_fire_department, color: AppColors.streak, size: 38),
            SizedBox(width: 12),
            Expanded(child: Text('5 day streak', style: AppTextStyles.normal)),
          ]),
        ),
      ),
      const SizedBox(height: AppSpacing.medium),
      // "Your decks" on the left, "See all" on the right.
      Row(children: [
        const Expanded(child: Text('Your decks', style: AppTextStyles.title)),
        TextButton(onPressed: () => openPage(context, const DeckListScreen()), child: const Text('See all')),
      ]),
      // One DeckTile for every deck in sampleDecks.
      Column(children: sampleDecks.map((deck) => DeckTile(deck, onHome: true)).toList()),
    ]);
  }
}

// Page 9, Review Session: shows a word, Reveal shows the answer.
class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  bool revealed = false; // false = answer hidden, true = answer shown

  // One rating button. All four open Session Complete.
  Widget ratingButton(String text) {
    return ElevatedButton(
      onPressed: () => openPage(context, const SessionCompleteScreen()),
      child: Text(text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageContent(title: 'Review Session', children: [
      const Center(child: Text('3/30', style: AppTextStyles.normal)), // card 3 of 30
      const SizedBox(height: AppSpacing.large),
      const Center(child: Text('Guess!', style: AppTextStyles.title)),
      const SizedBox(height: 15),
      // The card with the word.
      const Card(
        child: SizedBox(
          height: 140,
          child: Center(child: Text('apple', style: AppTextStyles.logo)),
        ),
      ),
      const SizedBox(height: 15),
      // If revealed: translation + rating buttons. If not: Reveal button.
      revealed
          ? Column(children: [
              const Text('Translation: elma', style: AppTextStyles.normal),
              const SizedBox(height: AppSpacing.medium),
              // Wrap: buttons go to the next line if the screen is narrow.
              Wrap(spacing: 8, runSpacing: 8, children: [
                ratingButton('Again'),
                ratingButton('Hard'),
                ratingButton('Good'),
                ratingButton('Easy'),
              ]),
            ])
          : ActionButton('Reveal', onPressed: () {
              setState(() {
                revealed = true; // rebuild the page with the answer shown
              });
            }),
      const SizedBox(height: AppSpacing.large),
      // Leave Early: go back to the previous page.
      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Leave Early')),
    ]);
  }
}

// Page 12, Settings: dark mode, notifications, account, logout.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notifications = false; // only moves the switch, nothing is saved

  @override
  Widget build(BuildContext context) {
    return PageContent(title: 'Settings', showTabs: true, children: [
      // Dark mode row.
      Card(
        child: ListTile(
          leading: const Icon(Icons.dark_mode),
          title: const Text('Dark mode'),
          trailing: Switch(
            value: darkModeOn,
            onChanged: (bool value) {
              changeDarkMode(value); // change the theme of the whole app
              setState(() {}); // redraw this page so the switch moves
            },
          ),
        ),
      ),
      // Notifications row.
      Card(
        child: ListTile(
          leading: const Icon(Icons.notifications),
          title: const Text('Notifications'),
          trailing: Switch(
            value: notifications,
            onChanged: (bool value) {
              setState(() {
                notifications = value;
              });
            },
          ),
        ),
      ),
      // Account info row (fake email).
      const Card(
        child: ListTile(
          leading: Icon(Icons.person),
          title: Text('Account info'),
          subtitle: Text('example@email.com'),
        ),
      ),
      const SizedBox(height: AppSpacing.large),
      ActionButton('Logout', onPressed: () => openPage(context, const WelcomeScreen())),
      // Red text button, does nothing (UI only).
      TextButton(
        onPressed: () {},
        child: const Text('Delete account', style: TextStyle(color: AppColors.danger)),
      ),
    ]);
  }
}
