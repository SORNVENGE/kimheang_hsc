import 'dart:convert';

class Routes {
  static const String SPLASH_SCREEN = '/splash';
  static const String LANGUAGE_SCREEN = '/select-language';
  static const String ONBOARDING_SCREEN = '/onboarding';
  static const String WELCOME_SCREEN = '/welcome';
  static const String LOGIN_SCREEN = '/login';
  static const String SIGNUP_SCREEN = '/sign-up';
  static const String VERIFY = '/verify';
  static const String VERIFYPHONE = '/verifyphone';
  static const String FORGOTPASS_SCREEN = '/forgot-password';
  static const String CREATENEWPASS_SCREEN = '/create-new-password';
  static const String CREATEACCOUNT_SCREEN = '/create-account';
  static const String DASHBOARD = '/';
  static const String MAINTAIN = '/maintain';
  static const String DASHBOARD_SCREEN = '/main';
  static const String SEARCH_SCREEN = '/search';
  static const String SEARCH_RESULT_SCREEN = '/search-result';
  static const String OFFER_SCREEN = '/offers';
  static const String CATEGORY_SCREEN = '/category';
  static const String BRAND_SCREEN = '/brand';
  static const String NOTIFICATION_SCREEN = '/notification';
  static const String CHECKOUT_SCREEN = '/checkout';
  static const String PAYMENT_SCREEN = '/payment';
  static const String ORDER_SUCCESS_SCREEN = '/order-successful';
  static const String ORDER_DETAILS_SCREEN = '/order-details';
  static const String RATE_SCREEN = '/rate-review';
  static const String ORDERTRAKING_SCREEN = '/order-tracking';
  static const String PROFILE_SCREEN = '/profile';
  static const String VIDEO_SCREEN = '/video';
  static const String ADDRESS_SCREEN = '/address';
  static const String MAP_SCREEN = '/map';
  static const String ADD_ADDRESS_SCREEN = '/add-address';
  static const String SELECTLOCATION_SCREEN = '/select-location';
  static const String CHAT_SCREEN = '/messages';
  static const String COUPON_SCREEN = '/coupons';
  static const String SUPPORT_SCREEN = '/support';
  static const String TERMS_SCREEN = '/terms';
  static const String POLICY_SCREEN = '/privacy-policy';
  static const String ABOUT_US_SCREEN = '/about-us';
  static const String productDetails = '/product-details';
  static const String REFERRAL_CODE = '/referral-code';
  static String productImages = '/product-images';

  static String getSplashRoute() => SPLASH_SCREEN;
  static String getLanguageRoute(String page) => '$LANGUAGE_SCREEN?page=$page';
  static String getOnBoardingRoute() => ONBOARDING_SCREEN;
  static String getWelcomeRoute() => WELCOME_SCREEN;
  static String getLoginRoute() => LOGIN_SCREEN;
  static String getSignUpRoute() => SIGNUP_SCREEN;
  static String getForgetPassRoute() => FORGOTPASS_SCREEN;
  static String getNewPassRoute(String email, String token) =>
      '$CREATENEWPASS_SCREEN?email=$email&token=$token';
  static String getVerifyRoute(String page, String email) =>
      '$VERIFY?page=$page&email=$email';
  // static String getVerifyRouteForPhone(String page, String phone) => '$VERIFYPHONE?page=$page&phone=$phone';
  static String getCreateAccountRoute(String email) =>
      '$CREATEACCOUNT_SCREEN?email=$email';
  static String getMainRoute() => DASHBOARD;
  static String getMaintainRoute() => MAINTAIN;
  static String getDashboardRoute(String page) =>
      '$DASHBOARD_SCREEN?page=$page';
  static String getProductDetailsRoute(int id) => '$productDetails?id=$id';
  static String getProductImageRoute(String images) =>
      '$productImages?images=$images';
  static String getSearchRoute() => SEARCH_SCREEN;
  static String getOfferRoute() => OFFER_SCREEN;
  static String getSearchResultRoute(String text) {
    List<int> _encoded = utf8.encode(text);
    String _data = base64Encode(_encoded);
    return '$SEARCH_RESULT_SCREEN?text=$_data';
  }

  static String getNotificationRoute() => NOTIFICATION_SCREEN;
  static String getCategoryRoute(int id) => '$CATEGORY_SCREEN?id=$id';
  static String getBrandRoute(int id) => '$BRAND_SCREEN?id=$id';
  static String getCheckoutRoute(double amount, String page, String type) =>
      '$CHECKOUT_SCREEN?amount=$amount&page=$page&type=$type';
  static String getPaymentRoute(String page, String id, int user) =>
      '$PAYMENT_SCREEN?page=$page&id=$id&user=$user';
  static String getOrderDetailsRoute(int id) => '$ORDER_DETAILS_SCREEN?id=$id';
  static String getRateReviewRoute() => RATE_SCREEN;
  static String getOrderTrackingRoute(int id) => '$ORDERTRAKING_SCREEN?id=$id';
  static String getProfileRoute() => PROFILE_SCREEN;
  static String getVideoRoute() => VIDEO_SCREEN;
  static String getAddressRoute() => ADDRESS_SCREEN;
  static String getMapRoute(String address, String type, String lat,
      String long, String name, String num, int id, int user) {
    return '$MAP_SCREEN?address=$address&type=$type&lat=$lat&long=$long&name=$name&num=$num&id=$id&user=$user';
  }

  static String getAddAddressRoute(
      String page,
      String action,
      String address,
      String type,
      String lat,
      String long,
      String name,
      String num,
      int id,
      int user) {
    return '$ADD_ADDRESS_SCREEN?page=$page&action=$action&address=$address&type=$type&lat=$lat&long=$long&name=$name&num=$num&id=$id&user=$user';
  }

  static String getSelectLocationRoute() => SELECTLOCATION_SCREEN;
  static String getChatRoute() => CHAT_SCREEN;
  static String getCouponRoute() => COUPON_SCREEN;
  static String getSupportRoute() => SUPPORT_SCREEN;
  static String getTermsRoute() => TERMS_SCREEN;
  static String getPolicyRoute() => POLICY_SCREEN;
  static String getAboutUsRoute() => ABOUT_US_SCREEN;
  static String getReferralCodeRoute() => REFERRAL_CODE;
}
