import 'package:emarket_user/view/base/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:emarket_user/helper/html_type.dart';
import 'package:emarket_user/helper/responsive_helper.dart';
import 'package:emarket_user/localization/language_constrants.dart';
import 'package:emarket_user/provider/splash_provider.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:emarket_user/utill/styles.dart';
import 'package:emarket_user/view/base/main_app_bar.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart' as html;
import 'package:universal_ui/universal_ui.dart';
import 'package:url_launcher/url_launcher.dart';

class HtmlViewerScreen extends StatelessWidget {
  final HtmlType htmlType;
  HtmlViewerScreen({@required this.htmlType});
  
  @override
  Widget build(BuildContext context) {
    String _data = htmlType == HtmlType.TERMS_AND_CONDITION ? Provider.of<SplashProvider>(context, listen: false).configModel.termsAndConditions
        : htmlType == HtmlType.ABOUT_US ? Provider.of<SplashProvider>(context, listen: false).configModel.aboutUs
        : htmlType == HtmlType.PRIVACY_POLICY ? Provider.of<SplashProvider>(context, listen: false).configModel.privacyPolicy : null;

    if(_data != null && _data.isNotEmpty) {
      _data = _data.replaceAll('href=', 'target="_blank" href=');
    }

    String _viewID = htmlType.toString();
    if(ResponsiveHelper.isWeb()) {
      try{
        ui.platformViewRegistry.registerViewFactory(_viewID, (int viewId) {
          html.IFrameElement _ife = html.IFrameElement();
          _ife.width = '1170';
          _ife.height = MediaQuery.of(context).size.height.toString();
          _ife.srcdoc = _data;
          _ife.contentEditable = 'false';
          _ife.style.border = 'none';
          _ife.allowFullscreen = true;
          return _ife;
        });
      }catch(e) {}
    }
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? MainAppBar() :  CustomAppBar(title: getTranslated(htmlType == HtmlType.TERMS_AND_CONDITION ? 'terms_and_condition'
          : htmlType == HtmlType.ABOUT_US ? 'about_us' : htmlType == HtmlType.PRIVACY_POLICY ? 'privacy_policy' : 'no_data_found', context)),
      body: Center(
        child: Container(
          width: 1170,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: ResponsiveHelper.isWeb() ? Column(
            children: [
              ResponsiveHelper.isDesktop(context) ? Container(
                height: 100, alignment: Alignment.center,
                child: SelectableText(getTranslated(htmlType == HtmlType.TERMS_AND_CONDITION ? 'terms_and_condition'
                    : htmlType == HtmlType.ABOUT_US ? 'about_us' : htmlType == HtmlType.PRIVACY_POLICY ? 'privacy_policy' : 'no_data_found', context),
                  style: rubikBold.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE),
                ),
              ) : SizedBox(),
              SizedBox(height: 30),
              Expanded(child: IgnorePointer(child: HtmlElementView(viewType: _viewID, key: Key(htmlType.toString())))),
            ],
          ) : SingleChildScrollView(
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            physics: BouncingScrollPhysics(),
            child: HtmlWidget(
              _data,
              key: Key(htmlType.toString()),
              onTapUrl: (String url) {
                launch(url);
              },
              hyperlinkColor: Colors.blue,
            ),
          ),
        ),
      ),
    );
  }
}
