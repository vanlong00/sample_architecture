import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample_architecture/core/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sample_architecture/features/articles/data/models/article_model.dart';
import 'package:sample_architecture/features/articles/presentation/bloc/articles_cubit.dart';
import 'package:sample_architecture/features/articles/presentation/bloc/articles_state.dart';
import 'package:sample_architecture/features/articles/presentation/pages/articles_page.dart';

class MockArticlesCubit extends MockCubit<ArticlesState>
    implements ArticlesCubit {}

Widget _wrap(ArticlesCubit cubit) => MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<ArticlesCubit>.value(
        value: cubit,
        child: const ArticlesPage(),
      ),
    );

void main() {
  late MockArticlesCubit cubit;

  setUp(() {
    cubit = MockArticlesCubit();
    when(() => cubit.load()).thenAnswer((_) async {});
  });

  testWidgets('state success hiển thị tiêu đề bài viết', (tester) async {
    whenListen(
      cubit,
      Stream<ArticlesState>.fromIterable(const [
        ArticlesState.success([Article(id: 1, title: 'Hello', body: 'b')]),
      ]),
      initialState: const ArticlesState.loading(),
    );
    await tester.pumpWidget(_wrap(cubit));
    await tester.pump();
    expect(find.text('Hello'), findsOneWidget);
  });

  testWidgets('state loading hiển thị progress indicator', (tester) async {
    whenListen(
      cubit,
      const Stream<ArticlesState>.empty(),
      initialState: const ArticlesState.loading(),
    );
    await tester.pumpWidget(_wrap(cubit));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
