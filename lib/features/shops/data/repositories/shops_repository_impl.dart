import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/shop.dart';
import '../../domain/repositories/shops_repository.dart';
import '../datasources/shops_remote_data_source.dart';

class ShopsRepositoryImpl implements ShopsRepository {
  final ShopsRemoteDataSource remoteDataSource;

  ShopsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<Shop>>> getShops() async {
    try {
      final shops = await remoteDataSource.getShops();
      return Right(shops);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    } catch (e) {
      return Left(NetworkFailure('Network error: ${e.toString()}'));
    }
  }
}
