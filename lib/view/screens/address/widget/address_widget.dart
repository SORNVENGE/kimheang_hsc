import 'package:emarket_user/utill/routes.dart';
import 'package:flutter/material.dart';
import 'package:emarket_user/data/model/response/address_model.dart';
import 'package:emarket_user/localization/language_constrants.dart';
import 'package:emarket_user/provider/location_provider.dart';
import 'package:emarket_user/utill/color_resources.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:emarket_user/view/base/custom_snackbar.dart';
import 'package:provider/provider.dart';

class AddressWidget extends StatelessWidget {
  final AddressModel addressModel;
  final int index;
  AddressWidget({@required this.addressModel, @required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
      child: InkWell(
        onTap: () {
          if(addressModel != null) {
            Navigator.pushNamed(context, Routes.getMapRoute(
              addressModel.address, addressModel.addressType, addressModel.latitude, addressModel.longitude, addressModel.contactPersonName,
              addressModel.contactPersonNumber, addressModel.id, addressModel.userId,
            ));
          }
        },
        child: Container(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          height: 70,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL), color: ColorResources.getSearchBg(context)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                    Icon(
                      addressModel.addressType.toLowerCase() == "home"
                          ? Icons.home_outlined
                          : addressModel.addressType.toLowerCase() == "workplace"
                          ? Icons.work_outline
                          : Icons.list_alt_outlined,
                      color: Theme.of(context).textTheme.bodyText1.color.withOpacity(.45),
                      size: 25,
                    ),
                    SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            addressModel.addressType,
                            style: Theme.of(context).textTheme.headline2.copyWith(color: Theme.of(context).textTheme.bodyText1.color.withOpacity(.65)),
                          ),
                          Text(
                            addressModel.address,
                            maxLines: 1, overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.headline2.copyWith(color: Theme.of(context).textTheme.bodyText1.color),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 5),
                  ],
                ),
              ),
              Stack(
                clipBehavior: Clip.none, children: [
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Container(
                      width: 40,
                      height: 40,
                      margin: EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Theme.of(context).accentColor,
                        border: Border.all(width: 1, color: ColorResources.getGreyColor(context)),
                      ),
                      child: Icon(Icons.map),
                    ),
                  ),
                  //SizedBox(width: 9.0),
                  // Image.asset(Images.menu)
                  Positioned(
                    right: -10, top: 0, bottom: 0,
                    child: PopupMenuButton<String>(
                      padding: EdgeInsets.all(0),
                      onSelected: (String result) {
                        if (result == 'delete') {
                          showDialog(context: context, barrierDismissible: false, builder: (context) => Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                            ),
                          ));
                          Provider.of<LocationProvider>(context, listen: false).deleteUserAddressByID(addressModel.id, index, (bool isSuccessful, String message) {
                            Navigator.pop(context);
                            showCustomSnackBar(message, context, isError: !isSuccessful);
                          });
                        } else {
                          Navigator.pushNamed(
                            context,
                            Routes.getAddAddressRoute(
                              'address', 'update', addressModel.address, addressModel.addressType, addressModel.latitude, addressModel.longitude,
                              addressModel.contactPersonName, addressModel.contactPersonNumber, addressModel.id, addressModel.userId,
                            ),
                          );
                        }
                      },
                      itemBuilder: (BuildContext c) => <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'edit',
                          child: Text(getTranslated('edit', context), style: Theme.of(context).textTheme.headline2),
                        ),
                        PopupMenuItem<String>(
                          value: 'delete',
                          child: Text(getTranslated('delete', context), style: Theme.of(context).textTheme.headline2),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
