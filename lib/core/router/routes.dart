class Routes {
  static const String splash = '/';
  static const String home = '/home';
  static const String search = '/search';
  static const String downloads = '/downloads';
  static const String favorites = '/favorites';
  static const String settings = '/settings';
  static const String pro = '/pro';
  static const String mod = '/mod/:sourceId';

  static String modDetailOf(int id) => '/mod/$id';
}
