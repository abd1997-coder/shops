import 'package:dio/dio.dart';
import 'package:shops/core/constants/app_strings.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/dio_error_handler.dart';
import '../models/shop_model.dart';

abstract class ShopsRemoteDataSource {
  Future<List<ShopModel>> getShops();
}

class ShopsRemoteDataSourceImpl implements ShopsRemoteDataSource {
  final ApiClient apiClient;

  ShopsRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<ShopModel>> getShops() async {
    try {
      final response = await apiClient.dio.get(
        ApiConstants.shopsEndpoint,
        queryParameters: {AppStrings.deviceKind: "Mobile"},
      );

      if (response.statusCode == 200) {
        // API returns { "result": [...] }
        final responseData = response.data;
        final List<dynamic> shopsList;

        if (responseData is Map && responseData.containsKey('result')) {
          shopsList = responseData['result'] as List<dynamic>;
        } else if (responseData is List) {
          shopsList = responseData;
        } else {
          throw Exception('Unexpected response format');
        }

        // Check if data is empty
        if (shopsList.isEmpty) {
          throw Exception('NO_DATA');
        }

        return shopsList
            .map((json) => ShopModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load shops: ${response.statusCode}');
      }
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      // Re-throw specific exceptions
      if (e.toString().contains('NO_DATA') ||
          e.toString().contains('NO_INTERNET') ||
          e.toString().contains('TIMEOUT')) {
        rethrow;
      }
      throw Exception('UNKNOWN_ERROR: ${e.toString()}');
    }
  }
}
