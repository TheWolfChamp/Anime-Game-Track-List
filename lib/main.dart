import 'package:flutter/material.dart';
import 'package:gaming_anime_list/AnimeList.dart';
import 'package:gaming_anime_list/GameList.dart';
import 'CentralTabPage.dart';
import 'Pages/Model/anime_entry.dart';
import 'Pages/Model/game_entry.dart';
import 'Pages/controller/anime_form_controller.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anime and Games List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CentralPage(title: 'List Submission'),
    );
  }
}

