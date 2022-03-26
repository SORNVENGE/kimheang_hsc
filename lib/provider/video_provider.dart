import 'package:emarket_user/data/model/response/product_video_model.dart';
import 'package:emarket_user/data/repository/product_repo.dart';
import 'package:flutter/material.dart';
import 'package:emarket_user/data/model/response/base/api_response.dart';
import 'package:emarket_user/helper/api_checker.dart';

class ProductVideoProvider with ChangeNotifier {
  final ProductRepo productRepo;

  ProductVideoProvider({@required this.productRepo});

  List<ProductVideoModel> _productVideoList;

  List<ProductVideoModel> get productVideoList => _productVideoList;


  Future<void> getProductVideoList(
      BuildContext context, String languageCode) async {
    print('==========> getProductVideo ');
    ApiResponse apiResponse =
        await productRepo.getProductVideoList(languageCode);
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      print(
          '==========> getProductVideo response : ${apiResponse.response.data["items"]}');
      this._productVideoList = [];
      apiResponse.response.data["items"].forEach((video) =>
          this._productVideoList.add(ProductVideoModel.fromJson(video)));
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }
}
