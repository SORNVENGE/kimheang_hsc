import 'dart:convert';

import 'package:emarket_user/data/model/response/brand_model.dart';
import 'package:emarket_user/data/model/response/cart_model.dart';
import 'package:emarket_user/data/model/response/product_model.dart';
import 'package:emarket_user/view/screens/brand/brand_screen.dart';
import 'package:emarket_user/view/screens/offer/offer_product_screen.dart';
import 'package:emarket_user/view/screens/product/product_details_screen.dart';
import 'package:emarket_user/view/screens/product/product_image_screen.dart';
import 'package:emarket_user/view/screens/referral_code/referral_code_screen.dart';
import 'package:emarket_user/view/screens/video/video_screen.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:emarket_user/data/model/response/address_model.dart';
import 'package:emarket_user/data/model/response/category_model.dart';
import 'package:emarket_user/data/model/response/order_model.dart';
import 'package:emarket_user/helper/html_type.dart';
import 'package:emarket_user/utill/routes.dart';
import 'package:emarket_user/view/base/map_widget.dart';
import 'package:emarket_user/view/base/not_found.dart';
import 'package:emarket_user/view/screens/address/add_new_address_screen.dart';
import 'package:emarket_user/view/screens/address/address_screen.dart';
import 'package:emarket_user/view/screens/address/select_location_screen.dart';
import 'package:emarket_user/view/screens/auth/create_account_screen.dart';
import 'package:emarket_user/view/screens/auth/login_screen.dart';
import 'package:emarket_user/view/screens/auth/signup_screen.dart';
import 'package:emarket_user/view/screens/category/category_screen.dart';
import 'package:emarket_user/view/screens/chat/chat_screen.dart';
import 'package:emarket_user/view/screens/checkout/checkout_screen.dart';
import 'package:emarket_user/view/screens/checkout/order_successful_screen.dart';
import 'package:emarket_user/view/screens/checkout/payment_screen.dart';
import 'package:emarket_user/view/screens/coupon/coupon_screen.dart';
import 'package:emarket_user/view/screens/dashboard/dashboard_screen.dart';
import 'package:emarket_user/view/screens/forgot_password/create_new_password_screen.dart';
import 'package:emarket_user/view/screens/forgot_password/forgot_password_screen.dart';
import 'package:emarket_user/view/screens/forgot_password/verification_screen.dart';
import 'package:emarket_user/view/screens/html/html_viewer_screen.dart';
import 'package:emarket_user/view/screens/language/choose_language_screen.dart';
import 'package:emarket_user/view/screens/notification/notification_screen.dart';
import 'package:emarket_user/view/screens/onboarding/onboarding_screen.dart';
import 'package:emarket_user/view/screens/order/order_details_screen.dart';
import 'package:emarket_user/view/screens/profile/profile_screen.dart';
import 'package:emarket_user/view/screens/rare_review/rate_review_screen.dart';
import 'package:emarket_user/view/screens/search/search_result_screen.dart';
import 'package:emarket_user/view/screens/search/search_screen.dart';
import 'package:emarket_user/view/screens/splash/splash_screen.dart';
import 'package:emarket_user/view/screens/support/support_screen.dart';
import 'package:emarket_user/view/screens/track/order_tracking_screen.dart';
import 'package:emarket_user/view/screens/welcome_screen/welcome_screen.dart';
import 'package:emarket_user/view/screens/auth/maintainance_screen.dart';

class RouterHelper {
  static final FluroRouter router = FluroRouter();

//*******Handlers*********
  static Handler _splashHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) => SplashScreen());
  static Handler _maintainHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) =>
          MaintenanceScreen());

  static Handler _languageHandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) {
    return ChooseLanguageScreen(fromMenu: params['page'][0] == 'menu');
  });

  static Handler _onbordingHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) =>
          OnBoardingScreen());

  static Handler _welcomeHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) => WelcomeScreen());

  static Handler _loginHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) => LoginScreen());

  static Handler _signUpHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) => SignUpScreen());

  static Handler _productDetailsHandler =
      Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    ProductDetailsScreen _productDetailsScreen =
        ModalRoute.of(context).settings.arguments;
    return _productDetailsScreen != null
        ? _productDetailsScreen
        : ProductDetailsScreen(
            product: Product(id: int.parse(params['id'][0])));
  });

  static Handler _productImagesHandler =
      Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    ProductImageScreen _productImageScreen =
        ModalRoute.of(context).settings.arguments;
    return _productImageScreen != null
        ? _productImageScreen
        : ProductImageScreen(imageList: jsonDecode(params['images'][0]));
  });

  static Handler _verificationHandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) {
    VerificationScreen _verificationScreen =
        ModalRoute.of(context).settings.arguments;
    return _verificationScreen != null
        ? _verificationScreen
        : VerificationScreen(
            fromSignUp: params['page'][0] == 'sign-up',
            emailAddress: params['email'][0],
          );
  });
  static Handler _offerHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) =>
          OfferProductScreen());

  static Handler _forgotPassHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) =>
          ForgotPasswordScreen());

  static Handler _createNewPassHandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) {
    CreateNewPasswordScreen _createPassScreen =
        ModalRoute.of(context).settings.arguments;
    return _createPassScreen != null
        ? _createPassScreen
        : CreateNewPasswordScreen(
            email: params['email'][0],
            resetToken: params['token'][0],
          );
  });

  static Handler _createAccountHandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) {
    return CreateAccountScreen(email: params['email'][0]);
  });

  static Handler _dashScreenBoardHandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) {
    return DashboardScreen(
        pageIndex: params['page'][0] == 'home'
            ? 0
            : params['page'][0] == 'cart'
                ? 1
                : params['page'][0] == 'order'
                    ? 2
                    : params['page'][0] == 'favourite'
                        ? 3
                        : params['page'][0] == 'menu'
                            ? 4
                            : 0);
  });

  static Handler _deshboardHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) =>
          DashboardScreen(pageIndex: 0));

  static Handler _searchHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) => SearchScreen());

  static Handler _searchResultHandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) {
    print('--------------${params['text'][0]}');
    List<int> _decode = base64Decode(params['text'][0]);
    String _data = utf8.decode(_decode);
    return SearchResultScreen(searchString: _data);
  });

  static Handler _brandHandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) {
    BrandScreen _brandScreen =
        ModalRoute.of(context).settings.arguments as BrandScreen;
    return _brandScreen != null
        ? _brandScreen
        : BrandScreen(brand: Brand(id: int.parse(params['id'][0])));
  });

  static Handler _categoryHandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) {
    CategoryScreen _categoryScreen =
        ModalRoute.of(context).settings.arguments as CategoryScreen;
    return _categoryScreen != null
        ? _categoryScreen
        : CategoryScreen(
            categoryModel: CategoryModel(id: int.parse(params['id'][0])));
  });

  static Handler _notificationHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) =>
          NotificationScreen());

/*  static Handler _checkoutHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) {
    CheckoutScreen _checkoutScreen = ModalRoute.of(context).settings.arguments as CheckoutScreen;
    bool _fromCart = params['page'][0] == 'cart';
    return _checkoutScreen != null ? _checkoutScreen : !_fromCart ? NotFound() : CheckoutScreen(
      amount: double.parse(params['amount'][0]), orderType: params['type'][0], cartList: null, fromCart: params['page'][0] == 'cart',
    );
  });*/
  static Handler _checkoutHandler =
      Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    CheckoutScreen _checkoutScreen = ModalRoute.of(context).settings.arguments;
    List<CartModel> _carts = [];
    //jsonDecode(params['carts'][0]).forEach((cart) => _carts.add(jsonDecode(cart)));
    return _checkoutScreen != null
        ? _checkoutScreen
        : CheckoutScreen(
            orderType: params['type'][0],
            fromCart: params['page'][0] == 'cart',
            amount: double.parse(params['amount'][0]),
            cartList: _carts,
          );
  });

  static Handler _paymentHandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) {
    return PaymentScreen(
      fromCheckout: params['page'][0] == 'checkout',
      orderModel: OrderModel(
        userId: int.parse(params['user'][0]),
        id: int.parse(params['id'][0]),
      ),
    );
  });

  static Handler _orderSuccessHandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) {
    int _status = (params['status'][0] == 'success' ||
            params['status'][0] == 'payment-success')
        ? 0
        : params['status'][0] == 'fail'
            ? 1
            : 2;
    return OrderSuccessfulScreen(orderID: params['id'][0], status: _status);
  });

  static Handler _orderDetailsHandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) {
    OrderDetailsScreen _orderDetailsScreen =
        ModalRoute.of(context).settings.arguments as OrderDetailsScreen;
    return _orderDetailsScreen != null
        ? _orderDetailsScreen
        : OrderDetailsScreen(
            orderId: int.parse(params['id'][0]), orderModel: null);
  });

  static Handler _rateReviewHandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) {
    RateReviewScreen _rateReviewScreen =
        ModalRoute.of(context).settings.arguments as RateReviewScreen;
    return _rateReviewScreen != null ? _rateReviewScreen : NotFound();
  });

  static Handler _orderTrackingHandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) {
    return OrderTrackingScreen(orderID: params['id'][0]);
  });

  static Handler _profileHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) => ProfileScreen());

  static Handler _videoHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) => VideoScreen());

  static Handler _addressHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) => AddressScreen());

  static Handler _mapHandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) {
    return MapWidget(
        address: AddressModel(
      id: int.parse(params['id'][0]),
      userId: int.parse(params['user'][0]),
      contactPersonName: params['name'][0],
      contactPersonNumber: params['num'][0],
      latitude: params['lat'][0],
      longitude: params['long'][0],
      addressType: params['type'][0],
      address: params['address'][0],
    ));
  });

  static Handler _newAddressHandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) {
    bool _isUpdate = params['action'][0] == 'update';
    AddressModel _addressModel;
    if (_isUpdate) {
      _addressModel = AddressModel(
        id: int.parse(params['id'][0]),
        userId: int.parse(params['user'][0]),
        contactPersonName: params['name'][0],
        contactPersonNumber: params['num'][0],
        latitude: params['lat'][0],
        longitude: params['long'][0],
        addressType: params['type'][0],
        address: params['address'][0],
      );
    }
    return AddNewAddressScreen(
        fromCheckout: params['page'][0] == 'checkout',
        isEnableUpdate: _isUpdate,
        address: _isUpdate ? _addressModel : null);
  });

  static Handler _selectLocationHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) =>
          SelectLocationScreen());

  static Handler _chatHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) => ChatScreen());

  static Handler _couponHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) => CouponScreen());

  static Handler _supportHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) => SupportScreen());

  static Handler _termsHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) =>
          HtmlViewerScreen(htmlType: HtmlType.TERMS_AND_CONDITION));

  static Handler _policyHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) =>
          HtmlViewerScreen(htmlType: HtmlType.PRIVACY_POLICY));

  static Handler _aboutUsHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) =>
          HtmlViewerScreen(htmlType: HtmlType.ABOUT_US));

  static Handler _referralCodeHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) => ReferralCodeScreen());

  static Handler _notFoundHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) => NotFound());

//*******Route Define*********
  static void setupRouter() {
    router.notFoundHandler = _notFoundHandler;
    router.define(Routes.SPLASH_SCREEN,
        handler: _splashHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.LANGUAGE_SCREEN,
        handler: _languageHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.ONBOARDING_SCREEN,
        handler: _onbordingHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.WELCOME_SCREEN,
        handler: _welcomeHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.LOGIN_SCREEN,
        handler: _loginHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.SIGNUP_SCREEN,
        handler: _signUpHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.VERIFY,
        handler: _verificationHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.CREATEACCOUNT_SCREEN,
        handler: _createAccountHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.FORGOTPASS_SCREEN,
        handler: _forgotPassHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.CREATENEWPASS_SCREEN,
        handler: _createNewPassHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.DASHBOARD_SCREEN,
        handler: _dashScreenBoardHandler,
        transitionType: TransitionType.fadeIn); // ?page=home
    router.define(Routes.DASHBOARD,
        handler: _deshboardHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.productImages,
        handler: _productImagesHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.SEARCH_SCREEN,
        handler: _searchHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.SEARCH_RESULT_SCREEN,
        handler: _searchResultHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.CATEGORY_SCREEN,
        handler: _categoryHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.BRAND_SCREEN,
        handler: _brandHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.productDetails,
        handler: _productDetailsHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.OFFER_SCREEN,
        handler: _offerHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.NOTIFICATION_SCREEN,
        handler: _notificationHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.CHECKOUT_SCREEN,
        handler: _checkoutHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.PAYMENT_SCREEN,
        handler: _paymentHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.ORDER_SUCCESS_SCREEN + '/:id/:status',
        handler: _orderSuccessHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.ORDER_DETAILS_SCREEN,
        handler: _orderDetailsHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.RATE_SCREEN,
        handler: _rateReviewHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.ORDERTRAKING_SCREEN,
        handler: _orderTrackingHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.PROFILE_SCREEN,
        handler: _profileHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.VIDEO_SCREEN,
        handler: _videoHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.ADDRESS_SCREEN,
        handler: _addressHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.MAP_SCREEN,
        handler: _mapHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.ADD_ADDRESS_SCREEN,
        handler: _newAddressHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.SELECTLOCATION_SCREEN,
        handler: _selectLocationHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.CHAT_SCREEN,
        handler: _chatHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.COUPON_SCREEN,
        handler: _couponHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.SUPPORT_SCREEN,
        handler: _supportHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.TERMS_SCREEN,
        handler: _termsHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.POLICY_SCREEN,
        handler: _policyHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.ABOUT_US_SCREEN,
        handler: _aboutUsHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.MAINTAIN,
        handler: _maintainHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.REFERRAL_CODE,
        handler: _referralCodeHandler, transitionType: TransitionType.fadeIn);
  }
}
