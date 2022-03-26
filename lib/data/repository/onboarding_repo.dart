import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:emarket_user/data/datasource/remote/dio/dio_client.dart';
import 'package:emarket_user/data/datasource/remote/exception/api_error_handler.dart';
import 'package:emarket_user/data/model/response/base/api_response.dart';
import 'package:emarket_user/data/model/response/onboarding_model.dart';
import 'package:emarket_user/localization/language_constrants.dart';
import 'package:emarket_user/utill/images.dart';

class OnBoardingRepo {
  final DioClient dioClient;
  OnBoardingRepo({@required this.dioClient});

  Future<ApiResponse> getOnBoardingList(BuildContext context) async {
    try {
      List<OnBoardingModel> onBoardingList = [
        OnBoardingModel(Images.onboarding_one, getTranslated('select_product', context), getTranslated('emarket_is_your_doorway', context)),
        OnBoardingModel(Images.onboarding_two, getTranslated('complete_payment', context), getTranslated('easy_and_secure_payment', context)),
        OnBoardingModel(Images.onboarding_three, getTranslated('get_the_order', context), getTranslated('get_your_order_at_the_door', context)),
      ];

      Response response = Response(requestOptions: RequestOptions(path: ''), data: onBoardingList, statusCode: 200);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
