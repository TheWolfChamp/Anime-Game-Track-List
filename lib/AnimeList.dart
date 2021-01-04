import 'package:flutter/material.dart';

import 'Pages/controller/anime_form_controller.dart';
import 'Pages/Model/game_entry.dart';
import 'Pages/Model/anime_entry.dart';


class AnimeListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Anime List',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          backgroundColor: Colors.blueGrey,
          appBar: AppBar(
            title: Text('Animes'),
          ),
          body: AnimeListPage(title: 'Anime List'),
        ));
  }
}

class AnimeListPage extends StatefulWidget {
  AnimeListPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AnimeListPageState createState() => _AnimeListPageState();
}

class _AnimeListPageState extends State<AnimeListPage> {
  List<AnimeEntryForm> animeItems = List<AnimeEntryForm>();

  // Method to Submit Feedback and save it in Google Sheets

  @override
  void initState() {
    super.initState();

    AnimeFormController().getFeedbackList().then((animeItems) {
      setState(() {
        this.animeItems = animeItems;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text('Anime List'),
      ),
      body: ListView.builder(
        itemCount: animeItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                      "${animeItems[index].name} (${animeItems[index].genre})"),
                )
              ],
            ),
            subtitle: Row(
              children: <Widget>[
                Text(animeItems[index].rating+"\t"),
                Expanded(
                  child: Text(animeItems[index].review),
                )
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
          Navigator.push(context, MaterialPageRoute(builder: (context) => MyAnimePage()),);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

class MyAnimePage extends StatefulWidget {
  MyAnimePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyAnimePageState createState() => _MyAnimePageState();
}

class _MyAnimePageState extends State<MyAnimePage> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // TextField Controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController genreController = TextEditingController();
  TextEditingController ratingController = TextEditingController();
  TextEditingController reviewController = TextEditingController();

  // Method to Submit Feedback and save it in Google Sheets
  void _submitForm() {
    // Validate returns true if the form is valid, or false
    // otherwise.
    if (_formKey.currentState.validate()) {
      // If the form is valid, proceed.
      AnimeEntryForm animeForm = AnimeEntryForm(
          nameController.text,
          genreController.text,
          ratingController.text,
          reviewController.text
      );

      AnimeFormController formController = AnimeFormController();

      _showSnackbar("Submitting Feedback");

      // Submit 'feedbackForm' and save it in Google Sheets.
      formController.submitForm(animeForm, (String response) {
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
                        controller: genreController,
//                        validator: (value) {
//                          if (!value.contains("@")) {
//                            return 'Enter Valid Email';
//                          }
//                          return null;
//                        },
                        decoration: InputDecoration(labelText: 'Genre'),
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
              child: Text('Submit Anime'),

            ),
            RaisedButton(
              color: Colors.lightBlueAccent,
              textColor: Colors.black,
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('View Anime List'),
            ),
          ],
        ),
      ),
    );
  }
}