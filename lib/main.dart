import 'dart:io';

import 'package:MyGameList/showGame.dart';
import 'package:flutter/material.dart';
import 'games.dart';
import 'editarGames.dart';

void main() {
  runApp(MaterialApp(home: Home()));
}

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  helper Crud = helper();
  List<Game> listGames = List();

  Function Update() {
    Crud.getAllGames().then((list) {
      setState(() {
        listGames = list;
        print(listGames.toString());
      });
    });
  }

  @override
  void initState() {
    super.initState();
    Crud.getAllGames().then((list) {
      setState(() {
        listGames = list;
        print(listGames.toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color active = Colors.cyan;
    final Color inactive = Colors.grey;

    String _brokenLine(String text) {
      String res = "";
      int i, cont = 0;
      for (i = 0; i < text.length; i++) {
        cont++;
        if (cont < 36) {
          if (cont == 35 && cont < text.length) {
            if (text[i + 1] == " ") {
              res = res + text[i];
            } else
              res = res + text[i] + "-";
          } else {
            res = res + text[i];
          }
        } else {
          res = res + "\n" + text[i].trim();
          cont = 0;
        }
      }
      return res;
    }

    Color _isActive(int actives, current) {
      if (current <= actives) {
        return active;
      } else {
        return inactive;
      }
    }

    Widget _Stars(int avaliate) {
      return Container(
        child: Row(
          children: <Widget>[
            Icon(
              Icons.star,
              color: _isActive(avaliate, 1),
            ),
            Icon(
              Icons.star,
              color: _isActive(avaliate, 2),
            ),
            Icon(
              Icons.star,
              color: _isActive(avaliate, 3),
            ),
            Icon(
              Icons.star,
              color: _isActive(avaliate, 4),
            ),
            Icon(
              Icons.star,
              color: _isActive(avaliate, 5),
            ),
          ],
        ),
      );
    }

    Widget _GameCard(BuildContext context, int index) {
      return GestureDetector(
        child: Card(
          child: Padding(
            padding: EdgeInsets.only(top: 10.00),
            child: Row(
              children: <Widget>[
                Container(
                  width: 80.0,
                  height: 120.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                        image: listGames[index].cover != null
                            ? FileImage(File(listGames[index].cover))
                            : AssetImage("Imagem/capa01.png"),
                        fit: BoxFit.cover),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            _brokenLine(
                                'Name: ' + listGames[index].name ?? ""),
                            style: TextStyle(fontSize: 20.0),
                          ),
                          Divider(
                            height: 10,
                          ),
                          Text(
                            _brokenLine(
                                'Publisher: ' + listGames[index].publisher ?? ""),
                            style: TextStyle(fontSize: 15.0),
                          ),
                          // Divider(
                          //   height: 5,
                          // ),
                          // Text(
                          //   _brokenLine(
                          //       'Genre: ' + listGames[index].genre ?? ""),
                          //   style: TextStyle(fontSize: 15.0),
                          // ),
                          // Divider(
                          //   height: 5,
                          // ),
                          // Text(
                          //   _brokenLine(
                          //       'Devs: ' + listGames[index].devs ?? ""),
                          //   style: TextStyle(fontSize: 15.0),
                          // ),
                          // Divider(
                          //   height: 5,
                          // ),
                          // Text(
                          //   _brokenLine(
                          //       'Year: ' + listGames[index].year.toString() ?? ""),
                          //   style: TextStyle(fontSize: 15.0),
                          // ),
                          Divider(
                            height: 5,
                          ),
                          Text(
                            _brokenLine(
                                'Plataform: ' + listGames[index].plataform ?? ""),
                            style: TextStyle(fontSize: 15.0),
                          ),
                          Divider(
                            height: 5,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          _ScreenGame(game: listGames[index]);
        },
        onLongPress: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Delete game?"),
                content: Text("The game will be definitely deleted!"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  FlatButton(
                    child: Text("Yeah, delete this"),
                    onPressed: () {
                      Crud.DeleteGame(listGames[index].id);
                      Update();
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            }
          );
        },
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyGameList',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("MyGameList"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _ScreenGame();
            Update();
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.cyan,
        ),
        body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            children: <Widget>[
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.all(10.0),
                itemCount: listGames.length,
                itemBuilder: (context, index) {
                  return _GameCard(context, index);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _ScreenGame({Game game}) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ShowGame(
                  games: game,
                )));
    Update();
  }
}
