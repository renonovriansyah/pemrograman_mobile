import 'package:flutter/material.dart';
// Ganti 'form_feedback_app' jika nama package proyek Anda berbeda
import 'package:form_feedback_app/screens/feedback_form_screen.dart'; 

void main() {
  runApp(const FormFeedbackApp());
}

class FormFeedbackApp extends StatelessWidget {
  const FormFeedbackApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Set up the main application theme with a modern, clean look
    return MaterialApp(
      title: 'Feedback Form App',
      theme: ThemeData(
        // Primary colors for a vibrant, modern feel
        primarySwatch: Colors.cyan, 
        primaryColor: const Color(0xFF00bcd4), // Teal/Cyan accent color
        scaffoldBackgroundColor: const Color(0xFFE0F7FA), // Light background for contrast
        
        // Custom styling for input fields to support glassmorphism aesthetic
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white.withAlpha(230), // Slightly transparent white fill (Opacity 0.90)
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Color(0xFF00bcd4), width: 1.5), // Highlight border
          ),
          errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
        ),
        fontFamily: 'Inter', // Using a clean, modern font
      ),
      home: const FeedbackFormScreen(), 
      debugShowCheckedModeBanner: false,
    );
  }
}