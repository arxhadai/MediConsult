import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/enums/user_role.dart';
import '../bloc/registration/registration_bloc.dart';
import '../bloc/registration/registration_event.dart';
import '../bloc/registration/registration_state.dart';
import '../widgets/inputs/email_input_field.dart';
import '../widgets/inputs/password_input_field.dart';
import '../widgets/inputs/password_strength_indicator.dart';
import '../widgets/buttons/auth_button.dart';
import '../widgets/common/terms_checkbox.dart';

/// Page for user registration
class RegistrationPage extends StatefulWidget {
  final UserRole role;

  const RegistrationPage({
    super.key,
    required this.role,
  });

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _termsAccepted = false;
  PasswordStrength _passwordStrength = PasswordStrength.weak;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
      body: BlocConsumer<RegistrationBloc, RegistrationState>(
        listener: (context, state) {
          if (state is RegistrationSuccess) {
            if (state.requiresVerification) {
              Navigator.of(context).pushNamed('/doctor-verification');
            } else {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/home',
                (route) => false,
              );
            }
          } else if (state is RegistrationPasswordStrength) {
            setState(() => _passwordStrength = state.strength);
          } else if (state is RegistrationError) {
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
                    const SizedBox(height: 32),
                    // Name input
                    _buildNameInput(),
                    const SizedBox(height: 16),
                    // Email input
                    EmailInputField(controller: _emailController),
                    const SizedBox(height: 16),
                    // Password input
                    PasswordInputField(
                      controller: _passwordController,
                      onChanged: (value) {
                        context.read<RegistrationBloc>().add(
                              RegistrationPasswordValidated(value),
                            );
                      },
                    ),
                    const SizedBox(height: 8),
                    // Password strength indicator
                    PasswordStrengthIndicator(strength: _passwordStrength),
                    const SizedBox(height: 16),
                    // Confirm password
                    PasswordInputField(
                      controller: _confirmPasswordController,
                      labelText: 'Confirm Password',
                      validator: (value) {
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    // Terms checkbox
                    TermsCheckbox(
                      value: _termsAccepted,
                      onChanged: (value) {
                        setState(() => _termsAccepted = value ?? false);
                      },
                    ),
                    const SizedBox(height: 24),
                    // Register button
                    AuthButton(
                      text: 'Create Account',
                      isLoading: state is RegistrationLoading,
                      onPressed: _termsAccepted ? _onRegisterPressed : null,
                    ),
                    const SizedBox(height: 24),
                    // Login option
                    _buildLoginOption(context),
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
          'Create $roleText Account',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.role == UserRole.doctor
              ? 'Register to manage your practice'
              : 'Register to book consultations',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
        ),
      ],
    );
  }

  Widget _buildNameInput() {
    return TextFormField(
      controller: _nameController,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: 'Full Name',
        hintText: 'Enter your full name',
        prefixIcon: const Icon(Icons.person_outline),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
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
    );
  }

  Widget _buildLoginOption(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: TextStyle(color: Colors.grey[600]),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Sign In'),
        ),
      ],
    );
  }

  void _onRegisterPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<RegistrationBloc>().add(RegistrationEmailSubmitted(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            displayName: _nameController.text.trim(),
            role: widget.role,
          ));
    }
  }
}
