//file for managing states related to fetching and updating all products
part of 'all_products_bloc.dart';

abstract class AllProductsState extends Equatable {
  const AllProductsState();

  @override
  List<Object> get props => [];
}

class AllProductsInitial extends AllProductsState {} // initial state

class AllProductsLoading extends AllProductsState {} // loading state

// loaded state with products
class AllProductsLoaded extends AllProductsState {
  final List<ProductModel> products;

  const AllProductsLoaded(this.products);

  @override
  List<Object> get props => [products];
}

// error state with message
class AllProductsError extends AllProductsState {
  final String message;

  const AllProductsError(this.message);

  @override
  List<Object> get props => [message];
}
