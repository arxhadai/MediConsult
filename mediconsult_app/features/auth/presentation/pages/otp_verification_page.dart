import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/enums/user_role.dart';
import '../bloc/login/login_bloc.dart';
import '../bloc/login/login_event.dart';
import '../bloc/login/login_state.dart';
import '../widgets/inputs/otp_input_field.dart';
import '../widgets/buttons/auth_button.dart';

/// Page for OTP verification
class OtpVerificationPage extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;
  final UserRole role;

  const OtpVerificationPage({
    super.key,
    required this.verificationId,
    required this.phoneNumber,
    required this.role,
  });

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final _otpController = TextEditingController();
  int _resendCountdown = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _resendCountdown = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown > 0) {
        setState(() => _resendCountdown--);
      } else {
        timer.cancel();
      }
    });
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
            // Navigate to home
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/home',
              (route) => false,
            );
          } else if (state is LoginOtpSent) {
            // OTP resent
            _startCountdown();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Verification code sent'),
                backgroundColor: Colors.green,
              ),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  _buildHeader(context),
                  const SizedBox(height: 40),
                  // OTP input
                  OtpInputField(
                    controller: _otpController,
                    length: 6,
                    onCompleted: (otp) => _onVerifyPressed(otp),
                  ),
                  const SizedBox(height: 32),
                  // Verify button
                  AuthButton(
                    text: 'Verify',
                    isLoading: state is LoginLoading,
                    onPressed: () => _onVerifyPressed(_otpController.text),
                  ),
                  const SizedBox(height: 24),
                  // Resend code
                  _buildResendOption(context, state),
                ],
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
          'Verification Code',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Enter the 6-digit code sent to',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
        ),
        const SizedBox(height: 4),
        Text(
          widget.phoneNumber,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }

  Widget _buildResendOption(BuildContext context, LoginState state) {
    return Center(
      child: _resendCountdown > 0
          ? Text(
              'Resend code in ${_resendCountdown}s',
              style: TextStyle(color: Colors.grey[600]),
            )
          : TextButton(
              onPressed: state is LoginLoading ? null : _onResendPressed,
              child: Text(
                'Resend Code',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
    );
  }

  void _onVerifyPressed(String otp) {
    if (otp.length == 6) {
      context.read<LoginBloc>().add(LoginOtpSubmitted(
            verificationId: widget.verificationId,
            otp: otp,
            role: widget.role,
          ));
    }
  }

  void _onResendPressed() {
    context.read<LoginBloc>().add(LoginOtpResendRequested(widget.phoneNumber));
  }
}
