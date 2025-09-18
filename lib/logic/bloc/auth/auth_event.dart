//file for defining authentication events
part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

// Event when the user enters their phone number and requests an OTP
class AuthPhoneNumberSubmitted extends AuthEvent {
  final String phoneNumber;

  const AuthPhoneNumberSubmitted(this.phoneNumber);

  @override
  List<Object> get props => [phoneNumber];
}

// Event when the user submits the OTP for verification
class AuthOtpSubmitted extends AuthEvent {
  final String otp;
  // We need the phone number to log in or register after OTP is verified
  final String phoneNumber;

  const AuthOtpSubmitted(this.otp, this.phoneNumber);

  @override
  List<Object> get props => [otp, phoneNumber];
}

// Event for when a new user submits their name to register
class AuthRegisterRequested extends AuthEvent {
  final String phoneNumber;
  final String firstName;

  const AuthRegisterRequested(this.phoneNumber, this.firstName);

  @override
  List<Object> get props => [phoneNumber, firstName];
}
