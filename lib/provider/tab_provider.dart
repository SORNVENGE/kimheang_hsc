import 'package:flutter/material.dart';
import 'package:emarket_user/data/model/response/base/api_response.dart';
import 'package:emarket_user/data/model/response/category_model.dart';
import 'package:emarket_user/data/repository/category_repo.dart';
import 'package:emarket_user/helper/api_checker.dart';

class TabProvider extends ChangeNotifier {
  final CategoryRepo categoryRepo;

  TabProvider({@required this.categoryRepo});

  List<CategoryModel> _categoryList;

  List<CategoryModel> get categoryList => _categoryList;

  Future<void> getCategoryList(BuildContext context, bool reload, String languageCode) async {
    if (_categoryList == null || reload) {
      ApiResponse apiResponse = await categoryRepo.getCategoryList(languageCode);
      if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
        _categoryList = [];
        apiResponse.response.data.forEach((category) => _categoryList.add(CategoryModel.fromJson(category)));
      } else {
        ApiChecker.checkApi(context, apiResponse);
      }
      notifyListeners();
    }
  }
}
