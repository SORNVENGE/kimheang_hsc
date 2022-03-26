import 'package:flutter/material.dart';
import 'package:emarket_user/data/model/response/language_model.dart';
import 'package:emarket_user/utill/app_constants.dart';

class LanguageRepo {
  List<LanguageModel> getAllLanguages({BuildContext context}) {
    return AppConstants.languages;
  }
}
