import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/shop.dart';

abstract class ShopsRepository {
  Future<Either<Failure, List<Shop>>> getShops();
}
