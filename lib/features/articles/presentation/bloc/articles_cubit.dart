import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../data/repositories/articles_repository.dart';
import 'articles_state.dart';

@injectable
class ArticlesCubit extends Cubit<ArticlesState> {
  ArticlesCubit(this._repository) : super(const ArticlesState.initial());

  final ArticlesRepository _repository;

  Future<void> load() async {
    emit(const ArticlesState.loading());
    final result = await _repository.fetchArticles();
    result.fold(
      (failure) => emit(ArticlesState.failure(failure)),
      (items) => emit(ArticlesState.success(items)),
    );
  }
}
