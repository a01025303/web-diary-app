import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class MyMainPage extends StatefulWidget {
  const MyMainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MyMainPage> {
  String? _dropDownText;
  @override
  Widget build(BuildContext context) {
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
                    } else if (value == 'Earliest') {
                      setState(() {
                        _dropDownText = value;
                      });
                    }
                  },
                ),
              ),
              //TODO: create profile
              Container(
                child: Row(
                  children: [
                    Column(
                      children: [
                        Expanded(
                            child: InkWell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage:
                                  NetworkImage('https://picsum.photos/200/300'),
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                        )),
                        Text(
                          'Jose',
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                    IconButton(
                        onPressed: () {},
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
      body: Row(
        children: [
          Expanded(
              flex: 2,
              child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border(
                        right: BorderSide(width: 0.4, color: Colors.blueGrey))),
                //color: Colors.green,
                child: Column(),
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
}
