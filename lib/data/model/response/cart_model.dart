import 'package:emarket_user/data/model/response/product_model.dart';

class CartModel {
  int _id;
  double _price;
  double _discountedPrice;
  Variation _variation;
  double _discountAmount;
  int _quantity;
  double _taxAmount;
  int _maxQty;
  Product _product;
  String _project;

  CartModel(
        double price,
        double discountedPrice,
        Variation variation,
        double discountAmount,
        int quantity,
        double taxAmount,
        int maxQty,
        Product product) {
    this._price = price;
    this._discountedPrice = discountedPrice;
    this._variation = variation;
    this._discountAmount = discountAmount;
    this._quantity = quantity;
    this._taxAmount = taxAmount;
    this._maxQty = maxQty;
    this._product = product;
  }

  int get id => _id;
  double get price => _price;
  double get discountedPrice => _discountedPrice;
  Variation get variation => _variation;
  double get discountAmount => _discountAmount;
  // ignore: unnecessary_getters_setters
  int get quantity => _quantity;
  // ignore: unnecessary_getters_setters
  set quantity(int qty) => _quantity = qty;
  double get taxAmount => _taxAmount;
  int get maxQty => _maxQty;
  Product get product => _product;
  // ignore: unnecessary_getters_setters
  String get projectName => _project;
  // ignore: unnecessary_getters_setters
  set projectName(String projectName) => _project = projectName;

  CartModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _price = json['price'].toDouble();
    // _price = json['price'];
    // _discountedPrice = json['discountedPrice'];
    _discountedPrice = json['discountedPrice'].toDouble();
    if (json['variations'] != null) {
      _variation = Variation.fromJson(json['variations']);
    }
    _discountAmount = json['discountAmount'].toDouble();
    // _discountAmount = json['discountAmount'];
    _quantity = json['quantity'];
    _taxAmount = json['taxAmount'].toDouble();
    // _taxAmount = json['taxAmount'];
    _maxQty = json['maxQty'];
    if (json['product'] != null) {
      _product = Product.fromJson(json['product']);
    }
    _project = json['project'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['price'] = this._price;
    data['discountedPrice'] = this._discountedPrice;
    data['variations'] = this._variation.toJson();
    data['discountAmount'] = this._discountAmount;
    data['quantity'] = this._quantity;
    data['taxAmount'] = this._taxAmount;
    data['maxQty'] = this._maxQty;
    data['product_id'] = this._product.id;
    data['project'] = this._project;
    return data;
  }
}

class CartItems {
  String _project;
  List<CartModel> _items;
  // ignore: unnecessary_getters_setters
  String get project => _project;
  // ignore: unnecessary_getters_setters
  set project(String projectName) => _project = projectName;
  List<CartModel> get items => _items;

  CartItems.fromJson(Map<String, dynamic> json) {
    _project = json['project'];
    if (json['items'] != null) {
      _items = [];
      json['items'].forEach((v) {
        _items.add(new CartModel.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['project'] = _project;
    if (this._items != null) {
      data['items'] = this._items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  int _totalSize;
  List<CartItems> _items;
  List<CartItems> get items => _items;
  int get totalSize => _totalSize;
  Items.fromJson(Map<String, dynamic> json) {
    _totalSize = json['total_size'];
    if (json['items'] != null) {
      _items = [];
      json['items'].forEach((v) {
        _items.add(new CartItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['items'] = _items;
    if (this._items != null) {
      data['items'] = this._items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
