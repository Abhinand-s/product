//file for wishlist state management using Bloc pattern
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:product/data/models/product_model.dart';
import 'package:product/data/repositories/wishlist_repository.dart';

part 'wishlist_event.dart';
part 'wishlist_state.dart';

/// Bloc for managing wishlist state
class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  final WishlistRepository _wishlistRepository;

  WishlistBloc(this._wishlistRepository) : super(WishlistInitial()) {
    on<FetchWishlist>(_onFetchWishlist);
    on<ToggleWishlist>(_onToggleWishlist);
  }

  /// Fetch wishlist items from repository
  void _onFetchWishlist(
      FetchWishlist event, Emitter<WishlistState> emit) async {
    emit(WishlistLoading());
    try {
      final items = await _wishlistRepository.fetchWishlistItems();
      emit(WishlistLoaded(items));
    } catch (e) {
      emit(WishlistError(e.toString()));
    }
  }

  /// Toggle wishlist item in repository
  void _onToggleWishlist(
      ToggleWishlist event, Emitter<WishlistState> emit) async {
    try {
      await _wishlistRepository.toggleWishlistItem(productId: event.productId);
      // After toggling, refetch the entire list to ensure UI consistency.
      final items = await _wishlistRepository.fetchWishlistItems();
      emit(WishlistLoaded(items));
    } catch (e) {
      emit(WishlistError(e.toString()));
    }
  }
}
