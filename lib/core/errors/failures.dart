import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  
  const Failure(this.message);
  
  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class NoInternetFailure extends Failure {
  const NoInternetFailure() : super('No internet connection');
}

class NoDataFailure extends Failure {
  const NoDataFailure() : super('No data available');
}

class TimeoutFailure extends Failure {
  const TimeoutFailure() : super('Request timeout. Please try again.');
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}
