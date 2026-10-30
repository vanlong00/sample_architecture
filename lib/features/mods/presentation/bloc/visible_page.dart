import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../data/repositories/mods_repository.dart';

/// Max consecutive pages that may come back with nothing visible (all hidden
/// by the F3 filter) before we stop and hand the page over as is.
const maxEmptyPages = 5;

/// Fetches from [skip]; while a page has no visible item but more exist, moves
/// on to the next one (bounded by [maxEmptyPages]) so paging never stalls.
Future<Either<Failure, ModPage>> fetchVisiblePage(
  Future<Either<Failure, ModPage>> Function(int skip) fetch,
  int skip,
) async {
  var result = await fetch(skip);
  for (var i = 1; i < maxEmptyPages; i++) {
    final page = result.fold((_) => null, (p) => p);
    if (page == null || page.items.isNotEmpty || !page.hasMore) break;
    result = await fetch(page.nextSkip);
  }
  return result;
}
