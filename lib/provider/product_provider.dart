import 'package:emarket_user/data/model/response/cart_model.dart';
import 'package:emarket_user/data/model/response/order_details_model.dart';
import 'package:emarket_user/data/model/response/product_video_model.dart';
import 'package:emarket_user/data/model/response/review_model.dart';
import 'package:emarket_user/helper/api_checker.dart';
import 'package:emarket_user/localization/language_constrants.dart';
import 'package:emarket_user/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:emarket_user/data/model/body/review_body_model.dart';
import 'package:emarket_user/data/model/response/base/api_response.dart';
import 'package:emarket_user/data/model/response/product_model.dart';
import 'package:emarket_user/data/model/response/response_model.dart';
import 'package:emarket_user/data/repository/product_repo.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepo productRepo;

  ProductProvider({@required this.productRepo});

  // Latest products
  Product _product;
  ProductVideoModel _productVideo;
  List<Product> _popularProductList;
  List<Product> _offerProductList;
  List<Product> _releatedProductList;
  List<Product> _brandProductList;
  bool _isLoading = false;
  bool _isBrandProductLoading  = false;
  int _popularPageSize;
  int _brandProductPageSize;
  List<String> _offsetList = [];
  List<String> _brandOffsetList = [];
  List<int> _variationIndex;
  int _quantity = 1;
  int _imageSliderIndex = 0;
  List<ReviewModel> _productReviewList;
  int _tabIndex = 0;

  Product get product => _product;

  ProductVideoModel get productVideo => _productVideo;

  List<Product> get popularProductList => _popularProductList;

  List<Product> get relatedProductList => _releatedProductList;

  List<Product> get offerProductList => _offerProductList;

  List<Product> get brandProductList => _brandProductList;

  bool get isBrandProductLoading => _isBrandProductLoading;

  bool get isLoading => _isLoading;

  int get brandProductPageSize => _brandProductPageSize;

  int get popularPageSize => _popularPageSize;

  List<int> get variationIndex => _variationIndex;

  int get quantity => _quantity;

  int get imageSliderIndex => _imageSliderIndex;

  List<ReviewModel> get productReviewList => _productReviewList;

  int get tabIndex => _tabIndex;

  void getBrandProductList(String brandId, BuildContext context, String offset, String languageCode, bool reload) async {
    if (reload) {
      _brandOffsetList = [];
    }
    if (!_brandOffsetList.contains(offset)) {
      _brandOffsetList.add(offset);
      ApiResponse apiResponse = await productRepo.getBrandProductList(brandId, offset, languageCode);
      if (offset == '1') {
        _brandProductList = [];
      }
      _brandProductList.addAll(ProductModel.fromJson(apiResponse.response.data).products);
      _brandProductPageSize = ProductModel.fromJson(apiResponse.response.data).totalSize;
      _isBrandProductLoading = false;
      print("Hello :)");
      this.notifyListeners();
    } else {
      if (_isBrandProductLoading) {
        _isBrandProductLoading = false;
        this.notifyListeners();
      }
    }
  }

  void getPopularProductList(BuildContext context, String offset, bool reload, String languageCode) async {
    if (reload) {
      _offsetList = [];
    }
    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);
      ApiResponse apiResponse = await productRepo.getPopularProductList(offset, languageCode);
      if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
        if (offset == '1') {
          _popularProductList = [];
        }
        _popularProductList.addAll(ProductModel.fromJson(apiResponse.response.data).products);
        _popularPageSize = ProductModel.fromJson(apiResponse.response.data).totalSize;
        _isLoading = false;
        notifyListeners();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(apiResponse.error.toString())));
      }
    } else {
      if (isLoading) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> getProductDetails(BuildContext context, Product product, CartModel cart, String languageCode) async {
    if (product.name != null) {
      _product = product;
    } else {
      _product = null;
      notifyListeners();
      ApiResponse apiResponse = await productRepo.getProductDetails(product.id.toString(), languageCode);
      if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
        _product = Product.fromJson(apiResponse.response.data);
      } else {
        ApiChecker.checkApi(context, apiResponse);
      }
    }
    initData(_product, cart);

    // TODO: Recheck this whether it's necessarsy or not
    // Currently seems to work without notifying...
    // notifyListeners();
  }

  Future<void> getProductVideo(BuildContext context, int videoId, String languageCode) async {
    print('==========> getProductVideo : ${videoId}');
    ApiResponse apiResponse = await productRepo.getProductVideo(videoId, languageCode);
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      print('==========> getProductVideo response : ${apiResponse.response.data}');

      _productVideo = ProductVideoModel.fromJson(apiResponse.response.data);
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  Future<void> getRelatedProduct(BuildContext context, Product product, String languageCode) async {
    ApiResponse apiResponse = await productRepo.getRelatedProduct(product.id.toString(), languageCode);
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      this._releatedProductList = [];
      apiResponse.response.data.forEach((relatedProduct) => this._releatedProductList.add(Product.fromJson(relatedProduct)));
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  Future<void> getOfferProductList(BuildContext context, bool reload, String languageCode) async {
    if (offerProductList == null || reload) {
      print("Resting...");
      ApiResponse apiResponse = await productRepo.getOfferProductList(languageCode);
      if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
        _offerProductList = [];
        apiResponse.response.data.forEach((offerProduct) => _offerProductList.add(Product.fromJson(offerProduct)));
      } else {
        ApiChecker.checkApi(context, apiResponse);
      }
      notifyListeners();
    }
  }

  void showBottomLoaderBrand() {
    _isBrandProductLoading = true;
    notifyListeners();
  }

  void showBottomLoader() {
    _isLoading = true;
    notifyListeners();
  }

  void setImageSliderIndex(int index) {
    _imageSliderIndex = index;
    notifyListeners();
  }

  void initData(Product product, CartModel cart) {
    _productReviewList = null;
    _tabIndex = 0;
    _variationIndex = [];
    if (cart != null) {
      _quantity = cart.quantity;
      List<String> _variationTypes = [];
      if (cart.variation.type != null) {
        _variationTypes.addAll(cart.variation.type.split('-'));
      }
      int _varIndex = 0;
      product.choiceOptions.forEach((choiceOption) {
        for (int index = 0; index < choiceOption.options.length; index++) {
          if (choiceOption.options[index].trim().replaceAll(' ', '') == _variationTypes[_varIndex].trim()) {
            _variationIndex.add(index);
            break;
          }
        }
        _varIndex++;
      });
    } else {
      _quantity = 1;

      product.choiceOptions.forEach((element) => _variationIndex.add(0));
    }
  }

  void setQuantity(bool isIncrement, int stock, BuildContext context) {
    if (isIncrement) {
      if (_quantity >= stock) {
        showCustomSnackBar(getTranslated('out_of_stock', context), context);
      } else {
        _quantity = _quantity + 1;
      }
    } else {
      _quantity = _quantity - 1;
    }
    notifyListeners();
  }

  void setCartVariationIndex(int index, int i) {
    _variationIndex[index] = i;
    _quantity = 1;
    notifyListeners();
  }

  List<int> _ratingList = [];
  List<String> _reviewList = [];
  List<bool> _loadingList = [];
  List<bool> _submitList = [];
  int _deliveryManRating = 0;

  List<int> get ratingList => _ratingList;

  List<String> get reviewList => _reviewList;

  List<bool> get loadingList => _loadingList;

  List<bool> get submitList => _submitList;

  int get deliveryManRating => _deliveryManRating;

  void initRatingData(List<OrderDetailsModel> orderDetailsList) {
    _ratingList = [];
    _reviewList = [];
    _loadingList = [];
    _submitList = [];
    _deliveryManRating = 0;
    orderDetailsList.forEach((orderDetails) {
      _ratingList.add(0);
      _reviewList.add('');
      _loadingList.add(false);
      _submitList.add(false);
    });
  }

  void setRating(int index, int rate) {
    _ratingList[index] = rate;
    notifyListeners();
  }

  void setReview(int index, String review) {
    _reviewList[index] = review;
  }

  void setDeliveryManRating(int rate) {
    _deliveryManRating = rate;
    notifyListeners();
  }

  Future<ResponseModel> submitReview(int index, ReviewBody reviewBody) async {
    _loadingList[index] = true;
    notifyListeners();

    ApiResponse response = await productRepo.submitReview(reviewBody);
    ResponseModel responseModel;
    if (response.response != null && response.response.statusCode == 200) {
      _submitList[index] = true;
      responseModel = ResponseModel(true, 'Review submitted successfully');
      notifyListeners();
    } else {
      String errorMessage;
      if (response.error is String) {
        errorMessage = response.error.toString();
      } else {
        errorMessage = response.error.errors[0].message;
      }
      responseModel = ResponseModel(false, errorMessage);
    }
    _loadingList[index] = false;
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> submitDeliveryManReview(ReviewBody reviewBody) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse response = await productRepo.submitDeliveryManReview(reviewBody);
    ResponseModel responseModel;
    if (response.response != null && response.response.statusCode == 200) {
      _deliveryManRating = 0;
      responseModel = ResponseModel(true, 'Review submitted successfully');
      notifyListeners();
    } else {
      String errorMessage;
      if (response.error is String) {
        errorMessage = response.error.toString();
      } else {
        errorMessage = response.error.errors[0].message;
      }
      responseModel = ResponseModel(false, errorMessage);
    }
    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  void getProductReviews(BuildContext context, int productID) async {
    ApiResponse response = await productRepo.getProductReviewList(productID);
    if (response.response != null && response.response.statusCode == 200) {
      _productReviewList = [];
      response.response.data.forEach((review) => _productReviewList.add(ReviewModel.fromJson(review)));
    } else {
      String errorMessage;
      if (response.error is String) {
        errorMessage = response.error.toString();
      } else {
        errorMessage = response.error.errors[0].message;
      }
      ApiChecker.checkApi(context, response);
    }
    notifyListeners();
  }

  void setTabIndex(int index) {
    _tabIndex = index;
    notifyListeners();
  }
}
