import 'package:flutter/material.dart';

import 'Pages/controller/game_form_controller.dart';
import 'Pages/controller/anime_form_controller.dart';
import 'Pages/Model/game_entry.dart';
import 'Pages/Model/anime_entry.dart';


class GameListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Game List',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          backgroundColor: Colors.blueGrey,
          appBar: AppBar(
            title: Text('Games'),
          ),
          body: GameListPage(title: 'Games List'),
        ));
  }
}

class GameListPage extends StatefulWidget {
  GameListPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _GameListPageState createState() => _GameListPageState();
}

class _GameListPageState extends State<GameListPage> {
  List<GameEntryForm> gameItems = List<GameEntryForm>();

  // Method to Submit Feedback and save it in Google Sheets

  @override
  void initState() {
    super.initState();

    GameFormController().getFeedbackList().then((feedbackItems) {
      setState(() {
        this.gameItems = feedbackItems;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text('Game List'),
      ),
      body: ListView.builder(
        itemCount: gameItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                      "${gameItems[index].name} (${gameItems[index].platform})"),
                )
              ],
            ),
            subtitle: Row(
              children: <Widget>[
                Text(gameItems[index].rating+"\t"),
                Expanded(
                  child: Text(gameItems[index].review),
                )
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
          Navigator.push(context, MaterialPageRoute(builder: (context) => MyGamePage()),);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

class MyGamePage extends StatefulWidget {
  MyGamePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyGamePageState createState() => _MyGamePageState();
}

class _MyGamePageState extends State<MyGamePage> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // TextField Controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController platformController = TextEditingController();
  TextEditingController ratingController = TextEditingController();
  TextEditingController reviewController = TextEditingController();

  // Method to Submit Feedback and save it in Google Sheets
  void _submitForm() {
    // Validate returns true if the form is valid, or false
    // otherwise.
    if (_formKey.currentState.validate()) {
      // If the form is valid, proceed.
      GameEntryForm gameForm = GameEntryForm(
          nameController.text,
          platformController.text,
          ratingController.text,
          reviewController.text
      );

      GameFormController formController = GameFormController();

      _showSnackbar("Submitting Feedback");

      // Submit 'feedbackForm' and save it in Google Sheets.
      formController.submitForm(gameForm, (String response) {
        print("Response: $response");
        if (response == AnimeFormController.STATUS_SUCCESS) {
          // Feedback is saved succesfully in Google Sheets.
          _showSnackbar("Feedback Submitted");
        } else {
          // Error Occurred while saving data in Google Sheets.
          _showSnackbar("Error Occurred!");
        }
      });
    }
  }

  // Method to show snackbar with 'message'.
  _showSnackbar(String message) {
    final snackBar = SnackBar(content: Text(message));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(widget.title ?? ""),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        controller: nameController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter Valid Name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(labelText: 'Name'),
                      ),
                      TextFormField(
                        controller: platformController,
//                        validator: (value) {
//                          if (!value.contains("@")) {
//                            return 'Enter Valid Email';
//                          }
//                          return null;
//                        },
                        decoration: InputDecoration(labelText: 'Platform'),
                      ),
                      TextFormField(
                        controller: ratingController,
//                        validator: (value) {
//                          if (value.trim().length != 10) {
//                            return 'Enter 10 Digit Mobile Number';
//                          }
//                          return null;
//                        },
                        decoration: InputDecoration(
                          labelText: 'Rating',
                        ),
                      ),
                      TextFormField(
                        controller: reviewController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter Review or N/A';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(labelText: 'Review'),
                      ),
                    ],
                  ),
                )),
            RaisedButton(
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: _submitForm,
              child: Text('Submit Game'),
            ),
            RaisedButton(
              color: Colors.lightBlueAccent,
              textColor: Colors.black,
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('View Game List'),
            ),
          ],
        ),
      ),
    );
  }
}