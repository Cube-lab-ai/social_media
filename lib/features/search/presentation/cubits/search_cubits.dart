import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_firebase/features/search/domain/repository/search_repo.dart';
import 'package:social_media_firebase/features/search/presentation/cubits/search_state.dart';

class SearchCubits extends Cubit<SearchState> {
  SearchRepo searchRepo;
  SearchCubits({required this.searchRepo}) : super(SearchInitialState());

  Future<void> searchProfileUser(String query) async {
    try {
      final result = await searchRepo.searchProfileByUser(query);
      if (result.isNotEmpty) {
        emit(SearchLoadedState(user: result));
      } else {
        emit(SearchErrorState(message: 'No Search Found'));
      }
    } catch (e) {
      emit(
        SearchErrorState(message: 'something went wrong while searching $e'),
      );
    }
  }
}
