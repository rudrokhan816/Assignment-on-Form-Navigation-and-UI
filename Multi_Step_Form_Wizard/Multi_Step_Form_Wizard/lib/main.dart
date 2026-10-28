import 'package:flutter/material.dart';
import 'screens/wizard_screen.dart';

void main() {
  runApp(const FormWizardApp());
}

class FormWizardApp extends StatelessWidget {
  const FormWizardApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF6254D9);
    return MaterialApp(
      title: 'Form Wizard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: seed),
        scaffoldBackgroundColor: const Color(0xFFF6F7FB),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE1E4EF)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: seed, width: 1.6),
          ),
        ),
      ),
      home: const WizardScreen(),
    );
  }
}
