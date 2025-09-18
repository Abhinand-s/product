//file for wishlist events using Bloc pattern
part of 'wishlist_bloc.dart';

/// Abstract class for wishlist events
abstract class WishlistEvent extends Equatable {
  const WishlistEvent();

  @override
  List<Object> get props => [];
}

/// Event to fetch the initial wishlist items.
class FetchWishlist extends WishlistEvent {}

/// Event to add or remove a product from the wishlist.
class ToggleWishlist extends WishlistEvent {
  final int productId;

  const ToggleWishlist({required this.productId});

  @override
  List<Object> get props => [productId];
}
