// file for managing events related to fetching and updating all products
part of 'all_products_bloc.dart';

abstract class AllProductsEvent extends Equatable {
  const AllProductsEvent();

  @override
  List<Object> get props => [];
}

class FetchAllProducts extends AllProductsEvent {}

// Internal event to update the product list when the wishlist changes
class _UpdateAllProductsWishlistStatus extends AllProductsEvent {
  final List<ProductModel> updatedWishlist;

  const _UpdateAllProductsWishlistStatus(this.updatedWishlist);
}
