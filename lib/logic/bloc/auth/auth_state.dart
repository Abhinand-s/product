//file for defining authentication states
part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

// The initial state of the authentication flow
class AuthInitial extends AuthState {}

// State when we are processing something (e.g., calling an API)
class AuthLoading extends AuthState {}

// State when the OTP code has been successfully sent to the user's phone
class AuthCodeSentSuccess extends AuthState {
    final int otp; // Add this field
    const AuthCodeSentSuccess({required this.otp}); // Update constructor
    @override
    List<Object> get props => [otp];
}

// State when the user's phone number doesn't exist and we need them to register
class AuthRegistrationNeeded extends AuthState {
  final String phoneNumber;
  
  const AuthRegistrationNeeded(this.phoneNumber);

  @override
  List<Object> get props => [phoneNumber];
}

// State when the user is successfully logged in
class AuthLoggedIn extends AuthState {
  final String token; // We can hold the token here if needed

  const AuthLoggedIn(this.token);
  
  @override
  List<Object> get props => [token];
}

// State when an error occurs
class AuthFailure extends AuthState {
  final String error;

  const AuthFailure(this.error);

  @override
  List<Object> get props => [error];
}
