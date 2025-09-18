// A widget that shows a skeleton loader for various screens while content is loading.
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Skeleton extends StatelessWidget {
  const Skeleton({super.key, this.height, this.width, this.radius = 12});
  final double? height, width;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

// The skeleton for the Home Screen
class HomeScreenSkeleton extends StatelessWidget {
  const HomeScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Skeleton(height: 50, radius: 30), // Search bar
              const SizedBox(height: 24),
              const Skeleton(height: 150, radius: 15), // Banner
              const SizedBox(height: 24),
              const Skeleton(height: 20, width: 150), // Section header
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.65,
                ),
                itemCount: 4,
                itemBuilder: (context, index) => const Skeleton(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// The skeleton for the Search Screen results
class SearchScreenSkeleton extends StatelessWidget {
  const SearchScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.65,
        ),
        itemCount: 6,
        itemBuilder: (context, index) => const Skeleton(),
      ),
    );
  }
}

// The skeleton for the Profile Screen
class ProfileScreenSkeleton extends StatelessWidget {
  const ProfileScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Skeleton(height: 32, width: 150), // Title skeleton
            const SizedBox(height: 40),
            const Skeleton(height: 16, width: 80), // Label skeleton
            const SizedBox(height: 8),
            const Skeleton(height: 24, width: 200), // Value skeleton
            const SizedBox(height: 24),
            const Skeleton(height: 16, width: 80), // Label skeleton
            const SizedBox(height: 8),
            const Skeleton(height: 24, width: 200), // Value skeleton
          ],
        ),
      ),
    );
  }
}
