// Shared file (all three of us): the text styles of the app.
import 'package:flutter/material.dart';

class AppTextStyles {
  static const String font = 'Poppins'; // our custom font (added in pubspec.yaml)

  static const TextStyle logo = TextStyle(fontSize: 36, fontWeight: FontWeight.bold); // "lexicodeck", card word
  static const TextStyle title = TextStyle(fontSize: 22, fontWeight: FontWeight.bold); // section titles
  static const TextStyle big = TextStyle(fontSize: 32, fontWeight: FontWeight.bold); // big numbers
  static const TextStyle normal = TextStyle(fontSize: 18); // normal bigger text
  static const TextStyle bold = TextStyle(fontWeight: FontWeight.bold); // page titles, deck names
}
