//file for managing home events
part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

/// Event to signal that the home screen data should be fetched.
class FetchHomeData extends HomeEvent {}
class _UpdateWishlistStatus extends HomeEvent {
  final List<ProductModel> updatedWishlist;

  const _UpdateWishlistStatus(this.updatedWishlist);
}