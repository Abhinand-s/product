//file for OTP verification screen
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:product/logic/bloc/auth/auth_bloc.dart';

// OtpScreen widget for OTP verification
class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  final int otp;
  const OtpScreen({super.key, required this.phoneNumber, required this.otp});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _otpController = TextEditingController();
  Timer? _timer;
  int _start = 120;
// Timer function to start countdown
  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 76,
      height: 58,
      textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.black,
          letterSpacing: 0,
          height: 1.0),
      decoration: BoxDecoration(
        // decoration for the OTP input fields
        color: const Color(0XFFF6F6F6),
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          stops: const [0, 1],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.black.withAlpha(30),
            Colors.black.withAlpha(10),
          ],
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Layer 1: The main content of the screen
          BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthRegistrationNeeded) {
                Navigator.pushNamed(context, '/register', // navigate to registration screen
                    arguments: state.phoneNumber);
              } else if (state is AuthLoggedIn) {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/home', (route) => false); // navigate to home screen
              } else if (state is AuthFailure) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.error)));
              }
            },
            builder: (context, state) {
              if (state is AuthLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 100),
                      const Text('OTP VERIFICATION',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Oxygen',
                              height: 1.0,
                              letterSpacing: 0)),
                      const SizedBox(height: 20),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                              fontSize: 14,
                              color: Color(0XFF4E4D4D),
                              fontFamily: 'Oxygen',
                              height: 1.0,
                              letterSpacing: 0,
                              fontWeight: FontWeight.w400),
                          children: <TextSpan>[
                            const TextSpan(text: 'Enter the OTP sent to - '),
                            TextSpan(
                              text: '+91-${widget.phoneNumber}',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Oxygen',
                                  fontSize: 14,
                                  height: 1.0,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Oxygen',
                              color: Colors.black),
                          children: <TextSpan>[
                            const TextSpan(text: 'OTP is '),
                            TextSpan(
                              text: widget.otp.toString(),
                              style: const TextStyle(
                                  color: Color(0xFF6A5AE0), fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: Pinput(
                          length: 4,
                          controller: _otpController,
                          defaultPinTheme: defaultPinTheme,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          focusedPinTheme: defaultPinTheme.copyWith(
                            decoration: defaultPinTheme.decoration!.copyWith(
                              border:
                                  Border.all(color: const Color(0xFF6A5AE0)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Center(
                          child: Text(
                        '00:${_start.toString().padLeft(2, '0')} Sec ', // display countdown timer
                        style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF464646),
                            fontFamily: 'Oxygen',
                            height: 0.0,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w400),
                      )),
                      const SizedBox(height: 10),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                                fontFamily: 'Oxygen',
                                fontSize: 14,
                                color: Color(0xFF5A5A5A)),
                            children: const [
                              TextSpan(text: "Don't receive code? "),
                              TextSpan(
                                text: 'Re-send',
                                style: TextStyle(
                                    color: Color(0xFF00E5A4),
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<AuthBloc>().add(AuthOtpSubmitted(
                                _otpController.text.trim(),
                                widget.phoneNumber));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6A5AE0),
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Submit',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontFamily: 'Oxygen',
                                  height: 1.0,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          // Layer 2: The back button, positioned at the top-left
          Positioned(
            top: 50,
            left: 24,
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 45,
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4)),
                  ],
                ),
                child: const Icon(Icons.arrow_back, color: Color(0XFF808080)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
