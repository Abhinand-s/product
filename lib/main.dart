// main.dart file
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product/data/repositories/auth_repository.dart';
import 'package:product/data/repositories/home_repository.dart';
import 'package:product/data/repositories/wishlist_repository.dart';
//import 'package:product/logic/bloc/all_products/all_products_bloc.dart';
import 'package:product/logic/bloc/auth/auth_bloc.dart';
import 'package:product/logic/bloc/home/home_bloc.dart';
import 'package:product/logic/bloc/wishlist/wishlist_bloc.dart';
import 'package:product/presentation/main_layout.dart';
import 'package:product/presentation/screens/all_products_screen.dart';
import 'package:product/presentation/screens/login_screen.dart';
import 'package:product/presentation/screens/otp_screen.dart';
import 'package:product/presentation/screens/register_screen.dart';
import 'package:product/presentation/screens/search_screen.dart';
import 'package:product/presentation/screens/splash_screen.dart';
import 'package:product/presentation/utils/custom_route.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

// State class for MyApp
class _MyAppState extends State<MyApp> {
  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Oxygen', // Set the default font for the entire app
      ),
      onGenerateRoute: _appRouter.onGenerateRoute,
      initialRoute: '/',
    );
  }

  @override
  void dispose() {
    _appRouter.dispose();
    super.dispose();
  }
}

class AppRouter {
  // --- Repositories ---
  final AuthRepository _authRepository = AuthRepository();
  final WishlistRepository _wishlistRepository = WishlistRepository();
  final HomeRepository _homeRepository = HomeRepository();

  // --- BLoCs ---
  late final AuthBloc _authBloc;
  late final WishlistBloc _wishlistBloc;
  late final HomeBloc _homeBloc;

  AppRouter() {
    _authBloc = AuthBloc(_authRepository);
    _wishlistBloc = WishlistBloc(_wishlistRepository);
    _homeBloc = HomeBloc(_homeRepository, _wishlistBloc);
  }

  Route onGenerateRoute(RouteSettings settings) {
    // Route generator
    switch (settings.name) {
      case '/': // Splash screen
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/login': // Login screen
      case '/otp': // OTP screen
      case '/register': // Register screen
        return SlideUpPageRoute(
          builder: (_) => BlocProvider.value(
            value: _authBloc,
            child: _getAuthScreen(settings),
          ),
        );

      case '/home': // Main layout with home, wishlist, and profile screens
        return FadePageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: _wishlistBloc..add(FetchWishlist())),
              BlocProvider.value(value: _homeBloc..add(FetchHomeData())),
            ],
            child: const MainLayout(),
          ),
        );

      case '/all_products': // All products screen
        return FadePageRoute(
          builder: (_) => BlocProvider.value(
            value: _wishlistBloc,
            child: const AllProductsScreen(),
          ),
        );

      case '/search': // Search screen
        return MaterialPageRoute(builder: (_) => const SearchScreen());

      default:
        return MaterialPageRoute(
            builder: (_) => const Scaffold(
                body: Center(child: Text('Error: Route not found'))));
    }
  }

  // Helper method to get the appropriate auth screen based on route settings
  Widget _getAuthScreen(RouteSettings settings) {
    switch (settings.name) {
      case '/otp': // OTP screen

        final args = settings.arguments as Map<String, dynamic>;

        final phoneNumber = args['phoneNumber'] as String;
        final otp = args['otp'] as int;

        return OtpScreen(phoneNumber: phoneNumber, otp: otp);

      case '/register': // Register screen
        final phoneNumber = settings.arguments as String;
        return RegisterScreen(phoneNumber: phoneNumber);
      default: //default to login screen
        return const LoginScreen();
    }
  }

  void dispose() {
    _authBloc.close();
    _wishlistBloc.close();
    _homeBloc.close();
  }
}
