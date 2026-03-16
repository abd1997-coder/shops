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
      final errorMessage = e.toString();
      
      // Handle specific error types
      if (errorMessage.contains('NO_INTERNET')) {
        return const Left(NoInternetFailure());
      } else if (errorMessage.contains('NO_DATA')) {
        return const Left(NoDataFailure());
      } else if (errorMessage.contains('TIMEOUT')) {
        return const Left(TimeoutFailure());
      } else if (errorMessage.contains('NETWORK_ERROR')) {
        return Left(NetworkFailure(errorMessage));
      } else if (errorMessage.contains('SERVER_ERROR')) {
        return Left(ServerFailure(errorMessage));
      } else {
        return Left(ServerFailure(errorMessage));
      }
    } catch (e) {
      return Left(NetworkFailure('Unexpected error: ${e.toString()}'));
    }
  }
}
