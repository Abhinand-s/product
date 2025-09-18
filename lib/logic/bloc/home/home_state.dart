//file for managing home states
part of 'home_bloc.dart';

//abstract class for home states
abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

//state when home data is loaded
class HomeLoaded extends HomeState {
  final List<BannerModel> banners;

  final List<ProductModel> popularProducts;
  final List<ProductModel> latestProducts;

  //constructor
  const HomeLoaded({
    required this.banners,
    required this.popularProducts,
    required this.latestProducts,
  });

  @override
  //list of objects
  List<Object> get props => [banners, popularProducts, latestProducts];
}

//state when there is an error
class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object> get props => [message];
}
