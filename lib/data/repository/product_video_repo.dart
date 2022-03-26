import 'package:emarket_user/data/datasource/remote/dio/dio_client.dart';
import 'package:emarket_user/data/datasource/remote/exception/api_error_handler.dart';
import 'package:emarket_user/data/model/response/base/api_response.dart';
import 'package:emarket_user/utill/app_constants.dart';
import 'package:flutter/material.dart';

class ProductVideoRepo {
  final DioClient dioClient;

  ProductVideoRepo({@required this.dioClient});

  Future<ApiResponse> getProductVideo() async {
    try {
      final response = await dioClient.get(AppConstants.PRODUCT_VIDEO_URI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
