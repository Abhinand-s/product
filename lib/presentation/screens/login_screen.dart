// file for login screen UI and logic
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product/logic/bloc/auth/auth_bloc.dart';

// login screen class
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

// state class for login screen
class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthCodeSentSuccess) {
            Navigator.pushNamed(context, '/otp', arguments: {
              // Navigate to OTP screen
              'phoneNumber':
                  _phoneController.text.trim(), // Pass the phone number
              'otp': state.otp, // Pass the OTP for testing purposes
            });
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(
                child: CircularProgressIndicator()); // Show loading indicator
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),
                  const Text(
                    'Login',
                    style: TextStyle(
                      fontFamily: 'Oxygen', // Using Oxygen font
                      fontSize: 35,
                      fontWeight: FontWeight.w700,
                      height: 1.37,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Let's Connect with Lorem Ipsum..!",
                    style: TextStyle(
                        fontFamily: 'Manrope', // using Manrope font
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF4E4D4D),
                        height: 1.0,
                        letterSpacing: 0),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // 1. A non-interactive TextField for the '+91' prefix
                      const SizedBox(
                        width: 45,
                        child: TextField(
                          enabled: false,
                          decoration: InputDecoration(
                            hintText: '+91',
                            hintStyle: TextStyle(
                              fontFamily: 'Oxygen',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0XFF646363),
                              height: 3.42,
                              letterSpacing: 0,
                            ),
                            contentPadding: EdgeInsets.only(bottom: 1),
                            disabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // 2. An expanded TextFormField for the actual number input
                      Expanded(
                        child: TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          style: const TextStyle(
                              fontFamily: 'Oxygen', // using Oxygen font
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              height: 3.42,
                              letterSpacing: 0,
                              color: Color(0XFF646363)),
                          decoration: const InputDecoration(
                            hintText: 'Enter Phone',
                            contentPadding: EdgeInsets.only(bottom: 1),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            counterText: "",
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(
                              AuthPhoneNumberSubmitted(
                                  _phoneController.text.trim()),
                            );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5E5BE2),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                            fontFamily: 'Oxygen', // using Oxygen font
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            height: 1,
                            letterSpacing: 0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.center,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                            fontFamily: 'Oxygen', // using Oxygen font
                            color: Color(0XFF000000),
                            fontSize: 13,
                            fontWeight: FontWeight.w300,
                            height: 1.5,
                            wordSpacing: 2,
                            letterSpacing: 0),
                        children: const <TextSpan>[
                          TextSpan(text: 'By Continuing you accepting the '),
                          TextSpan(
                            text: 'Terms of Use & Privacy Policy',
                            style: TextStyle(
                              fontFamily: 'Oxygen', // using Oxygen font
                              fontSize: 14,
                              wordSpacing: 2,
                              letterSpacing: 0,
                              color: Color(0XFF000000),
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
