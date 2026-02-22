// import 'package:dio/dio.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:shared_core/shared_core.dart';

// import 'constants/api_endpoints_constants.dart';

// /// ----------------------------
// /// 1) App Config (Env)
// /// ----------------------------
// /// مؤقتًا: هنحددها هنا.. بعد ما تعمل Flavors هنخليها تتغير حسب flavor.
// final customerAppEnvProvider  = Provider<AppEnv>((ref) {
//   return  AppEnv(
//     baseUrl: ApiEndpointsConstants.baseUrl,
//     enableLogging: true, // dev
//     enableInspector: true, // dev
//   );
// });

// /// ----------------------------
// /// 2) Logger
// /// ----------------------------
// final appLoggerProvider = Provider<AppLogger>((ref) {
//   final env = ref.watch(customerAppEnvProvider );
//   return env.enableLogging ? ConsoleLogger() : NoOpLogger();
// });

// /// ----------------------------
// /// 3) Session Repository (Token storage)
// /// ----------------------------
// /// مؤقت: InMemory عشان نشتغل دلوقتي.
// /// بعدين هنبدله بـ SecureStorage implementation.
// class InMemorySessionRepository implements SessionRepository {
//   String? _accessToken;
//   String? _refreshToken;

//   void setTokens({String? accessToken, String? refreshToken}) {
//     _accessToken = accessToken;
//     _refreshToken = refreshToken;
//   }

//   @override
//   Future<String?> getAccessToken() async => _accessToken;

//   @override
//   Future<String?> getRefreshToken() async => _refreshToken;
// }

// final sessionRepositoryProvider = Provider<SessionRepository>((ref) {
//   return InMemorySessionRepository();
// });

// /// ----------------------------
// /// 4) Inspector Store (Riverpod) - from shared_core
// /// ----------------------------
// /// عندك provider جاهز في shared_core:
// /// - inspectorStoreProvider (list)
// /// - inspectorStoreAsCoreProvider (InspectorStore)
// /// فمش محتاج تعمل حاجة هنا.


// /// ----------------------------
// /// 5) Dio
// /// ----------------------------
// final dioProvider = Provider<Dio>((ref) {
//   final env = ref.watch(customerAppEnvProvider );
//   final sessionRepo = ref.watch(sessionRepositoryProvider);
//   final logger = ref.watch(appLoggerProvider);

//   // نفس store اللي الـ UI بتشوفه
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

// /// ----------------------------
// /// 6) ApiClient
// /// ----------------------------
// final apiClientProvider = Provider<ApiClient>((ref) {
//   final dio = ref.watch(dioProvider);
//   return ApiClient(dio);
// });
