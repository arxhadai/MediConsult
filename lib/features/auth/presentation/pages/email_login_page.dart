import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/enums/user_role.dart';
import '../bloc/login/login_bloc.dart';
import '../bloc/login/login_event.dart';
import '../bloc/login/login_state.dart';
import '../widgets/inputs/email_input_field.dart';
import '../widgets/inputs/password_input_field.dart';
import '../widgets/buttons/auth_button.dart';
import '../widgets/buttons/social_login_button.dart';
import '../widgets/common/divider_with_text.dart';

/// Page for email/password login
class EmailLoginPage extends StatefulWidget {
  final UserRole role;

  const EmailLoginPage({
    super.key,
    required this.role,
  });

  @override
  State<EmailLoginPage> createState() => _EmailLoginPageState();
}

class _EmailLoginPageState extends State<EmailLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/home',
              (route) => false,
            );
          } else if (state is LoginError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    _buildHeader(context),
                    const SizedBox(height: 40),
                    // Email input
                    EmailInputField(controller: _emailController),
                    const SizedBox(height: 16),
                    // Password input
                    PasswordInputField(controller: _passwordController),
                    const SizedBox(height: 12),
                    // Forgot password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _onForgotPasswordPressed,
                        child: const Text('Forgot Password?'),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Sign in button
                    AuthButton(
                      text: 'Sign In',
                      isLoading: state is LoginLoading,
                      onPressed: _onSignInPressed,
                    ),
                    const SizedBox(height: 32),
                    // Or divider
                    const DividerWithText(text: 'or continue with'),
                    const SizedBox(height: 24),
                    // Social login
                    SocialLoginButton(
                      provider: SocialProvider.google,
                      onPressed: () {
                        context.read<LoginBloc>().add(
                              LoginGoogleRequested(role: widget.role),
                            );
                      },
                    ),
                    const SizedBox(height: 24),
                    // Register option
                    _buildRegisterOption(context),
                    const SizedBox(height: 16),
                    // Phone login option (for patients)
                    if (widget.role == UserRole.patient)
                      _buildPhoneLoginOption(context),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final roleText = widget.role == UserRole.doctor ? 'Doctor' : 'Patient';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$roleText Sign In',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Enter your email and password to continue',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
        ),
      ],
    );
  }

  Widget _buildRegisterOption(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: TextStyle(color: Colors.grey[600]),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pushNamed(
              '/register',
              arguments: widget.role,
            );
          },
          child: const Text('Sign Up'),
        ),
      ],
    );
  }

  Widget _buildPhoneLoginOption(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pushReplacementNamed(
          '/phone-login',
          arguments: widget.role,
        );
      },
      child: Text(
        'Use phone number instead',
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _onSignInPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<LoginBloc>().add(LoginEmailSubmitted(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          ));
    }
  }

  void _onForgotPasswordPressed() {
    Navigator.of(context).pushNamed('/forgot-password');
  }
}
