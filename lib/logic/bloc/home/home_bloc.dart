//file for managing home states
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:product/data/models/banner_model.dart';
import 'package:product/data/models/product_model.dart';
import 'package:product/data/repositories/home_repository.dart';
import 'package:product/logic/bloc/wishlist/wishlist_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

//bloc for home screen
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _homeRepository;
  final WishlistBloc _wishlistBloc;
  late StreamSubscription _wishlistSubscription;

  HomeBloc(this._homeRepository, this._wishlistBloc) : super(HomeInitial()) {
    _wishlistSubscription = _wishlistBloc.stream.listen((state) {
      if (state is WishlistLoaded) {
        add(_UpdateWishlistStatus(state.wishlistItems));
      }
    });

    on<FetchHomeData>(_onFetchHomeData);
    on<_UpdateWishlistStatus>(_onUpdateWishlistStatus);
  }
//fetch home data
  void _onFetchHomeData(FetchHomeData event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      final results = await Future.wait([
        _homeRepository.fetchBanners(),
        _homeRepository.fetchProducts(),
      ]);

      final banners = results[0] as List<BannerModel>;
      final allProducts = results[1] as List<ProductModel>;

      // Sort by rating for "Popular Products"
      final popularProducts = List<ProductModel>.from(allProducts);
      popularProducts.sort((a, b) => b.rating.compareTo(a.rating));

      // Sort by date for "Latest Products"
      final latestProducts = List<ProductModel>.from(allProducts);
      latestProducts.sort((a, b) => b.createdDate.compareTo(a.createdDate));

      // Emit the new state with the two separate, sorted lists
      emit(HomeLoaded(
        banners: banners,
        popularProducts: popularProducts,
        latestProducts: latestProducts,
      ));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

//update wishlist status
  void _onUpdateWishlistStatus(
      _UpdateWishlistStatus event, Emitter<HomeState> emit) {
    final currentState = state;
    if (currentState is HomeLoaded) {
      final wishlistedIds =
          event.updatedWishlist.map((item) => item.id).toSet();

      final updatedPopular = currentState.popularProducts.map((product) {
        return product.copyWith(inWishlist: wishlistedIds.contains(product.id));
      }).toList();

      final updatedLatest = currentState.latestProducts.map((product) {
        return product.copyWith(inWishlist: wishlistedIds.contains(product.id));
      }).toList();

      emit(HomeLoaded(
        banners: currentState.banners,
        popularProducts: updatedPopular,
        latestProducts: updatedLatest,
      ));
    }
  }

  @override
  Future<void> close() {
    _wishlistSubscription.cancel();
    return super.close();
  }
}
