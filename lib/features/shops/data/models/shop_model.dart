import '../../domain/entities/shop.dart';

class ShopModel extends Shop {
  const ShopModel({
    required super.id,
    required super.name,
    required super.description,
    required super.coverPhoto,
    required super.estimatedDeliveryTime,
    required super.minimumOrder,
    required super.location,
    required super.isOpen,
  });

  factory ShopModel.fromJson(Map<String, dynamic> json) {
    // Parse shop name (multilingual object)
    final shopNameObj = json['shopName'];
    final name =
        shopNameObj is Map
            ? (shopNameObj['en']?.toString() ??
                shopNameObj['ar']?.toString() ??
                '')
            : shopNameObj?.toString() ?? '';

    // Parse description (multilingual object)
    final descriptionObj = json['description'];
    final description =
        descriptionObj is Map
            ? (descriptionObj['en']?.toString() ??
                descriptionObj['ar']?.toString() ??
                '')
            : descriptionObj?.toString() ?? '';

    // Parse minimum order (object with amount and currency)
    final minimumOrderObj = json['minimumOrder'];
    final minimumOrder =
        minimumOrderObj is Map
            ? _parseDouble(minimumOrderObj['amount'])
            : _parseDouble(minimumOrderObj);

    // Parse estimated delivery time (string like "30 minutes")
    final estimatedDeliveryTimeStr =
        json['estimatedDeliveryTime']?.toString() ?? '';
    final estimatedDeliveryTime = _parseEstimatedDeliveryTime(
      estimatedDeliveryTimeStr,
    );

    // Parse address to location string
    final addressObj = json['address'];
    final location = _parseLocation(addressObj);

    // Parse availability
    final isOpen = json['availability'] == true;

    return ShopModel(
      id: json['_id']?.toString() ?? '',
      name: name,
      description: description,
      coverPhoto: json['coverPhoto']?.toString() ?? '',
      estimatedDeliveryTime: estimatedDeliveryTime,
      minimumOrder: minimumOrder,
      location: location,
      isOpen: isOpen,
    );
  }

  static int _parseEstimatedDeliveryTime(String value) {
    if (value.isEmpty) return 0;

    // Extract number from strings like "30 minutes", "45 minutes", etc.
    final regex = RegExp(r'(\d+)');
    final match = regex.firstMatch(value);
    if (match != null) {
      return int.tryParse(match.group(1) ?? '0') ?? 0;
    }
    return 0;
  }

  static String _parseLocation(dynamic addressObj) {
    if (addressObj is! Map) return '';

    final parts = <String>[];

    if (addressObj['street']?.toString().isNotEmpty == true) {
      parts.add(addressObj['street'].toString().trim());
    }
    if (addressObj['city']?.toString().isNotEmpty == true) {
      parts.add(addressObj['city'].toString().trim());
    }
    if (addressObj['state']?.toString().isNotEmpty == true) {
      parts.add(addressObj['state'].toString().trim());
    }
    if (addressObj['country']?.toString().isNotEmpty == true) {
      parts.add(addressObj['country'].toString().trim());
    }

    return parts.join(', ');
  }

  static double _parseDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'coverPhoto': coverPhoto,
      'estimatedDeliveryTime': estimatedDeliveryTime,
      'minimumOrder': minimumOrder,
      'location': location,
      'isOpen': isOpen,
    };
  }
}
