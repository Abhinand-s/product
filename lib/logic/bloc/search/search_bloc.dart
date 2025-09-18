//file for search feature using BLoC pattern with debounce functionality
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:product/data/models/product_model.dart';
import 'package:product/data/repositories/home_repository.dart';
import 'package:stream_transform/stream_transform.dart'; // For debounce

part 'search_event.dart';
part 'search_state.dart';

// Debounce duration
const _duration = Duration(milliseconds: 300);
EventTransformer<Event> debounce<Event>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

/// SearchBloc to handle search events and states
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final HomeRepository _homeRepository;

  SearchBloc(this._homeRepository) : super(SearchInitial()) {
    on<SearchQueryChanged>(
      _onSearchQueryChanged,
      transformer: debounce(_duration), // Apply debounce
    );
  }

  /// Handle search query changes
  Future<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    final query = event.query.trim();

    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());
    try {
      final products = await _homeRepository.searchProducts(
          query: query); // Fetch products from repository
      if (products.isEmpty) {
        emit(SearchEmpty());
      } else {
        emit(SearchResultsLoaded(products)); // Emit loaded state with products
      }
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }
}
