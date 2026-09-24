import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../utils/responsive_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Kasun Bandara');
  final _emailController = TextEditingController(text: 'kasun.b@campus.ac.lk');
  final _studentIdController = TextEditingController(text: 'STU-2026-4412');
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _studentIdController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      final appState = Provider.of<AppState>(context, listen: false);
      appState.login(
        name: _nameController.text,
        email: _emailController.text,
        studentId: _studentIdController.text,
      );

      Future.delayed(const Duration(milliseconds: 400), () {
        if (mounted) {
          setState(() => _isLoading = false);
          Navigator.pushReplacementNamed(context, '/home');
        }
      });
    }
  }

  void _handleGuestAccess() {
    setState(() => _isLoading = true);
    final appState = Provider.of<AppState>(context, listen: false);
    appState.continueAsGuest();

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.pushReplacementNamed(context, '/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: ResponsiveLayout.isTablet(context) || ResponsiveLayout.isDesktop(context) ? 480 : double.infinity,
              ),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                  side: const BorderSide(color: AppTheme.borderLight),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Header
                        Center(
                          child: Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryLight,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.school_rounded,
                              size: 34,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Center(
                          child: Text(
                            'Student Sign In',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Center(
                          child: Text(
                            'Enter your campus details or continue as guest',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Full Name Input
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Full Name',
                            hintText: 'e.g. Kasun Bandara',
                            prefixIcon: Icon(Icons.person_outline_rounded, color: AppTheme.primaryColor),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your name';
                            }
                            if (value.trim().length < 2) {
                              return 'Name must be at least 2 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Campus Email Input
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Campus Email',
                            hintText: 'e.g. student@campus.ac.lk',
                            prefixIcon: Icon(Icons.email_outlined, color: AppTheme.primaryColor),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!value.contains('@') || !value.contains('.')) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Student ID Input
                        TextFormField(
                          controller: _studentIdController,
                          decoration: const InputDecoration(
                            labelText: 'Student ID / Registration No.',
                            hintText: 'e.g. STU-2026-4412',
                            prefixIcon: Icon(Icons.badge_outlined, color: AppTheme.primaryColor),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your student ID';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        // Login Button
                        ElevatedButton(
                          onPressed: _isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                                )
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.login_rounded, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      'SIGN IN TO ORDER',
                                      style: TextStyle(fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                        ),
                        const SizedBox(height: 14),

                        // Divider
                        const Row(
                          children: [
                            Expanded(child: Divider(color: AppTheme.borderLight)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                'OR',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textMuted,
                                ),
                              ),
                            ),
                            Expanded(child: Divider(color: AppTheme.borderLight)),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Guest Access Button
                        OutlinedButton(
                          onPressed: _isLoading ? null : _handleGuestAccess,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.person_outline_rounded, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Continue as Guest',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
