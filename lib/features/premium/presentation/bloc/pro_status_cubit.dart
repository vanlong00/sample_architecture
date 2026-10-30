import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../data/subscription_service.dart';

/// `true` while the user has premium. Seeded from the service, then follows
/// its entitlement stream.
@injectable
class ProStatusCubit extends Cubit<bool> {
  ProStatusCubit(SubscriptionService service) : super(service.isPremium) {
    _sub = service.entitlementStream.listen(_set);
  }

  late final StreamSubscription<bool> _sub;

  void _set(bool value) {
    if (value != state) emit(value);
  }

  @override
  Future<void> close() {
    _sub.cancel();
    return super.close();
  }
}
