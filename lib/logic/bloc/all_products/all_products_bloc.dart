// bloc for managing all products and syncing with wishlist status
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:product/data/models/product_model.dart';
import 'package:product/data/repositories/home_repository.dart';
import 'package:product/logic/bloc/wishlist/wishlist_bloc.dart';

part 'all_products_event.dart';
part 'all_products_state.dart';

class AllProductsBloc extends Bloc<AllProductsEvent, AllProductsState> {
  final HomeRepository _homeRepository;
  final WishlistBloc _wishlistBloc;
  late StreamSubscription _wishlistSubscription;

  AllProductsBloc(this._homeRepository, this._wishlistBloc)
      : super(AllProductsInitial()) {
    // Listen to the WishlistBloc's state stream
    _wishlistSubscription = _wishlistBloc.stream.listen((state) {
      if (state is WishlistLoaded) {
        // When wishlist changes, add an internal event to update our products
        add(_UpdateAllProductsWishlistStatus(state.wishlistItems));
      }
    });

    on<FetchAllProducts>(_onFetchAllProducts); // Public event to fetch products
    on<_UpdateAllProductsWishlistStatus>(_onUpdateWishlistStatus);
  }
  // Handler for fetching all products
  void _onFetchAllProducts(
      FetchAllProducts event, Emitter<AllProductsState> emit) async {
    emit(AllProductsLoading());
    try {
      final products = await _homeRepository.fetchProducts();
      // After fetching, immediately sync with the current wishlist state
      if (_wishlistBloc.state is WishlistLoaded) {
        final currentWishlist =
            (_wishlistBloc.state as WishlistLoaded).wishlistItems;
        final wishlistedIds = currentWishlist.map((item) => item.id).toSet();
        final updatedProducts = products
            .map((product) => product.copyWith(
                inWishlist: wishlistedIds.contains(product.id)))
            .toList();
        emit(AllProductsLoaded(updatedProducts));
      } else {
        emit(AllProductsLoaded(products));
      }
    } catch (e) {
      emit(AllProductsError(e.toString()));
    }
  }
  // Internal event handler to update products' wishlist status
  void _onUpdateWishlistStatus(
      _UpdateAllProductsWishlistStatus event, Emitter<AllProductsState> emit) {
    final currentState = state;
    if (currentState is AllProductsLoaded) {
      final wishlistedIds =
          event.updatedWishlist.map((item) => item.id).toSet();
      final updatedProducts = currentState.products
          .map((product) =>
              product.copyWith(inWishlist: wishlistedIds.contains(product.id)))
          .toList();
      emit(AllProductsLoaded(updatedProducts));
    }
  }

  @override
  Future<void> close() {
    _wishlistSubscription.cancel();
    return super.close();
  }
}
