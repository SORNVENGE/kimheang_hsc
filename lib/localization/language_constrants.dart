import 'package:flutter/material.dart';
import 'package:emarket_user/localization/app_localization.dart';

String getTranslated(String key, BuildContext context) {
  return AppLocalization.of(context).translate(key);
}