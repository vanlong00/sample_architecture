import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failure_mapper.dart';
import '../../../../core/l10n/l10n_ext.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../bloc/articles_cubit.dart';
import '../bloc/articles_state.dart';

class ArticlesPage extends StatefulWidget {
  const ArticlesPage({super.key});

  @override
  State<ArticlesPage> createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  @override
  void initState() {
    super.initState();
    context.read<ArticlesCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.appTitle)),
      body: BlocBuilder<ArticlesCubit, ArticlesState>(
        builder: (context, state) {
          return state.when(
            initial: () => const LoadingView(),
            loading: () => const LoadingView(),
            success: (items) => ListView.builder(
              itemCount: items.length,
              itemBuilder: (_, i) => ListTile(
                title: Text(items[i].title),
                subtitle: Text(items[i].body),
              ),
            ),
            failure: (failure) => ErrorView(
              message: mapFailureToMessage(failure, context.l10n),
              onRetry: () => context.read<ArticlesCubit>().load(),
            ),
          );
        },
      ),
    );
  }
}
