// file for managing authentication state using BLoC pattern
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:product/data/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final _storage = const FlutterSecureStorage();
  bool _isNewUser = false; // Flag to store the user status

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<AuthPhoneNumberSubmitted>(_onPhoneNumberSubmitted);
    on<AuthOtpSubmitted>(_onOtpSubmitted);
    on<AuthRegisterRequested>(_onRegisterRequested);
  }
// Handle phone number submission
  void _onPhoneNumberSubmitted(
    AuthPhoneNumberSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final result = await _authRepository.verifyPhoneNumber(
          phoneNumber: event.phoneNumber);
      _isNewUser = result['isNewUser'];
      final otp = result['otp'];
      emit(AuthCodeSentSuccess(otp: otp));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

// Handle OTP submission
  void _onOtpSubmitted(
    AuthOtpSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      if (_isNewUser) {
        // If the user is new, navigate to the registration screen
        emit(AuthRegistrationNeeded(event.phoneNumber));
      } else {
        // If the user exists, log them in directly
        final token = await _authRepository.loginOrRegister(
            phoneNumber: event.phoneNumber);
        await _storage.write(key: 'jwt_token', value: token);
        emit(AuthLoggedIn(token));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  // Handle user registration
  void _onRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final token = await _authRepository.loginOrRegister(
        phoneNumber: event.phoneNumber,
        firstName: event.firstName,
      );
      await _storage.write(key: 'jwt_token', value: token);
      emit(AuthLoggedIn(token));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
