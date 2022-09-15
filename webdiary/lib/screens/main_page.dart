// Imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:webdiary/get_started_page.dart';
import 'package:webdiary/models/user.dart';
import 'package:webdiary/screens/login_page.dart';

import '../models/diary.dart';
import '../services/service.dart';
import '../widgets/diary_list_view.dart';
import '../widgets/inner_list_card.dart';
import '../widgets/write_diary_dialog.dart';

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
  DateTime selectedDate = DateTime.now();
  var userDiaryFilteredEntriesList;

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
    TextEditingController _titleTextController = TextEditingController();
    TextEditingController _descriptionTextController = TextEditingController();
    var _listOfDiaries = Provider.of<List<Diary>>(context);
    var _user = Provider.of<User?>(context);
    var latestFilteredDiariesStream;
    var earliestFilteredDiariesStream;
    CollectionReference bookCollectionReference =
        FirebaseFirestore.instance.collection('diaries');
    // Use scaffold to define structure
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        toolbarHeight: 100,
        elevation: 4,
        title: Row(
          children: [
            Text(
              'Diary',
              style: TextStyle(fontSize: 39, color: Colors.blueGrey.shade400),
            ),
            Text(
              'Book',
              style: TextStyle(fontSize: 39, color: Colors.purple),
            )
          ],
        ),
        actions: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton<String>(
                  items: <String>['Latest', 'Earliest'].map((String value) {
                    return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(color: Colors.grey),
                        ));
                  }).toList(),
                  hint: (_dropDownText == null)
                      ? Text('Select')
                      : Text(_dropDownText!),
                  onChanged: (value) {
                    if (value == 'Latest') {
                      setState(() {
                        _dropDownText = value;
                      });
                      _listOfDiaries.clear();
                      latestFilteredDiariesStream =
                          DiaryService().getLatestDiaries(_user!.uid());
                      latestFilteredDiariesStream.then((value) {
                        for (var item in value) {
                          setState(() {
                            _listOfDiaries.add(item);
                          });
                        }
                      });
                    } else if (value == 'Earliest') {
                      setState(() {
                        _dropDownText = value;
                      });
                      _listOfDiaries.clear();
                      earliestFilteredDiariesStream =
                          DiaryService().getEarliestDiaries(_user!.uid());

                      earliestFilteredDiariesStream.then((value) {
                        for (var item in value) {
                          setState(() {
                            _listOfDiaries.add(item);
                          });
                        }
                      });
                    }
                  },
                ),
              ),
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
                    FirebaseAuth.instance.signOut().then((value) {
                      return Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyLoginPage(),
                          ));
                    });
                  },
                  icon: Icon(
                    Icons.logout_outlined,
                    size: 19,
                    color: Colors.red,
                  )),
            ],
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
              flex: 4,
              child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border(
                        right: BorderSide(width: 0.4, color: Colors.blueGrey))),
                // color: Colors.green,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(38.0),
                      child: SfDateRangePicker(
                        onSelectionChanged: (dateRangePickerSelection) {
                          setState(() {
                            selectedDate = dateRangePickerSelection.value;
                            _listOfDiaries.clear();
                            userDiaryFilteredEntriesList = DiaryService()
                                .getSameDateDiaries(
                                    Timestamp.fromDate(selectedDate).toDate(),
                                    FirebaseAuth.instance.currentUser!.uid());

                            userDiaryFilteredEntriesList.then((value) {
                              for (var item in value) {
                                setState(() {
                                  _listOfDiaries.add(item);
                                });
                              }
                            });
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(48.0),
                      child: Card(
                        elevation: 4,
                        child: TextButton.icon(
                          icon: Icon(
                            Icons.add,
                            size: 40,
                            color: Colors.purple,
                          ),
                          label: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Escribir entrada',
                                style: TextStyle(fontSize: 17),
                              ),
                            ),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return WriteDiaryDialog(
                                    selectedDate: selectedDate,
                                    titleTextController: _titleTextController,
                                    descriptionTextController:
                                        _descriptionTextController);
                              },
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              )),
          Expanded(
              flex: 10,
              child: DiaryListView(
                  listOfDiaries: _listOfDiaries, selectedDate: selectedDate)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return WriteDiaryDialog(
                    selectedDate: selectedDate,
                    titleTextController: _titleTextController,
                    descriptionTextController: _descriptionTextController);
              },
            );
          },
          tooltip: 'Add',
          child: Icon(
            Icons.add,
          )),
    );
  }

  void logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => GettingStartedPage()));
  }
}
