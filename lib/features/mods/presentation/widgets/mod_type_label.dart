import '../../../../core/l10n/l10n_ext.dart';
import '../../data/models/mod_type.dart';

String modTypeLabel(ModType type, AppLocalizations l10n) => switch (type) {
  ModType.bus => l10n.typeBus,
  ModType.truck => l10n.typeTruck,
  ModType.car => l10n.typeCar,
  ModType.map => l10n.typeMap,
};
