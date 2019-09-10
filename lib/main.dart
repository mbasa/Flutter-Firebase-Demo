import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Firebase Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  TabController _tabController;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final _databaseReference = FirebaseDatabase.instance.reference();

  String _token = "";
  String _title = "";
  String _message = "";

  String _userId = "";
  String _chatMsg = "";

  TextEditingController _userIdCont;
  TextEditingController _chatMsgCont;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _userIdCont = TextEditingController(text: _userId);
    _chatMsgCont = TextEditingController(text: _chatMsg);

    getMessage();
    _firebaseMessaging.subscribeToTopic("all");
    _firebaseMessaging.getToken().then(
          (String token) => setState(
            () {
              _token = token;
              debugPrint("Token: $_token");
            },
          ),
        );
  }

  void showMsgAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_title),
          content: Text(_message),
          actions: <Widget>[
            RaisedButton(
              child: Text(
                "Close",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  void getMessage() {
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
      print('on message $message');
      setState(() {
        _title = message["notification"]["title"];
        _message = message["notification"]["body"];

        showMsgAlert();
      });
    }, onResume: (Map<String, dynamic> message) async {
      ///
      /// Only data portion of the message will be passed
      /// after am OS-level notification
      ///
      print('on resume $message');
      setState(() {
        _title = message["notification"]["title"];
        _message = message["notification"]["body"];

        if (_message == null) _message = message["data"]["status"];
      });
    }, onLaunch: (Map<String, dynamic> message) async {
      ///
      /// Only data portion of the message will be passed
      /// after am OS-level notification
      ///
      print('on launch $message');
      setState(() {
        _title = message["notification"]["title"];
        _message = message["notification"]["body"];

        if (_message == null) _message = message["data"]["collapse_key"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget waiting = Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          SizedBox(
            height: 10.0,
          ),
          Text(
            "Connecting to Firebase",
            style: TextStyle(
              fontSize: 10.0,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );

    return _token.isEmpty
        ? waiting
        : Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
              centerTitle: true,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  TabBar(
                    controller: _tabController,
                    labelColor: Colors.blueAccent,
                    tabs: <Widget>[
                      Tab(
                        child: Text("Device Token"),
                      ),
                      Tab(
                        child: Text("Notification"),
                      ),
                      Tab(
                        child: Text("Chat"),
                      ),
                    ],
                  ),
                  Expanded(
                    flex: 2,
                    child: TabBarView(
                      controller: _tabController,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(18.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              ///
                              /// First Tab
                              ///
                              Text(
                                "Below is the Firebase Device Token. "
                                "This Token can be used to send Notifications "
                                "only for this device.",
                                style: TextStyle(fontSize: 18.0),
                              ),
                              SizedBox(
                                height: 18.0,
                              ),
                              Text(
                                "This application has been subscribed to the "
                                "Topic: all. Sending a message to \"/topics/all\" "
                                "will broadcast a Notification to all devices "
                                "that have this demo application. ",
                                style: TextStyle(fontSize: 18.0),
                              ),
                              SizedBox(
                                height: 18.0,
                              ),
                              Text(
                                "Device Token: ",
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 18.0,
                              ),
                              Card(
                                elevation: 12.0,
                                color: Colors.blueGrey,
                                child: Text(
                                  _token,
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ),

                        ///
                        /// Second Tab
                        ///
                        Container(
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Notifications from the Server",
                                style: TextStyle(fontSize: 22.0),
                              ),
                              Text(
                                "( This can be displayed also as an "
                                "Alert Dialog Message )",
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              ListTile(
                                title: Text(
                                  "Title",
                                  style: TextStyle(color: Colors.blueAccent),
                                ),
                                subtitle: Text(_title == null ? "" : _title),
                                leading: Icon(
                                  Icons.message,
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  "Message",
                                  style: TextStyle(color: Colors.blueAccent),
                                ),
                                subtitle:
                                    Text(_message == null ? "" : _message),
                                leading: Icon(Icons.message),
                              ),
                            ],
                          ),
                        ),

                        ///
                        /// Third Tab
                        ///
                        SingleChildScrollView(
                          padding: EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              TextField(
                                decoration: InputDecoration(
                                  hintText: "User-ID",
                                ),
                                onChanged: (val) => _userId = val,
                                expands: false,
                                controller: _userIdCont,
                              ),
                              TextField(
                                decoration:
                                    InputDecoration(hintText: "Message"),
                                onChanged: (val) => _chatMsg = val,
                                expands: false,
                                controller: _chatMsgCont,
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              RaisedButton(
                                onPressed: () {
                                  if (_userId.isNotEmpty &&
                                      _chatMsg.isNotEmpty) {
                                    _databaseReference.push().set({
                                      'user-id': _userId,
                                      'chat': _chatMsg,
                                      'c_date': DateTime.now().toIso8601String()
                                    });
                                    _chatMsg = "";
                                    _userId = "";
                                    _chatMsgCont.clear();
                                    _userIdCont.clear();
                                  }
                                },
                                child: Text("Send to Firebase"),
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              SizedBox(
                                width: 400,
                                height: 250,
                                child: FirebaseAnimatedList(
                                  padding: EdgeInsets.all(8.0),
                                  query:
                                      _databaseReference.orderByChild("c_date"),
                                  reverse: false,
                                  itemBuilder: (BuildContext context,
                                      DataSnapshot snapshot,
                                      Animation<double> animation,
                                      int index) {
                                    return SizeTransition(
                                      axis: Axis.horizontal,
                                      sizeFactor: animation,
                                      child: Text(
                                        snapshot.value.toString(),
                                        style: TextStyle(
                                            color: index % 2 == 0
                                                ? Colors.redAccent
                                                : Colors.blueAccent),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }
}
