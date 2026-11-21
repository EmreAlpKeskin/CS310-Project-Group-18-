# Lexicodeck

A flashcard app for learning vocabulary, built with Flutter (CS310, Group 18).

| Name | Student ID | GitHub |
|---|---|---|
| Çağan Aydınyüz | 35541 | cagkag |
| Emre Alp Keskin | 35684 | EmreAlpKeskin |
| İsmet Arda Uçar | 35512 | IridiumM |

TA: Beyzagül Demir

## Step 2.2: UI implementation

All screens from our Step 2.1 wireframes are implemented with working navigation. The app is **UI only**: it shows sample data and saves nothing. Log in, sign up and guest mode just open Home. Firebase comes in Step 3.

- Code: `lib/main.dart`
- Shared style files: `lib/app_colors.dart`, `lib/app_text_styles.dart`, `lib/app_spacing.dart`
- Reusable widgets: shared section of `lib/main.dart`
- Local image: `assets/images/cards_stack.png` (Welcome)
- Network images: deck flags (DeckTile)
- Custom font: Poppins (`assets/fonts/`, declared in `pubspec.yaml`)
- Card list with a working remove action: Deck Detail
- Forms with inline validation and a confirmation dialog: Create Deck, Add Card
- Dark mode: Settings
- No overflow on small or large phones: pages scroll (ListView), rows use Expanded

## Running it

Flutter version: **3.35.6** (stable, Dart 3.9.2).

```bash
git clone https://github.com/EmreAlpKeskin/CS310-Project-Group-18-
cd CS310-Project-Group-18-
flutter pub get
flutter run
```

Run it on an Android emulator or iOS simulator. The flag images need internet.
