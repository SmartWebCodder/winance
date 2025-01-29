import 'package:flutter/material.dart';
import 'package:winance/screens/splash/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Winance',
      theme: ThemeData(
        primarySwatch: Colors.blue, // Your primary color
        // Define the TextTheme using IBM Plex Sans
        textTheme: TextTheme(
          bodyLarge: TextStyle(
              fontFamily: 'IBMPlexSans', fontSize: 16), // Replaces bodyText1
          bodyMedium: TextStyle(
              fontFamily: 'IBMPlexSans', fontSize: 14), // Replaces bodyText2
          displayLarge: TextStyle(
              fontFamily: 'IBMPlexSans',
              fontSize: 96,
              fontWeight: FontWeight.bold), // Replaces headline1
          displayMedium: TextStyle(
              fontFamily: 'IBMPlexSans',
              fontSize: 60,
              fontWeight: FontWeight.bold), // Replaces headline2
          displaySmall: TextStyle(
              fontFamily: 'IBMPlexSans',
              fontSize: 48,
              fontWeight: FontWeight.bold), // Replaces headline3
          headlineLarge: TextStyle(
              fontFamily: 'IBMPlexSans',
              fontSize: 34,
              fontWeight: FontWeight.bold), // Replaces headline4
          headlineMedium: TextStyle(
              fontFamily: 'IBMPlexSans',
              fontSize: 24,
              fontWeight: FontWeight.bold), // Replaces headline5
          headlineSmall: TextStyle(
              fontFamily: 'IBMPlexSans',
              fontSize: 20,
              fontWeight: FontWeight.bold), // Replaces headline6
          titleLarge: TextStyle(
              fontFamily: 'IBMPlexSans', fontSize: 16), // Replaces subtitle1
          titleMedium: TextStyle(
              fontFamily: 'IBMPlexSans', fontSize: 14), // Replaces subtitle2
          labelLarge: TextStyle(
              fontFamily: 'IBMPlexSans',
              fontSize: 14,
              fontWeight: FontWeight.bold), // Replaces button
          bodySmall: TextStyle(
              fontFamily: 'IBMPlexSans', fontSize: 12), // Replaces caption
          labelSmall: TextStyle(
              fontFamily: 'IBMPlexSans', fontSize: 10), // Replaces overline
        ),
      ),
      home: SplashScreen(), // Your splash screen
    );
  }
}
