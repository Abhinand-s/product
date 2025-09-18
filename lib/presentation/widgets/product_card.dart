//file for product card widget
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product/logic/bloc/wishlist/wishlist_bloc.dart';
import 'package:product/data/models/product_model.dart';

// A card widget to display product information including image, name, prices, rating, and wishlist status.
class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({
    // product card variable
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Card(
            clipBehavior: Clip.antiAlias,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            child: Stack(
              fit: StackFit.expand, // Make the Stack fill the Card
              children: [
                CachedNetworkImage(
                  imageUrl: product.imageUrl, // Product image
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      Container(color: Colors.grey[200]),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(
                          scale: animation,
                          child: child,
                        );
                      },
                      child: Icon(
                        product.inWishlist
                            ? Icons.favorite
                            : Icons.favorite_border,
                        key: ValueKey<bool>(product.inWishlist),
                        color: const Color(0xFF6A5AE0),
                      ),
                    ),
                    onPressed: () {
                      context
                          .read<WishlistBloc>()
                          .add(ToggleWishlist(productId: product.id));
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "₹${product.price}",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                      fontFamily: 'Heebo',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "₹${product.offerPrice}",
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF6A5AE0),
                        fontFamily: 'Heebo',
                        height: 1.6),
                  ),
                  const Spacer(),
                  const Icon(Icons.star, color: Colors.amber, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    product.rating.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Heebo',
                        height: 1.4,
                        fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                product.name,
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Heebo',
                    height: 1.33),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
