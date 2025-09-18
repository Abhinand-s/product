//file for wishlist states using Bloc pattern
part of 'wishlist_bloc.dart';

/// Abstract class for wishlist states
abstract class WishlistState extends Equatable {
  const WishlistState();

  @override
  List<Object> get props => [];
}

class WishlistInitial extends WishlistState {} // Initial state

class WishlistLoading extends WishlistState {} // Loading state

class WishlistLoaded extends WishlistState {
  // Loaded state
  final List<ProductModel> wishlistItems; // List of wishlist items

  const WishlistLoaded(this.wishlistItems); // Constructor

  @override
  List<Object> get props => [wishlistItems];
}

/// Error state
class WishlistError extends WishlistState {
  final String message;

  const WishlistError(this.message);

  @override
  List<Object> get props => [message];
}
