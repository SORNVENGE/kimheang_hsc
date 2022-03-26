import 'dart:io';

import 'package:flutter/material.dart';
import 'package:emarket_user/data/model/response/response_model.dart';
import 'package:emarket_user/data/model/response/userinfo_model.dart';
import 'package:emarket_user/helper/responsive_helper.dart';
import 'package:emarket_user/localization/language_constrants.dart';
import 'package:emarket_user/provider/auth_provider.dart';
import 'package:emarket_user/provider/profile_provider.dart';
import 'package:emarket_user/provider/splash_provider.dart';
import 'package:emarket_user/utill/color_resources.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:emarket_user/utill/images.dart';
import 'package:emarket_user/utill/styles.dart';
import 'package:emarket_user/view/base/custom_app_bar.dart';
import 'package:emarket_user/view/base/custom_button.dart';
import 'package:emarket_user/view/base/custom_snackbar.dart';
import 'package:emarket_user/view/base/custom_text_field.dart';
import 'package:emarket_user/view/base/not_logged_in_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  FocusNode _firstNameFocus;
  FocusNode _lastNameFocus;
  FocusNode _emailFocus;
  FocusNode _phoneNumberFocus;
  FocusNode _passwordFocus;
  FocusNode _confirmPasswordFocus;
  TextEditingController _firstNameController;
  TextEditingController _lastNameController;
  TextEditingController _emailController;
  TextEditingController _phoneNumberController;
  TextEditingController _passwordController;
  TextEditingController _confirmPasswordController;

  PickedFile file;
  final picker = ImagePicker();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  bool _isLoggedIn;

  void _choose() async {
    PickedFile pickedFile = await picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 500,
        maxWidth: 500);
    setState(() {
      if (pickedFile != null) {
        file = pickedFile;
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _isLoggedIn =
        Provider.of<AuthProvider>(context, listen: false).isLoggedIn();

    if (_isLoggedIn) {
      Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
    }

    _firstNameFocus = FocusNode();
    _lastNameFocus = FocusNode();
    _emailFocus = FocusNode();
    _phoneNumberFocus = FocusNode();
    _passwordFocus = FocusNode();
    _confirmPasswordFocus = FocusNode();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    if (Provider.of<ProfileProvider>(context, listen: false).userInfoModel !=
        null) {
      UserInfoModel _userInfoModel =
          Provider.of<ProfileProvider>(context, listen: false).userInfoModel;
      _firstNameController.text = _userInfoModel.fName ?? '';
      _lastNameController.text = _userInfoModel.lName ?? '';
      _phoneNumberController.text = _userInfoModel.phone ?? '';
      _emailController.text = _userInfoModel.email ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(title: getTranslated('my_profile', context)),
      body: _isLoggedIn
          ? Consumer<ProfileProvider>(
              builder: (context, profileProvider, child) {
                return profileProvider.userInfoModel != null
                    ? Column(
                        children: [
                          Expanded(
                            child: Scrollbar(
                              child: SingleChildScrollView(
                                physics: BouncingScrollPhysics(),
                                padding: EdgeInsets.all(
                                    Dimensions.PADDING_SIZE_SMALL),
                                child: Center(
                                  child: SizedBox(
                                    width: 1170,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // for profile image
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: Dimensions
                                                  .PADDING_SIZE_LARGE),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: ColorResources.BORDER_COLOR,
                                            border: Border.all(
                                                color: ColorResources
                                                    .COLOR_GREY_CHATEAU,
                                                width: 3),
                                            shape: BoxShape.circle,
                                          ),
                                          child: InkWell(
                                            onTap: _choose,
                                            child: Stack(
                                              clipBehavior: Clip.none,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  child: getImage(
                                                      context, profileProvider),
                                                ),
                                                Positioned(
                                                  bottom: 15,
                                                  right: -10,
                                                  child: InkWell(
                                                    onTap: _choose,
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      padding:
                                                          EdgeInsets.all(2),
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: ColorResources
                                                            .BORDER_COLOR,
                                                        border: Border.all(
                                                            width: 2,
                                                            color: ColorResources
                                                                .COLOR_GREY_CHATEAU),
                                                      ),
                                                      child: Icon(Icons.edit,
                                                          size: 13),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        // for name
                                        Center(
                                          child: Text(
                                            '${profileProvider.userInfoModel.fName} ${profileProvider.userInfoModel.lName}',
                                            style: rubikMedium.copyWith(
                                                fontSize: Dimensions
                                                    .FONT_SIZE_EXTRA_LARGE),
                                          ),
                                        ),

                                        SizedBox(height: 28),
                                        // for first name section
                                        Text(
                                          getTranslated('first_name', context),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline2
                                              .copyWith(
                                                color:
                                                    ColorResources.getHintColor(
                                                        context),
                                              ),
                                        ),
                                        SizedBox(
                                            height:
                                                Dimensions.PADDING_SIZE_SMALL),
                                        CustomTextField(
                                          hintText: 'John',
                                          isShowBorder: true,
                                          controller: _firstNameController,
                                          focusNode: _firstNameFocus,
                                          nextFocus: _lastNameFocus,
                                          inputType: TextInputType.name,
                                          capitalization:
                                              TextCapitalization.words,
                                        ),
                                        SizedBox(
                                            height:
                                                Dimensions.PADDING_SIZE_LARGE),

                                        // for last name section
                                        Text(
                                          getTranslated('last_name', context),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline2
                                              .copyWith(
                                                color:
                                                    ColorResources.getHintColor(
                                                        context),
                                              ),
                                        ),
                                        SizedBox(
                                            height:
                                                Dimensions.PADDING_SIZE_SMALL),
                                        CustomTextField(
                                          hintText: 'Doe',
                                          isShowBorder: true,
                                          controller: _lastNameController,
                                          focusNode: _lastNameFocus,
                                          nextFocus: _phoneNumberFocus,
                                          inputType: TextInputType.name,
                                          capitalization:
                                              TextCapitalization.words,
                                        ),
                                        SizedBox(
                                            height:
                                                Dimensions.PADDING_SIZE_LARGE),

                                        // for email section
                                        Text(
                                          getTranslated('email', context),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline2
                                              .copyWith(
                                                color:
                                                    ColorResources.getHintColor(
                                                        context),
                                              ),
                                        ),
                                        SizedBox(
                                            height:
                                                Dimensions.PADDING_SIZE_SMALL),
                                        CustomTextField(
                                          hintText: getTranslated(
                                              'demo_gmail', context),
                                          isShowBorder: true,
                                          controller: _emailController,
                                          isEnabled: false,
                                          focusNode: _emailFocus,
                                          nextFocus: _phoneNumberFocus,
                                          inputType: TextInputType.emailAddress,
                                        ),
                                        SizedBox(
                                            height:
                                                Dimensions.PADDING_SIZE_LARGE),

                                        // for phone Number section
                                        Text(
                                          getTranslated(
                                              'mobile_number', context),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline2
                                              .copyWith(
                                                color:
                                                    ColorResources.getHintColor(
                                                        context),
                                              ),
                                        ),
                                        SizedBox(
                                            height:
                                                Dimensions.PADDING_SIZE_SMALL),
                                        CustomTextField(
                                          hintText: getTranslated(
                                              'number_hint', context),
                                          isShowBorder: true,
                                          controller: _phoneNumberController,
                                          focusNode: _phoneNumberFocus,
                                          nextFocus: _passwordFocus,
                                          inputType: TextInputType.phone,
                                        ),
                                        SizedBox(
                                            height:
                                                Dimensions.PADDING_SIZE_LARGE),
                                        Text(
                                          getTranslated('password', context),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline2
                                              .copyWith(
                                                color:
                                                    ColorResources.getHintColor(
                                                        context),
                                              ),
                                        ),
                                        SizedBox(
                                            height:
                                                Dimensions.PADDING_SIZE_SMALL),
                                        CustomTextField(
                                          hintText: getTranslated(
                                              'password_hint', context),
                                          isShowBorder: true,
                                          controller: _passwordController,
                                          focusNode: _passwordFocus,
                                          nextFocus: _confirmPasswordFocus,
                                          isPassword: true,
                                          isShowSuffixIcon: true,
                                        ),
                                        SizedBox(
                                            height:
                                                Dimensions.PADDING_SIZE_LARGE),
                                        Text(
                                          getTranslated(
                                              'confirm_password', context),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline2
                                              .copyWith(
                                                color:
                                                    ColorResources.getHintColor(
                                                        context),
                                              ),
                                        ),
                                        SizedBox(
                                            height:
                                                Dimensions.PADDING_SIZE_SMALL),
                                        CustomTextField(
                                          hintText: getTranslated(
                                              'password_hint', context),
                                          isShowBorder: true,
                                          controller:
                                              _confirmPasswordController,
                                          focusNode: _confirmPasswordFocus,
                                          isPassword: true,
                                          isShowSuffixIcon: true,
                                          inputAction: TextInputAction.done,
                                        ),
                                        SizedBox(
                                            height:
                                                Dimensions.PADDING_SIZE_LARGE),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          !profileProvider.isLoading
                              ? Center(
                                  child: Container(
                                    width: 1170,
                                    padding: EdgeInsets.all(
                                        Dimensions.PADDING_SIZE_SMALL),
                                    child: CustomButton(
                                      btnTxt: getTranslated(
                                          'update_profile', context),
                                      onTap: () async {
                                        String _firstName =
                                            _firstNameController.text.trim();
                                        String _lastName =
                                            _lastNameController.text.trim();
                                        String _phoneNumber =
                                            _phoneNumberController.text.trim();
                                        String _password =
                                            _passwordController.text.trim();
                                        String _confirmPassword =
                                            _confirmPasswordController.text
                                                .trim();
                                        if (profileProvider
                                                    .userInfoModel.fName ==
                                                _firstName &&
                                            profileProvider
                                                    .userInfoModel.lName ==
                                                _lastName &&
                                            profileProvider
                                                    .userInfoModel.phone ==
                                                _phoneNumber &&
                                            profileProvider
                                                    .userInfoModel.email ==
                                                _emailController.text &&
                                            file == null &&
                                            _password.isEmpty &&
                                            _confirmPassword.isEmpty) {
                                          showCustomSnackBar(
                                              getTranslated(
                                                  'change_something_to_update',
                                                  context),
                                              context);
                                        } else if (_firstName.isEmpty) {
                                          showCustomSnackBar(
                                              getTranslated(
                                                  'enter_first_name', context),
                                              context);
                                        } else if (_lastName.isEmpty) {
                                          showCustomSnackBar(
                                              getTranslated(
                                                  'enter_last_name', context),
                                              context);
                                        } else if (_phoneNumber.isEmpty) {
                                          showCustomSnackBar(
                                              getTranslated(
                                                  'enter_phone_number',
                                                  context),
                                              context);
                                        } else if ((_password.isNotEmpty &&
                                                _password.length < 6) ||
                                            (_confirmPassword.isNotEmpty &&
                                                _confirmPassword.length < 6)) {
                                          showCustomSnackBar(
                                              getTranslated(
                                                  'password_should_be',
                                                  context),
                                              context);
                                        } else if (_password !=
                                            _confirmPassword) {
                                          showCustomSnackBar(
                                              getTranslated(
                                                  'password_did_not_match',
                                                  context),
                                              context);
                                        } else {
                                          UserInfoModel updateUserInfoModel =
                                              UserInfoModel();
                                          updateUserInfoModel.fName =
                                              _firstName ?? "";
                                          updateUserInfoModel.lName =
                                              _lastName ?? "";
                                          updateUserInfoModel.phone =
                                              _phoneNumber ?? '';
                                          String _pass = _password ?? '';

                                          ResponseModel _responseModel =
                                              await profileProvider
                                                  .updateUserInfo(
                                            updateUserInfoModel,
                                            _pass,
                                            file,
                                            Provider.of<AuthProvider>(context,
                                                    listen: false)
                                                .getUserToken(),
                                          );

                                          if (_responseModel.isSuccess) {
                                            profileProvider
                                                .getUserInfo(context);
                                            showCustomSnackBar(
                                                getTranslated(
                                                    'updated_successfully',
                                                    context),
                                                context,
                                                isError: false);
                                          } else {
                                            showCustomSnackBar(
                                                _responseModel.message,
                                                context);
                                          }
                                          setState(() {});
                                        }
                                      },
                                    ),
                                  ),
                                )
                              : Center(
                                  child: CircularProgressIndicator(
                                    valueColor:
                                        new AlwaysStoppedAnimation<Color>(
                                            Theme.of(context).primaryColor),
                                  ),
                                ),
                        ],
                      )
                    : Center(
                        child: CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor),
                          //   // for last name section
                          //   Text(
                          //     getTranslated('last_name', context),
                          //     style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
                          //   ),
                          //   SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          //   CustomTextField(
                          //     hintText: 'Doe',
                          //     isShowBorder: true,
                          //     controller: _lastNameController,
                          //     focusNode: _lastNameFocus,
                          //     nextFocus: Provider.of<SplashProvider>(context, listen: false).configModel.emailVerification
                          //         ? _phoneNumberFocus : _emailFocus,
                          //     inputType: TextInputType.name,
                          //     capitalization: TextCapitalization.words,
                          //   ),
                          //   SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                          //   // for email section
                          //   Row(children: [
                          //     Text(
                          //       getTranslated('email', context),
                          //       style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
                          //     ),
                          //     SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          //     Provider.of<SplashProvider>(context, listen: false).configModel.emailVerification ? Text(
                          //       '(${getTranslated('non_changeable', context)})',
                          //       style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: Colors.red),
                          //     ) : SizedBox(),
                          //   ]),
                          //   SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          //   CustomTextField(
                          //     hintText: getTranslated('demo_gmail', context),
                          //     isShowBorder: true,
                          //     controller: _emailController,
                          //     isEnabled: !Provider.of<SplashProvider>(context, listen: false).configModel.emailVerification,
                          //     focusNode: _emailFocus,
                          //     nextFocus: _phoneNumberFocus,

                          //     inputType: TextInputType.emailAddress,
                          //   ),
                          //   SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                          //   // for phone Number section
                          //   Row(children: [
                          //     Text(
                          //       getTranslated('mobile_number', context),
                          //       style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
                          //     ),
                          //     SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          //     !Provider.of<SplashProvider>(context, listen: false).configModel.emailVerification ? Text(
                          //       '(${getTranslated('non_changeable', context)})',
                          //       style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: Colors.red),
                          //     ) : SizedBox(),
                          //   ]),
                          //   SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          //   CustomTextField(
                          //     hintText: getTranslated('number_hint', context),
                          //     isShowBorder: true,
                          //     isEnabled: Provider.of<SplashProvider>(context, listen: false).configModel.emailVerification,
                          //     controller: _phoneNumberController,
                          //     focusNode: _phoneNumberFocus,
                          //     nextFocus: _passwordFocus,
                          //     inputType: TextInputType.phone,
                          //   ),
                          //   SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                          //   Text(
                          //     getTranslated('password', context),
                          //     style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
                          //   ),
                          //   SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          //   CustomTextField(
                          //     hintText: getTranslated('password_hint', context),
                          //     isShowBorder: true,
                          //     controller: _passwordController,
                          //     focusNode: _passwordFocus,
                          //     nextFocus: _confirmPasswordFocus,
                          //     isPassword: true,
                          //     isShowSuffixIcon: true,
                          //   ),
                          //   SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                          //   Text(
                          //     getTranslated('confirm_password', context),
                          //     style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
                          //   ),
                          //   SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          //   CustomTextField(
                          //     hintText: getTranslated('password_hint', context),
                          //     isShowBorder: true,
                          //     controller: _confirmPasswordController,
                          //     focusNode: _confirmPasswordFocus,
                          //     isPassword: true,
                          //     isShowSuffixIcon: true,
                          //     inputAction: TextInputAction.done,
                          //   ),
                          //   SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                          // ],
                        ),
                      );
              },
            )
          : NotLoggedInScreen(),
    );
  }

  Widget getImage(BuildContext context, ProfileProvider profileProvider) {
    if (file != null) {
      if (ResponsiveHelper.isMobilePhone()) {
        return Image.file(File(file.path),
            width: 80, height: 80, fit: BoxFit.fill);
      } else {
        return Image.network(file.path,
            width: 80, height: 80, fit: BoxFit.fill);
      }
    } else if (profileProvider.userInfoModel.image != null) {
      return FadeInImage.assetNetwork(
        placeholder: Images.placeholder,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        image:
            '${Provider.of<SplashProvider>(context, listen: false).baseUrls.customerImageUrl}/${profileProvider.userInfoModel.image}',
      );
    } else {
      return Image.asset(Images.placeholder,
          height: 80, width: 80, fit: BoxFit.cover);
    }
  }
}
