//file for home screen UI and logic
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:product/data/models/banner_model.dart';
import 'package:product/data/models/product_model.dart';
import 'package:product/logic/bloc/home/home_bloc.dart';
//import 'package:product/presentation/screens/search_screen.dart';
import 'package:product/presentation/widgets/product_card.dart';
import 'package:product/presentation/widgets/skeleton_loader.dart';

// HomeScreen displays the main content of the app including search bar, banner slider, and product sections
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentBannerPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false, //bottom safe area false to allow content to extend
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading || state is HomeInitial) {
              return const HomeScreenSkeleton();
            }
            if (state is HomeError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            if (state is HomeLoaded) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSearchBar(context),
                      const SizedBox(height: 24),
                      _buildBannerSlider(state.banners),
                      const SizedBox(height: 24),

                      // Popular Products Section
                      _buildSectionHeader(context, "Popular Products"),
                      const SizedBox(height: 16),
                      _buildProductGrid(
                          state.popularProducts), // Pass popularProducts list

                      const SizedBox(height: 24),

                      // Latest Products Section
                      _buildSectionHeader(context, "Latest Products"),
                      const SizedBox(height: 16),
                      _buildProductGrid(
                          state.latestProducts), // Pass latestProducts list

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              );
            }
            return const Center(child: Text('Something went wrong.'));
          },
        ),
      ),
    );
  }

// Search bar widget that navigates to the search screen on tap
  Widget _buildSearchBar(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/search');
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            const Expanded(
              child: Text('Search',
                  style: TextStyle(color: Colors.grey, fontSize: 16)),
            ),
            SizedBox(
              height: 20,
              child: VerticalDivider(color: Colors.grey.shade400, thickness: 1),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.search, color: Colors.grey),
          ],
        ),
      ),
    );
  }

// Banner slider with page indicators
  Widget _buildBannerSlider(List<BannerModel> banners) {
    return Column(
      children: [
        SizedBox(
          height: 150,
          child: PageView.builder(
            itemCount: banners.length,
            onPageChanged: (index) {
              setState(() {
                _currentBannerPage = index;
              });
            },
            itemBuilder: (context, index) {
              final banner = banners[index];
              return Card(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: CachedNetworkImage(
                  imageUrl: banner.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      Container(color: Colors.grey[200]),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(banners.length, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              height: 8,
              width: _currentBannerPage == index ? 24 : 8,
              decoration: BoxDecoration(
                color: _currentBannerPage == index
                    ? Colors.black87
                    : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(12),
              ),
            );
          }),
        ),
      ],
    );
  }

// Section header with title and "View All" button
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/all_products');
          },
          child: const Text('View All'),
        )
      ],
    );
  }

// Product grid with staggered animations
  Widget _buildProductGrid(List<ProductModel> products) {
    return AnimationLimiter(
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.60,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: const Duration(milliseconds: 375),
            columnCount: 2,
            child: ScaleAnimation(
              child: FadeInAnimation(
                child: ProductCard(product: product),
              ),
            ),
          );
        },
      ),
    );
  }
}
