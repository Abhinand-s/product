//file for WishlistScreen
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product/logic/bloc/wishlist/wishlist_bloc.dart';
import 'package:product/presentation/widgets/product_card.dart';

// WishlistScreen widget
class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false, //bottom safe area false to allow content to extend
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Text('Wishlist',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Heebo',
                        height: 1.44,
                        letterSpacing: 1.6)),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: BlocBuilder<WishlistBloc, WishlistState>(
                  builder: (context, state) {
                    if (state is WishlistLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is WishlistError) {
                      return Center(child: Text(state.message));
                    }
                    if (state is WishlistLoaded) {
                      if (state.wishlistItems.isEmpty) {
                        return const Center(
                            child: Text('Your wishlist is empty.'));
                      }
                      return GridView.builder(
                        padding: const EdgeInsets.only(bottom: 100.0),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.65,
                        ),
                        itemCount: state.wishlistItems.length,
                        itemBuilder: (context, index) {
                          final product = state.wishlistItems[index];
                          return ProductCard(product: product);
                        },
                      );
                    }
                    return const Center(child: Text('Something went wrong.'));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
