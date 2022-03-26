import 'package:emarket_user/provider/cart_provider.dart';
import 'package:emarket_user/view/component/dialog/add_cart_project_diaog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomEventDialog extends StatefulWidget {

  CustomEventDialog({Key key}) : super(key: key);

  @override
  CustomEventDialogState createState() => new CustomEventDialogState();
}

class CustomEventDialogState extends State<CustomEventDialog> {
  // Get Project name list from share preference
  // String selectedRingtone = "None";
  // List<String> ringtone = [
  //   "My project", "Callisto", "Ganymede", "Luna", "A", "C", "D", "H"
  // ];

  String selectedProjectName = "My project";
  @override
  Widget build(BuildContext context) {
    // get all cart project and save to local storage
    // SharedPreferences
    Provider.of<CartProvider>(context, listen: false).getProjectNames(context);
    return Consumer<CartProvider>(builder: (context, cardProvider, child) {
      // selectedProjectName = cardProvider.projectNames[0];
      return Dialog(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[
                Material(
                  color: Theme
                      .of(context)
                      .primaryColor,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        //apply padding to all four sides
                        child: Text("Choose the project", style: TextStyle(
                            color: Colors.white, fontSize: 20)),
                      ),
                      Spacer(),
                      IconButton(
                        icon: const Icon(Icons.add, color: Colors.white,),
                        onPressed: () {
                          showDialog(context: context, builder: (_) => AddNewProjectDialog(projectNames: cardProvider.projectNames)).then((projectName) => {
                            // add project name to existing local storage
                            if (projectName != null) {
                              Provider.of<CartProvider>(context, listen: false).addProjectName(projectName),
                              // refresh the component to load new item?
                              setState(() {
                                Provider.of<CartProvider>(context, listen: false).getProjectNames(context);
                              })
                              // WidgetsBinding.instance.addPostFrameCallback((_){
                              //
                              // })
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
                for(var r in cardProvider.projectNames) RadioListTile(
                  title: Text(r),
                  activeColor: Colors.orange,
                  groupValue: selectedProjectName,
                  selected: r == selectedProjectName,
                  value: r,
                  onChanged: (dynamic val) {
                    setState(() {
                      selectedProjectName = val;
                    });
                  },
                ),
                Row(
                  children: <Widget>[
                    InkWell(
                      splashColor: Colors.orange,
                      child: Container(
                        padding: EdgeInsets.all(15),
                        alignment: Alignment.center,
                        child: Text("CANCEL", style: TextStyle(
                            color: Colors.black, fontSize: 15)),
                      ),
                      onTap: () {
                        Navigator.of(context).pop(null);
                      },
                    ),
                    Spacer(),
                    InkWell(
                      splashColor: Colors.orange,
                      child: Container(
                        padding: EdgeInsets.all(15),
                        alignment: Alignment.center,
                        child: Text("ADD", style: TextStyle(
                            color: Colors.black, fontSize: 15)),
                      ),
                      onTap: () {
                        Navigator.of(context).pop(selectedProjectName);
                      },
                    )
                    ,
                  ],
                ),
              ],
            ),
          )
      );
    });
  }


}
