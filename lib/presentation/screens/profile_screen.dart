// file for ProfileScreen
import 'package:flutter/material.dart';
//import 'package:flutter/foundation.dart'; // Import for debugPrint
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product/data/repositories/profile_repository.dart';
import 'package:product/logic/bloc/profile/profile_bloc.dart';
import 'package:product/presentation/widgets/skeleton_loader.dart';

// ProfileScreen widget
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Create the BLoC instance here
  final ProfileBloc _profileBloc = ProfileBloc(ProfileRepository());

  @override
  void initState() {
    super.initState();
    // Dispatch the event to fetch data as soon as the screen is initialized
    debugPrint("--- Dispatching FetchProfileData event ---");
    _profileBloc.add(FetchProfileData());
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("--- ProfileScreen build method called ---");
    // Provide the BLoC to the widget tree
    return BlocProvider.value(
      value: _profileBloc,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                if (state is ProfileLoading || state is ProfileInitial) {
                  return const ProfileScreenSkeleton();
                }
                if (state is ProfileLoaded) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('My Profile',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Heebo', // use Heebo font
                              height: 1.44,
                              letterSpacing: 1)),
                      const SizedBox(height: 40),
                      _buildProfileInfoItem(
                          label: 'Name', value: state.userProfile.name),
                      const SizedBox(height: 24),
                      _buildProfileInfoItem(
                          label: 'Phone', value: state.userProfile.phone),
                    ],
                  );
                }
                if (state is ProfileError) {
                  return Center(child: Text(state.message));
                }
                return const Center(
                    child: Text(
                        'Something went wrong.')); // Fallback for unexpected states
              },
            ),
          ),
        ),
      ),
    );
  }

// Helper method to build profile info items
  Widget _buildProfileInfoItem({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 14,
                color: Color(0XFF929292),
                fontFamily: 'Oxygen',
                height: 1.0,
                letterSpacing: 0)),
        const SizedBox(height: 8),
        Text(value,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black,
                fontFamily: 'Oxygen',
                height: 1.0,
                letterSpacing: 0)),
      ],
    );
  }

  @override
  void dispose() {
    _profileBloc.close();
    super.dispose();
  }
}
