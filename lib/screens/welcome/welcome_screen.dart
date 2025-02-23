// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:diabetes_detection/widgets/custom_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // App Logo or Animation
              Lottie.asset(
                'assets/animations/medical_welcome.json',
                height: 250,
              ),
              const SizedBox(height: 32),
              Text(
                'Welcome to EyeDiab',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Early detection for better health management',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              CustomButton(
                onPressed: () => Navigator.pushNamed(context, '/login'),
                text: 'Login',
                icon: Icons.login, style: null,
              ),
              const SizedBox(height: 16),
              CustomButton(
                onPressed: () => Navigator.pushNamed(context, '/signup'),
                text: 'Create Account',
                icon: Icons.person_add,
                style: CustomButtonStyle.outlined,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomButtonStyle {
  static var outlined;
}