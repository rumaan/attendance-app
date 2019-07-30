import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

final _firestore = Firestore.instance;

class StudentList extends StatelessWidget {
  StudentList({this.year, this.section, this.department});
  final String year;
  final String section;
  final String department;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: IconButton(
                icon: Icon(Icons.close, size: 36),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            )
          ],
          backgroundColor: Color(0x0E004D99),
          brightness: Brightness.dark,
          elevation: 0,
          leading: IconButton(
              icon: Icon(Icons.exit_to_app),
              iconSize: 36,
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/lecturerLogin', (Route<dynamic> route) => false);
              }),
        ),
        backgroundColor: Color(0xDF004D99),
        body: StreamBuilder<QuerySnapshot>(
          stream:
              _firestore.collection('$department-$year-$section').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.lightBlueAccent,
                ),
              );
            }
            final messages = snapshot.data.documents.reversed;

            List<Padding> cardWidgets = [];

            List<String> usnList = [];
            for (var message in messages) {
              if (!usnList.contains(message.documentID.substring(0, 10))) {
                usnList.add(message.documentID.substring(0, 10));
                final title = message.data['title'];
                final url = message.data['url'];

                final card =
                    letterCard(context: context, id: message.documentID);
                cardWidgets.add(card);
              }
            }
            return Container(
              height: MediaQuery.of(context).size.height - 110,
              child: ListView(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                children: cardWidgets,
              ),
            );
          },
        ),
      ),
    );
  }

  Padding letterCard({BuildContext context, String id}) {
    Text text = Text(
      id.substring(0, 10),
      style: TextStyle(
          color: Colors.black, fontWeight: FontWeight.w600, fontSize: 20),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
        child: Container(
          height: 80,
          width: MediaQuery.of(context).size.width * 0.9,
          child: Card(
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  text,
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LetterList(
                            year: year,
                            department: department,
                            section: section,
                            usn: text.data,
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LetterList extends StatelessWidget {
  LetterList({this.year, this.section, this.department, this.usn});
  final String year;
  final String section;
  final String department;
  final String usn;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: IconButton(
                icon: Icon(Icons.close, size: 36),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            )
          ],
          backgroundColor: Color(0x0E004D99),
          brightness: Brightness.dark,
          elevation: 0,
          leading: IconButton(
              icon: Icon(Icons.exit_to_app),
              iconSize: 36,
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/lecturerLogin', (Route<dynamic> route) => false);
              }),
        ),
        backgroundColor: Color(0xDF004D99),
        body: StreamBuilder<QuerySnapshot>(
          stream:
              _firestore.collection('$department-$year-$section').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.lightBlueAccent,
                ),
              );
            }
            final messages = snapshot.data.documents.reversed;

            List<Padding> cardWidgets = [];
            for (var message in messages) {
              if (message.documentID.substring(0, 10) == usn) {
                final title = message.data['title'];
                final url = message.data['url'];

                final card = letterCard(
                    context: context,
                    title: title,
                    url: url,
                    instance: _firestore,
                    id: message.documentID);
                cardWidgets.add(card);
              }
            }
            return Container(
              height: MediaQuery.of(context).size.height - 110,
              child: ListView(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                children: cardWidgets,
              ),
            );
          },
        ),
      ),
    );
  }

  Padding letterCard(
      {BuildContext context,
      String url,
      String title,
      String id,
      Firestore instance}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
        child: Container(
          height: 160,
          width: MediaQuery.of(context).size.width * 0.9,
          child: Card(
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text(
                    id.substring(0, 10),
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  ),
                  GestureDetector(
                    child: Text(
                      'View',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xDF004D99),
                      ),
                    ),
                    onTap: () {
                      _launchURL('http://docs.google.com/viewer?url=$url');
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}