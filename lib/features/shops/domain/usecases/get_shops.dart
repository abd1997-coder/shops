import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/shop.dart';
import '../repositories/shops_repository.dart';

class GetShops implements UseCase<List<Shop>, NoParams> {
  final ShopsRepository repository;

  GetShops(this.repository);

  @override
  Future<Either<Failure, List<Shop>>> call(NoParams params) async {
    return await repository.getShops();
  }
}
