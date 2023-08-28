import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:users_chat_flutter/screens/auth.dart';

final colorScheme = ColorScheme.fromSeed(
  brightness: Brightness.light,
  seedColor: const Color.fromARGB(255, 102, 6, 247),
  background: const Color.fromARGB(255, 56, 49, 66),
);

final theme = ThemeData().copyWith(
  useMaterial3: true,
  scaffoldBackgroundColor: colorScheme.background,
  colorScheme: colorScheme,
  textTheme: GoogleFonts.interTextTheme().copyWith(
    titleSmall: GoogleFonts.inter(
      fontWeight: FontWeight.bold,
    ),
    titleMedium: GoogleFonts.inter(
      fontWeight: FontWeight.bold,
    ),
    titleLarge: GoogleFonts.inter(
      fontWeight: FontWeight.bold,
    ),
  ),
);

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Great Places',
      theme: theme,
      home: const AuthScreens(),
    );
  }
}
