# Lexicodeck

A flashcard app for learning vocabulary, built with Flutter. Cards are reviewed with spaced repetition, so words you struggle with show up more often and words you know show up less.

## Group 18

- TA: Beyzagül Demir
- Step 1 coordinator: Çağan Aydınyüz

| Name | Student ID | GitHub |
|---|---|---|
| Çağan Aydınyüz | 35541 | cagkag |
| Emre Alp Keskin | 35684 | EmreAlpKeskin |
| İsmet Arda Uçar | 35512 | IridiumM |

## Step 1: Project proposal

What the app will do:

- Make decks and cards (word, translation, example sentence)
- Daily review of the cards that are due, rated Again / Hard / Good / Easy
- Stats: cards learned, accuracy, daily streak
- Local SQLite database

If we have time: reminder notifications, CSV import/export, text-to-speech.

## Step 2.1: Wireframes

We drew wireframes for 12 screens and split them between us:

- Çağan: Welcome, Home, Review Session, Settings
- İsmet: Log In, Decks, Deck Detail, Add Card
- Emre: Sign Up, Create/Edit Deck, Session Complete, Statistics

## Step 2.2: UI implementation

We built all 12 screens from our wireframes and connected them with navigation. For now the app is only UI: it shows sample data and saves nothing. Log in, sign up and continue as a guest just open Home.

- Code: `lib/main.dart`
- Shared colors, text styles and spacing: `lib/app_colors.dart`, `lib/app_text_styles.dart`, `lib/app_spacing.dart`
- Local image: the logo on the Welcome page (`assets/images/`)
- Network images: the flags on the deck tiles
- Custom font: Poppins (`assets/fonts/`)
- Removing a card: Deck Detail page
- Forms with validation and a dialog: Add Card, Create/Edit Deck
- Dark mode: Settings page

## Running it

Flutter version: 3.35.6

```bash
git clone https://github.com/EmreAlpKeskin/CS310-Project-Group-18-
cd CS310-Project-Group-18-
flutter pub get
flutter run
```

Run it on an Android emulator or a phone. The flag images need internet.

