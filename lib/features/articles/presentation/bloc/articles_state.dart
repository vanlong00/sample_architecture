import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/error/failure.dart';
import '../../data/models/article_model.dart';

part 'articles_state.freezed.dart';

@freezed
sealed class ArticlesState with _$ArticlesState {
  const factory ArticlesState.initial() = ArticlesInitial;
  const factory ArticlesState.loading() = ArticlesLoading;
  const factory ArticlesState.success(List<Article> items) = ArticlesSuccess;
  const factory ArticlesState.failure(Failure failure) = ArticlesFailure;
}
