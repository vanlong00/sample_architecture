import 'env.dart';

class AppConfig {
  const AppConfig({
    required this.env,
    required this.baseUrl,
    required this.enableLogging,
    required this.appName,
  });

  final AppEnv env;
  final String baseUrl;
  final bool enableLogging;
  final String appName;

  factory AppConfig.fromEnv(AppEnv env) {
    switch (env) {
      case AppEnv.dev:
        return const AppConfig(
          env: AppEnv.dev,
          baseUrl: 'https://dev.api.example.com',
          enableLogging: true,
          appName: 'Sample (Dev)',
        );
      case AppEnv.staging:
        return const AppConfig(
          env: AppEnv.staging,
          baseUrl: 'https://staging.api.example.com',
          enableLogging: true,
          appName: 'Sample (Staging)',
        );
      case AppEnv.prod:
        return const AppConfig(
          env: AppEnv.prod,
          baseUrl: 'https://api.example.com',
          enableLogging: false,
          appName: 'Sample',
        );
    }
  }
}
