//all products showing screen
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product/data/repositories/home_repository.dart';
import 'package:product/logic/bloc/all_products/all_products_bloc.dart';
import 'package:product/logic/bloc/wishlist/wishlist_bloc.dart';
import 'package:product/presentation/widgets/product_card.dart';

class AllProductsScreen extends StatelessWidget {
  const AllProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AllProductsBloc(
        HomeRepository(),
        // Read the WishlistBloc that was provided by the AppRouter
        context.read<WishlistBloc>(),
      )..add(FetchAllProducts()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('All Products'),
          backgroundColor: Colors.white,
          elevation: 1,
          iconTheme: const IconThemeData(color: Colors.black),
          titleTextStyle: const TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        body: BlocBuilder<AllProductsBloc, AllProductsState>(
          builder: (context, state) {
            if (state is AllProductsLoading || state is AllProductsInitial) {
              return const Center(
                  child: CircularProgressIndicator()); // Loading indicator
            }
            if (state is AllProductsError) {
              return Center(
                  child: Text(state.message)); // Display error message
            }
            if (state is AllProductsLoaded) {
              if (state.products.isEmpty) {
                return const Center(child: Text('No products available.'));
              }
              // Display products in a grid view
              return GridView.builder(
                padding: const EdgeInsets.all(16.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.65,
                ),
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  final product = state.products[index];
                  return ProductCard(product: product);
                },
              );
            }
            return const Center(child: Text('Something went wrong.'));
          },
        ),
      ),
    );
  }
}
