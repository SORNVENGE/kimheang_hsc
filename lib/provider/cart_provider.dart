import 'dart:convert';
import 'dart:ffi';

import 'package:emarket_user/data/model/body/cart_body.dart';
import 'package:emarket_user/data/model/response/base/api_response.dart';
import 'package:emarket_user/data/model/response/base/error_response.dart';
import 'package:emarket_user/helper/api_checker.dart';
import 'package:emarket_user/localization/language_constrants.dart';
import 'package:emarket_user/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:emarket_user/data/model/response/cart_model.dart';
import 'package:emarket_user/data/repository/cart_repo.dart';

class CartProvider extends ChangeNotifier {
  final CartRepo cartRepo;
  CartProvider({@required this.cartRepo});

  List<CartItems> _cartList = [];
  double _amount = 0.0;
  int _totalSize = 0;

  List<CartItems> get cartList => _cartList;
  int get totalSize => _totalSize;
  double get amount => _amount;
  List<String> _projectNames = [];
  List<String> get projectNames => _projectNames;

  Future<void> getCartData() async {
    print("Jol get cart data");
    //   List<CartModel> cartList = [];
    //   carts.forEach((cart) => cartList.add(CartModel.fromJson(jsonDecode(cart))) );
    //   return cartList;
    ApiResponse apiResponse = await cartRepo.getCartList();
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      var json = Items.fromJson(apiResponse.response.data);
      print("new map json ==> ${json.toJson()}");
      // _cartList = [];
      _cartList = Items.fromJson(apiResponse.response.data).items;
      _totalSize = Items.fromJson(apiResponse.response.data).totalSize;

      // _cartList.forEach((cart) {
      //   _amount = _amount + (cart.discountedPrice * cart.quantity);
      // });
    } else {
      ApiChecker.checkApi(null, apiResponse);
    }
    notifyListeners();
  }

  Future<int> addToCart(CartModel cartModel, BuildContext context, int quantity) async {
    // if (cartModel.quantity > 0) {
    //   _totalSize += cartModel.quantity;
    // }
    print("quantiyyyyy ==> $quantity}");
    // if (index != null) {
    //   CartModel existingCart = _cartList.firstWhere(((element) => element.product.id == cartModel.product.id), orElse: null);
    //   if (existingCart != null) {
    //     // print("SHOULD BE TRUE HERE ... ${existingCart.variation}");
    //     // print("SHOULD BE TRUE HERE ... ${cartModel.variation}");
    //     bool isSameVariation = existingCart.variation.every((element) => cartModel.variation.any((_element) => element == _element));
    //     // Same Product, Same Variation
    //     if (isSameVariation) {
    //       int existingCartIndex = _cartList.indexOf(existingCart);
    //       _cartList[existingCartIndex].quantity = _cartList[existingCartIndex].quantity + cartModel.quantity;
    //     } else {
    //       // Same Production, Different Variation
    //       cartList[index] = cartModel;
    //     }
    //   } else {
    //     _amount = _amount - (_cartList[index].discountedPrice * _cartList[index].quantity);
    //     _cartList.replaceRange(index, index + 1, [cartModel]);
    //   }
    // } else {
    //   _cartList.add(cartModel);
    // }
    // // TODO: COMPARE IF CURRENT CARTT ALREADY EXISTS
    // _amount = _amount + (cartModel.discountedPrice * cartModel.quantity);
    // cartRepo.addToCartList(_cartList);
    //
    // Add cart notification
    // CartBody cartBody = CartBody(productId: cartModel.product.id, quantity: cartModel.quantity); // check here to request to new api
    ApiResponse apiResponse = await cartRepo.addToCart(cartModel, quantity);
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      // reload current cart after add
      getCartData();
      if (apiResponse.response.data['cart'] != null) {
        return apiResponse.response.data['cart']['quantity'];
      } else return 0;
    } else {
      String errorMessage;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors);
        errorMessage = errorResponse.errors[0].message;
      }
    }
    notifyListeners();
    return cartModel.quantity;
  }

  Future<void> setQuantity(bool isIncrement, CartModel cart, int stock, BuildContext context) async {
    // print('from cart screen');
    // int index = _cartList.indexOf(cart);
    // CartBody updateCart;
    // ApiResponse apiResponse;
    // if (isIncrement) {
    //   if (_cartList[index].quantity >= stock) {
    //     showCustomSnackBar(getTranslated('out_of_stock', context), context);
    //   } else {
    //     _cartList[index].quantity = _cartList[index].quantity + 1;
    //     _amount = _amount + _cartList[index].discountedPrice;
    //     // update cart notification
    //     updateCart = new CartBody(productId: cart.product.id, quantity: _cartList[index].quantity);
    //     apiResponse = await cartRepo.updateCartNotification(updateCart);
    //   }
    // } else {
    //   _cartList[index].quantity = _cartList[index].quantity - 1;
    //   _amount = _amount - _cartList[index].discountedPrice;
    //   // update cart notification
    //   updateCart = new CartBody(productId: cart.product.id, quantity: _cartList[index].quantity);
    //   apiResponse = await cartRepo.updateCartNotification(updateCart);
    // }
    // cartRepo.addToCartList(_cartList);
    // if (apiResponse != null) {
    //   if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
    //     print('-------- update Cart notify successfully ----------');
    //   } else {
    //     if (apiResponse.error is String) {
    //       print(apiResponse.error.toString());
    //     } else {
    //       ErrorResponse errorResponse = apiResponse.error;
    //       print(errorResponse.errors[0].message);
    //     }
    //   }
    // }

    notifyListeners();
  }

  Future<void> removeFromCart(CartModel cart) async {
    // _cartList.remove(cart);
    // // remove cart notification by provide quantity = 0
    // CartBody removeCart = new CartBody(productId: cart.product.id, quantity: 0);
    // ApiResponse apiResponse = await cartRepo.updateCartNotification(removeCart);
    // if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
    //   print('-------- Remove Cart notify successfully ----------');
    // } else {
    //   if (apiResponse.error is String) {
    //     print(apiResponse.error.toString());
    //   } else {
    //     ErrorResponse errorResponse = apiResponse.error;
    //     print(errorResponse.errors[0].message);
    //   }
    // }
    // _amount = _amount - (cart.discountedPrice * cart.quantity);
    // cartRepo.addToCartList(_cartList);

    notifyListeners();
  }

  Future<void> getProjectNames(BuildContext context) async {
    if (isProjectNameExist()) {
      _projectNames = getProjectNameFromPreference();
    } else {
      ApiResponse apiResponse = await cartRepo.getProjectNames();
      if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
        List<String> defaultProjectNames = ["My project"];
        var itemsJson = apiResponse.response.data['items'];
        List<String> items = itemsJson.toString() != "[]" ? List.from(itemsJson) : defaultProjectNames;
        saveProjectName(items);
        _projectNames = items;
      } else {
        ApiChecker.checkApi(context, apiResponse);
      }
    }
    notifyListeners();
  }

  void addProjectName(String projectName) {
    cartRepo.addProjectName(projectName);
  }

  void removeProjectName(String projectName) {
    cartRepo.removeProjectName(projectName);
  }

  void saveProjectName(List<String> projectNames) {
    cartRepo.saveProjectName(projectNames);
  }

  bool isProjectNameExist() {
    return cartRepo.isProjectNameExist();
  }

  List<String> getProjectNameFromPreference() {
    return cartRepo.getProjectNameFromPreference();
  }

  void clearCartList() {
    // _cartList = [];
    // _amount = 0;
    // cartRepo.addToCartList(_cartList);
    notifyListeners();
  }

  // TODO: REfactor this method
  bool isExistInCart(CartModel cartModel, bool isUpdate, int cartIndex) {
    // for (int index = 0; index < _cartList.length; index++) {
    //   if (_cartList[index].product.id == cartModel.product.id &&
    //       (_cartList[index].variation.length > 0 ? _cartList[index].variation[0].type == cartModel.variation[0].type : true)) {
    //     return true;
    //   }
    // }
    return false;
  }

  // TODO: Re-check this code
  bool getExistProduct(CartModel cartModel, bool isUpdate, int cartIndex) {
    // cartModel.
    // CartModel cart = _cartList.firstWhere(( (element) => cartModel.product.id == element.product.id ), orElse: null);
    // // return false;
    // print("CART INDEX IS ${cart.variation}");
    // if (cart != null) {
    //   // return cart.variation[cartIndex].type == cartModel.variation[cartIndex].type;
    //   return false;
    // } else {
    //   return false;
    // }
    return false;
  }
}
