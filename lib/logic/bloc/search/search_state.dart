//file for search states in BLoC pattern
part of 'search_bloc.dart';

/// Abstract class for search states
abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

/// The initial state, prompting the user to search.
class SearchInitial extends SearchState {}

/// The state while the API call is in progress.
class SearchLoading extends SearchState {}

/// The state when products are found.
class SearchResultsLoaded extends SearchState {
  final List<ProductModel> products;

  const SearchResultsLoaded(this.products);

  @override
  List<Object?> get props => [products];
}

/// The state when the search returns no results.
class SearchEmpty extends SearchState {}

/// The state when an error occurs.
class SearchError extends SearchState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object?> get props => [message];
}
