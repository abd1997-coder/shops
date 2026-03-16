import 'package:equatable/equatable.dart';

class Shop extends Equatable {
  final String id;
  final String name;
  final String description;
  final String coverPhoto;
  final int estimatedDeliveryTime; // in minutes
  final double minimumOrder;
  final String location;
  final bool isOpen;

  const Shop({
    required this.id,
    required this.name,
    required this.description,
    required this.coverPhoto,
    required this.estimatedDeliveryTime,
    required this.minimumOrder,
    required this.location,
    required this.isOpen,
  });

  @override
  List<Object> get props => [
    id,
    name,
    description,
    coverPhoto,
    estimatedDeliveryTime,
    minimumOrder,
    location,
    isOpen,
  ];
}
