import 'package:dio/dio.dart';
import 'package:emarket_user/data/datasource/remote/dio/dio_client.dart';
import 'package:emarket_user/data/datasource/remote/exception/api_error_handler.dart';
import 'package:emarket_user/data/model/response/base/api_response.dart';
import 'package:emarket_user/utill/app_constants.dart';
import 'package:flutter/foundation.dart';

class BrandRepo {
  final DioClient dioClient;

  BrandRepo({@required this.dioClient});

  Future<ApiResponse> getBrands() async {
    try {
      final response = await dioClient.get(
        '${AppConstants.BRAND_URI}',
        // options: Options(headers: {'X-localization': languageCode}),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
