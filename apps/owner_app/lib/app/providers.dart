
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_core/shared_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants/api_endpoints_constants.dart';

final sharedPrefsProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('override in main');
});

final customerAppEnvProvider = Provider<AppEnv>((ref) {
  return AppEnv(
    baseUrl: ApiEndpointsConstants.baseUrl,
    enableLogging: true,
    enableInspector: true,
  );
});

final appLoggerProvider = Provider<AppLogger>((ref) {
  final env = ref.watch(customerAppEnvProvider);
  return env.enableLogging ? ConsoleLogger() : NoOpLogger();
});

// final localSessionRepositoryProvider = Provider<LocalSessionRepository>((ref) {
//   return LocalSessionRepository(ref.watch(sharedPrefsProvider));
// });

// final sessionRepositoryProvider = Provider<SessionRepository>((ref) {
//   return ref.watch(localSessionRepositoryProvider);
// });

// final dioProvider = Provider<Dio>((ref) {
//   final env = ref.watch(customerAppEnvProvider);
//   final sessionRepo = ref.watch(sessionRepositoryProvider);
//   final logger = ref.watch(appLoggerProvider);

//   final inspectorStore = ref.read(inspectorStoreAsCoreProvider);

//   final extras = <Interceptor>[];
//   if (env.enableInspector) {
//     extras.add(InspectorInterceptor(inspectorStore));
//   }

//   return DioFactory(
//     env: env,
//     sessionRepository: sessionRepo,
//     logger: logger,
//     extraInterceptors: extras,
//   ).create();
// });

// final apiClientProvider = Provider<ApiClient>((ref) {
//   return ApiClient(ref.watch(dioProvider));
// });

final errorPresenterProvider = Provider<ErrorPresenter>((ref) {
  return ErrorPresenter();
});

// final authRepositoryProvider = Provider<AuthRepository>((ref) {
//   return AuthRepositoryImpl(
//     api: ref.watch(apiClientProvider),
//     session: ref.watch(localSessionRepositoryProvider),
//   );
// });


// final registrationRepositoryProvider = Provider<RegistrationRepository>((ref) {
//   return RegistrationRepositoryImpl(
//     api: ref.watch(apiClientProvider),
//   );
// });

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});