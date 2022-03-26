import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:emarket_user/data/datasource/remote/dio/dio_client.dart';
import 'package:emarket_user/data/datasource/remote/exception/api_error_handler.dart';
import 'package:emarket_user/data/model/body/cart_body.dart';
import 'package:emarket_user/data/model/response/base/api_response.dart';
import 'package:emarket_user/data/model/response/base/error_response.dart';
import 'package:flutter/material.dart';
import 'package:emarket_user/data/model/response/cart_model.dart';
import 'package:emarket_user/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartRepo{
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;
  CartRepo({@required this.dioClient,@required this.sharedPreferences});

  // List<CartModel> getCartList() {
  //   // get cart from API
  //   // do not use local storage anymore
  //   List<String> carts = [];
  //   if(sharedPreferences.containsKey(AppConstants.CART_LIST)) {
  //     carts = sharedPreferences.getStringList(AppConstants.CART_LIST);
  //   }
  //
  //   List<CartModel> cartList = [];
  //   carts.forEach((cart) => cartList.add(CartModel.fromJson(jsonDecode(cart))) );
  //   return cartList;
  // }

  Future<ApiResponse> getCartList() async {
    try {
      final response = await dioClient.get(AppConstants.GET_CART_LIST_URL + "?groupBy=project");
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // need to use api too
  // use the existing addToCartNotification
  void addToCartList(List<CartModel> cartProductList) {
    List<String> carts = [];
    cartProductList.forEach((cartModel) => carts.add(jsonEncode(cartModel)) );
    sharedPreferences.setStringList(AppConstants.CART_LIST, carts);

  }

  void saveProjectName(List<String> projectNames) {
    List<String> projectNameList = [];
    projectNames.forEach((name) => projectNameList.add(jsonEncode(name)) );
    sharedPreferences.setStringList(AppConstants.PROJECT_NAME_LIST, projectNameList);
  }

  void addProjectName(String projectName) {
    if(sharedPreferences.containsKey(AppConstants.PROJECT_NAME_LIST)) {
      List<String> pjNames = sharedPreferences.getStringList(AppConstants.PROJECT_NAME_LIST);
      pjNames.add(jsonEncode(projectName));
      sharedPreferences.setStringList(AppConstants.PROJECT_NAME_LIST, pjNames);
    }
  }

  void removeProjectName(String projectName) {
    if(sharedPreferences.containsKey(AppConstants.PROJECT_NAME_LIST)) {
      List<String> pjNames = sharedPreferences.getStringList(AppConstants.PROJECT_NAME_LIST);
      pjNames.remove(jsonEncode(projectName));
      // also need to remove via api request
      // remove all items in this project
      sharedPreferences.setStringList(AppConstants.PROJECT_NAME_LIST, pjNames);
    }
  }

  bool isProjectNameExist() {
    return sharedPreferences.containsKey(AppConstants.PROJECT_NAME_LIST);
  }

  List<String> getProjectNameFromPreference() {
    List<String> pjName = [];
    pjName = sharedPreferences.getStringList(AppConstants.PROJECT_NAME_LIST);
    List<String> projectNames = [];
    pjName.forEach((element) => projectNames.add(jsonDecode(element)));
    return projectNames;
  }

  Future<ApiResponse> getProjectNames() async {
    try {
      final response = await dioClient.get(AppConstants.PROJECT_NAME_URL);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> addToCart(CartModel cart, int quantity) async {
    if (quantity != null) {
      cart.quantity = quantity;
    }
    try {
      final response = await dioClient.post(AppConstants.ADD_CART_URL, data: cart.toJson());
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> updateCartNotification(CartBody cartBody) async {
    try {
      final response = await dioClient.post(AppConstants.UPDATE_CART_URL, data: cartBody.toJson());
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

}