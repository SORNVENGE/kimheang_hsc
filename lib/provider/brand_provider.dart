import 'dart:convert';

import 'package:emarket_user/data/model/response/base/api_response.dart';
import 'package:emarket_user/data/model/response/brand_model.dart';
import 'package:emarket_user/data/repository/brand_repo.dart';
import 'package:flutter/material.dart';

class BrandProvider extends ChangeNotifier {
  final BrandRepo brandRepo;

  BrandProvider({@required this.brandRepo});

  List<Brand> _brands;

  List<Brand> get brands => _brands;

  Brand _selectedBrand;

  Brand get selectedBrand => this._selectedBrand;

  Future<void> getBrands(BuildContext context) async {
    this._brands = [];
    ApiResponse apiResponse = await this.brandRepo.getBrands();
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      apiResponse.response.data.forEach(
        (data) => this._brands.add(
              Brand.fromJson(data),
            ),
      );
      // this._brands = List<Brand>.from(
      //   json.decode(apiResponse.response.data).map(
      //         (x) => Brand.fromJson(x),
      //       ),
      // );
      // this._brands = Brand.fromJson(apiResponse.response.data);
      // List<dynamic> dynList = apiResponse.response.data;
      // this._brands = dynList.cast<Brand>();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            apiResponse.error.toString(),
          ),
        ),
      );
    }
    this.notifyListeners();
  }

  void selectBrand(int id) {
    if (this._brands != null && this._brands.length > 0) {
      this._selectedBrand = this._brands.firstWhere((element) => element.id == id);
    } else {
      this._selectedBrand = null;
    }
    this.notifyListeners();
  }
}
