// Imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:webdiary/models/user.dart';
import 'package:webdiary/screens/login_page.dart';

// Stateful widget --> main page
class MyMainPage extends StatefulWidget {
  const MyMainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

// Main page state
class _MainPageState extends State<MyMainPage> {
  // Declare dropDownText
  String? _dropDownText;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedUser = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("usuarios")
        .doc(user!.uid())
        .get()
        .then((value) {
      this.loggedUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // Use scaffold to define structure
    return Scaffold(
      // Create app bar
      appBar: AppBar(
        // Background color for the bar
        backgroundColor: Colors.grey.shade100,
        // Set height of toolbar
        toolbarHeight: 100,
        // Set elevation of the toolbar
        elevation: 4,
        // Set row
        title: Row(
          children: [
            // Text for bar
            Text(
              // Determine text and its attributes
              'Diary',
              style: TextStyle(fontSize: 39, color: Colors.blueGrey.shade400),
            ),
            Text(
              // Determine text and its attributes
              'Book',
              style: TextStyle(fontSize: 39, color: Colors.purple),
            )
          ],
        ),
        // Actions within bar
        actions: [
          Row(
            // Define dropdown bar
            children: [
              Padding(
                // Determine padding
                padding: const EdgeInsets.all(8.0),
                // Determine child --> map list values for dropdown menu
                child: DropdownButton<String>(
                  items: <String>['Latest', 'Earliest'].map((String value) {
                    return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(color: Colors.grey),
                        ));
                  }).toList(),
                  // Determine what to display
                  hint: (_dropDownText == null)
                      ? Text('Select')
                      : Text(_dropDownText!),
                  // Set states for dropDownText depending on value
                  onChanged: (value) {
                    if (value == 'Latest') {
                      setState(() {
                        _dropDownText = value;
                      });
                    } else if (value == 'Earliest') {
                      setState(() {
                        _dropDownText = value;
                      });
                    }
                  },
                ),
              ),
              //TODO: create profile
              // Container for profile
              Container(
                child: Row(
                  children: [
                    Column(
                      children: [
                        Expanded(
                            child: InkWell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            // Show image in circle - stablish characteristics
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage:
                                  NetworkImage('https://picsum.photos/200/300'),
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                        )),
                        // Text for profile
                        Text(
                          "${loggedUser.firstName}",
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                    // Button to log out
                    IconButton(
                        onPressed: () {
                          logout(context);
                        },
                        icon: Icon(
                          Icons.logout_outlined,
                          size: 19,
                          color: Colors.red,
                        ))
                  ],
                ),
              )
            ],
          )
        ],
      ),
      // Define body structure
      body: Row(
        children: [
          Expanded(
              // Left box --> will contain calendar
              flex: 2,
              child: Container(
                // Container style
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border(
                        right: BorderSide(width: 0.4, color: Colors.blueGrey))),
                // Column
                child: Column(
                  children: [
                    // Insert calendar using Date Picker
                    Padding(
                      padding: const EdgeInsets.all(38.0),
                      child: SfDateRangePicker(
                          //onSelectionChanged:
                          //(dateRangePickerSelectionChangedArgs) {
                          // print(dateRangePickerSelectionChangedArgs.value)
                          //.toString();
                          // },
                          ),
                    )
                  ],
                ),
              )),
          Expanded(
              flex: 3,
              child: Container(
                color: Colors.white,
                child: Column(),
              ))
        ],
      ),
    );
  }

  void logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MyLoginPage()));
  }
}
