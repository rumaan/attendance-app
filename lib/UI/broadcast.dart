import 'package:flutter/material.dart';

class Broadcast extends StatefulWidget {
  @override
  _BroadcastState createState() => _BroadcastState();
}

class _BroadcastState extends State<Broadcast> {
  final GlobalKey _snackbarKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final messageController = TextEditingController();

  String selectedYear;
  String selectedSection;
  String selectedDept;
  String _title;
  String _message;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0x0E004D99),
          brightness: Brightness.dark,
          elevation: 0,
          leading: Hero(
            tag: 'signOutTag',
            child: Material(
              color: Colors.transparent,
              child: IconButton(
                  icon: Icon(Icons.exit_to_app),
                  iconSize: 36,
                  color: Colors.white,
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/lecturerLogin', (Route<dynamic> route) => false);
                  }),
            ),
          ),
        ),
        backgroundColor: Color(0xDF004D99),
        body: ListView(
          key: _snackbarKey,
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Card(
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 35),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Hero(
                                tag: 'broadcastText',
                                child: Text(
                                  'Broadcast  ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 24,
                                    fontFamily: "Roboto",
                                    color: Colors.black,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ),
                              Hero(
                                tag: 'broadcastIcon',
                                child: Material(
                                  color: Colors.transparent,
                                  child: IconButton(
                                      icon: Icon(
                                        Icons.clear,
                                        size: 30,
                                        color: Colors.black,
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      }),
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Text(
                              'You can broadcast a message or notification to a particular class.',
                              style: TextStyle(color: Colors.black38),
                            ),
                          ),
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Title'),
                            controller: titleController,
                            maxLength: 25,
                          ),
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Message'),
                            controller: messageController,
                            maxLength: 90,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: <Widget>[
                              Flexible(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  hint: Text(
                                    'Year',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  value: selectedYear,
                                  icon: Icon(Icons.keyboard_arrow_down),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      selectedYear = newValue;
                                    });
                                  },
                                  items: ['1', '2', '3', '4']
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Flexible(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  hint: Text(
                                    'Section',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  value: selectedSection,
                                  icon: Icon(Icons.keyboard_arrow_down),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      selectedSection = newValue;
                                    });
                                  },
                                  items: ['A', 'B', 'C']
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          DropdownButton<String>(
                            isExpanded: true,
                            hint: Text(
                              'Dept.',
                              style: TextStyle(fontSize: 18),
                            ),
                            value: selectedDept,
                            icon: Icon(Icons.keyboard_arrow_down),
                            onChanged: (String newValue) {
                              setState(() {
                                selectedDept = newValue;
                              });
                            },
                            items: ['CSE', 'CIV', 'ECE', 'ISE', 'MECH']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Hero(
                    tag: 'broadcastButton',
                    child: RaisedButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.volume_up,
                              color: Colors.white,
                              size: 30,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Send Broadcast',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ],
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        color: Colors.lightBlueAccent,
                        onPressed: () {
                          if (selectedDept != null &&
                              selectedYear != null &&
                              selectedSection != null &&
                              messageController.text.isNotEmpty &&
                              titleController.text.isNotEmpty) {
                            print('Ta-da!');
                          } else
                            Scaffold.of(_snackbarKey.currentContext)
                                .showSnackBar(
                              SnackBar(
                                content: Text('Please enter all details.'),
                              ),
                            );
                        }),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
