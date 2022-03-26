import 'package:flutter/material.dart';
import 'package:emarket_user/data/model/response/base/api_response.dart';
import 'package:emarket_user/data/model/response/coupon_model.dart';
import 'package:emarket_user/data/repository/coupon_repo.dart';
import 'package:emarket_user/helper/api_checker.dart';

class CouponProvider extends ChangeNotifier {
  final CouponRepo couponRepo;
  CouponProvider({@required this.couponRepo});

  List<CouponModel> _couponList;
  CouponModel _coupon;
  double _discount = 0.0;
  bool _isLoading = false;

  CouponModel get coupon => _coupon;
  double get discount => _discount;
  bool get isLoading => _isLoading;
  List<CouponModel> get couponList => _couponList;

  Future<void> getCouponList(BuildContext context) async {
    ApiResponse apiResponse = await couponRepo.getCouponList();
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _couponList = [];
      apiResponse.response.data.forEach((category) => _couponList.add(CouponModel.fromJson(category)));
      notifyListeners();
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
  }

  Future<double> applyCoupon(String coupon, double order) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await couponRepo.applyCoupon(coupon);
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _coupon = CouponModel.fromJson(apiResponse.response.data);
      if (_coupon.minPurchase != null && _coupon.minPurchase < order) {
        if(_coupon.discountType == 'percent') {
          if(_coupon.maxDiscount != null) {
            _discount = (_coupon.discount * order / 100) < _coupon.maxDiscount ? (_coupon.discount * order / 100) : _coupon.maxDiscount;
          }else {
            _discount = _coupon.discount * order / 100;
          }
        }else {
          if(_coupon.maxDiscount != null){
            _discount = _coupon.discount;
          }
          _discount = _coupon.discount;
        }
      } else {
        _discount = 0.0;
      }
    } else {
      print(apiResponse.error.toString());
      _discount = 0.0;
    }
    _isLoading = false;
    notifyListeners();
    return _discount;
  }

  void removeCouponData(bool notify) {
    _coupon = null;
    _isLoading = false;
    _discount = 0.0;
    if(notify) {
      notifyListeners();
    }
  }
}