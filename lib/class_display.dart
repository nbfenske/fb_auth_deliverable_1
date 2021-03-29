import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';

// Author: Nathan Fenske
// This is the class to represent the screen opened after clicking on an event/class
class ClassScreen extends StatefulWidget {
  ClassScreen({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _ClassScreen createState() => _ClassScreen();
}

// Author: Kelvin Chen
// Still the representation of the class on-tap screen, just defines the state/structure
class _ClassScreen extends State<ClassScreen> {
  var _nameProf;
  var _nameTA ;
  var _officeHours;
  // Author: Konstantinos Chrysolous
  // Did the zoom entry
  var _zoomLink;


  final nameConProf = new TextEditingController();
  final nameCon = new TextEditingController();
  final officeCon = new TextEditingController();
  // Author: Konstantinos Chrysolous
  // Did the zoom entry
  final zoomCon = new TextEditingController();


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title), // Title set to the given class/event
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: nameConProf,
                decoration: InputDecoration(
                    hintText: 'Enter Professor Name'
                ),
              ),
              TextField(
                controller: nameCon,
                decoration: InputDecoration(
                    hintText: 'Enter TA Name'
                ),
              ),
              TextField(
                controller: officeCon,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: 'Enter Office Hours'
                ),
              ),
              // Author: Konstantinos Chrysolous
              // Did the zoom entry
              TextField(// Entry field where user enters the selected class' Zoom Link
                controller: zoomCon,
                decoration: InputDecoration(
                    hintText: 'Enter class Zoom Link'
                ),
              ),
              RaisedButton(onPressed: (){

                setState(() {
                  if (nameCon.text != "") {
                    _nameTA = nameCon.text;
                  }
                  if (nameConProf.text != "") {
                    _nameProf = nameConProf.text;
                  }
                  if (officeCon.text != "") {
                    _officeHours = officeCon.text;
                  }
                  // Author: Konstantinos Chrysolous
                  // Did the zoom entry
                  if (zoomCon.text != "") {
                    _zoomLink = zoomCon.text;
                    print(_zoomLink);
                  } else {
                    print("Empty");
                  }
                });
              },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
