import 'package:ec/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // For Google icon
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart'
    as app_auth; // Added prefix to resolve ambiguity

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  bool _isGoogleUser(User? user) {
    return user?.providerData
            .any((profile) => profile.providerId == 'google.com') ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<app_auth.AuthProvider>(
        context); // Using prefixed AuthProvider
    final theme = Theme.of(context);
    final user = authProvider.user;
    final isGoogleUser = _isGoogleUser(user);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User Avatar - Only show profile picture for Google users
                    Center(
                      child: isGoogleUser && user?.photoURL != null
                          ? Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(user!.photoURL!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: theme.primaryColor.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.person,
                                size: 40,
                                color: theme.primaryColor,
                              ),
                            ),
                    ),
                    const SizedBox(height: 16),

                    // Display Name - Only for Google users
                    if (isGoogleUser && user?.displayName != null) ...[
                      Text(
                        'Name',
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user?.displayName ?? '',
                        style: theme.textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Email Label
                    Text(
                      'Email',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 4),

                    // Email Value
                    Text(
                      user?.email ?? 'No email available',
                      style: theme.textTheme.bodyLarge,
                    ),

                    // Sign-in Method
                    const SizedBox(height: 16),
                    Text(
                      'Sign-in Method',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          isGoogleUser
                              ? FontAwesomeIcons
                                  .google // Using FontAwesome for Google icon
                              : Icons.email,
                          size: 20,
                          color: theme.primaryColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isGoogleUser ? 'Google' : 'Email/Password',
                          style: theme.textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // Logout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  try {
                    await authProvider.signOut();
                    if (context.mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(e.toString()),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
