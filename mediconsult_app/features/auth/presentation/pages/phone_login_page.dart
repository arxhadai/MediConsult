import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/enums/user_role.dart';
import '../bloc/login/login_bloc.dart';
import '../bloc/login/login_event.dart';
import '../bloc/login/login_state.dart';
import '../widgets/inputs/phone_input_field.dart';
import '../widgets/buttons/auth_button.dart';
import '../widgets/buttons/social_login_button.dart';
import '../widgets/common/divider_with_text.dart';

/// Page for phone number login
class PhoneLoginPage extends StatefulWidget {
  final UserRole role;

  const PhoneLoginPage({
    super.key,
    required this.role,
  });

  @override
  State<PhoneLoginPage> createState() => _PhoneLoginPageState();
}

class _PhoneLoginPageState extends State<PhoneLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  String _selectedCountryCode = '+1';

  @override
  void dispose() {
    _phoneController.dispose();
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
          if (state is LoginOtpSent) {
            Navigator.of(context).pushNamed(
              '/otp-verification',
              arguments: {
                'verificationId': state.verificationId,
                'phoneNumber': state.phoneNumber,
                'role': widget.role,
              },
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
                    // Phone input
                    PhoneInputField(
                      controller: _phoneController,
                      selectedCountryCode: _selectedCountryCode,
                      onCountryCodeChanged: (code) {
                        setState(() => _selectedCountryCode = code);
                      },
                    ),
                    const SizedBox(height: 24),
                    // Continue button
                    AuthButton(
                      text: 'Continue',
                      isLoading: state is LoginLoading,
                      onPressed: _onContinuePressed,
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
                    // Email login option
                    _buildEmailLoginOption(context),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enter your phone number',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'We\'ll send you a verification code',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
        ),
      ],
    );
  }

  Widget _buildEmailLoginOption(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pushReplacementNamed(
          '/email-login',
          arguments: widget.role,
        );
      },
      child: Text(
        'Use email instead',
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _onContinuePressed() {
    if (_formKey.currentState?.validate() ?? false) {
      final phoneNumber = '$_selectedCountryCode${_phoneController.text.trim()}';
      context.read<LoginBloc>().add(LoginPhoneSubmitted(phoneNumber));
    }
  }
}
