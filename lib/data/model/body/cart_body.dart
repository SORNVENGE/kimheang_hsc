import 'package:emarket_user/data/model/response/product_model.dart';
import 'package:flutter/material.dart';

class CartBody {
  int _productId;
  int _quantity;
  List<Variation> _variation;
  String _project;


  CartBody({@required int productId, @required int quantity}) {
    this._productId = productId;
    this._quantity = quantity;
  }

  int get productId => _productId;
  int get quantity => _quantity;

  CartBody.fromJson(Map<String, dynamic> json) {
    _productId = json['product_id'];
    _quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['product_id'] = this._productId;
    data['quantity'] = this._quantity;
    return data;
  }
}


