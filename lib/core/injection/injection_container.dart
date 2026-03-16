import 'package:get_it/get_it.dart';
import '../../features/shops/data/datasources/shops_remote_data_source.dart';
import '../../features/shops/data/repositories/shops_repository_impl.dart';
import '../../features/shops/domain/repositories/shops_repository.dart';
import '../../features/shops/domain/usecases/get_shops.dart';
import '../../features/shops/presentation/cubit/shops_cubit.dart';
import '../network/api_client.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => ApiClient());

  // Features - Shops
  // Data sources
  sl.registerLazySingleton<ShopsRemoteDataSource>(
    () => ShopsRemoteDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<ShopsRepository>(
    () => ShopsRepositoryImpl(sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetShops(sl()));

  // Cubit
  sl.registerFactory(() => ShopsCubit(getShops: sl()));
}
