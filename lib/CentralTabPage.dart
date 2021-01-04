import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:gaming_anime_list/AnimeList.dart';
import 'package:gaming_anime_list/GameList.dart';

class CentralPage extends StatefulWidget {
  CentralPage({Key key, this.title}) : super(key : key);

  final String title;

  @override
  _CentralPageState createState() => _CentralPageState();
}


class _CentralPageState extends State<CentralPage> with SingleTickerProviderStateMixin{
  TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this, initialIndex: 0);
    print(_tabController.length);

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {     //Prepopulating just in case we get this working
    return DefaultTabController(
      length: labels.length,
      child: Scaffold(
        appBar: AppBar(
          title: TabBar(
            controller: _tabController,
            tabs:labels.map<Widget>((Label label) {
              return Tab(
                icon: Icon(label.icon),
              );
            }).toList(),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            AnimeListPage(),
            GameListPage(),
          ],
        ),
      ),
    );
  }

}

class Label {
  final String title;
  final IconData icon;
  const Label({this.title, this.icon});
}

const List<Label> labels = <Label>[
  Label(title: "Animes", icon:Icons.ondemand_video),
  Label(title: 'Games', icon:Icons.games),
];
