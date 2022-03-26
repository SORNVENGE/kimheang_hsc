import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddNewProjectDialog extends StatefulWidget {
  List<String> projectNames;
  AddNewProjectDialog({Key key, @required this.projectNames}) : super(key: key);

  // AddNewProjectDialog({@required this.projectNames});

  @override
  AddNewProjectDialogState createState() => new AddNewProjectDialogState(projectNames: this.projectNames);
}

class AddNewProjectDialogState extends State<AddNewProjectDialog>{
  List<String> projectNames;

  AddNewProjectDialogState({@required this.projectNames});

  TextEditingController _controller = TextEditingController();
  bool _validate = false;
  String errorMessage = "";
  @override
  Widget build(BuildContext context){
    return Dialog(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              Material(
                color: Theme.of(context).primaryColor,
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(10,10,0,10), //apply padding to all four sides
                      child: Text("Add new project", style: TextStyle(color: Colors.white, fontSize: 20)),
                    ),
                    Spacer(),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10,0,10,0), //apply padding to all four sides
                child: TextField(
                  controller: _controller,
                  style: TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                      hintText: "project name",
                      hintStyle: TextStyle(color: Colors.grey),
                      errorText: _validate ? errorMessage : null,
                      errorStyle: TextStyle(
                        color: Colors.red[400],
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  InkWell(
                    splashColor: Colors.orange,
                    child: Container(
                      padding: EdgeInsets.all(15),
                      alignment: Alignment.center,
                      child: Text("CANCEL", style: TextStyle(color: Colors.black, fontSize: 15)),
                    ),
                    onTap: (){
                      Navigator.of(context).pop(null);
                    },
                  ),
                  Spacer(),
                  InkWell(
                    splashColor: Colors.orange,
                    child: Container(
                      padding: EdgeInsets.all(15),
                      alignment: Alignment.center,
                      child: Text("SAVE", style: TextStyle(color: Colors.black, fontSize: 15)),
                    ),
                    onTap: (){
                      //get text from input
                      String projectName = _controller.text;
                      if (projectName.isNotEmpty) {
                        if (!projectNames.contains(projectName)) {
                          Navigator.of(context).pop(projectName);
                        } else {
                          errorMessage = "name existed";
                          setState(() {
                            _validate = true;
                          });
                        }
                      } else {
                        errorMessage = "cannot null";
                        setState(() {
                          _validate = true;
                        });
                      }

                    },
                  )
                  ,
                ],
              ),
            ],
          ),
        )
    );
  }
}
