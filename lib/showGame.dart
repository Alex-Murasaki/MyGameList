import 'dart:io';

import 'package:MyGameList/editarGames.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'games.dart';

class ShowGame extends StatefulWidget {
  final Game games;

  ShowGame({this.games});

  @override
  _ShowGameState createState() => _ShowGameState();
}

class _ShowGameState extends State<ShowGame> {

  String _name;
  String _publisher;
  String _genre;
  String _devs;
  String _year;
  String _plataform;
  int valida;

  helper Crud = helper();
  Game _aux;

  @override
  void initState() {
    super.initState();
    if (widget.games == null) {
      _aux = Game();
      valida = 0;
    } else {
      _aux = Game.fromMap(widget.games.toMap());
      _name = _aux.name;
      _publisher = _aux.publisher;
      _genre = _aux.genre;
      _devs = _aux.devs;
      _year = _aux.year.toString();
      _plataform = _aux.plataform;
      valida = 1;
    }
  }

  void updateState() {
    setState((){
      _name = _aux.name;
      _publisher = _aux.publisher;
      _genre = _aux.genre;
      _devs = _aux.devs;
      _year = _aux.year.toString();
      _plataform = _aux.plataform;  
    });
  }

  @override
  Widget build(BuildContext context) {

    Crud.getThisGame(_aux.id).then((thisGame) {
      setState(() {
        _aux = thisGame;
        updateState();
      });
    });

    Widget Tela() {
      return Container(
        child: Column(
          children: <Widget>[
            Text(
              "sshhooww  ggaammee",style: TextStyle(
              color: Colors.grey,
            ),),
            Padding(padding: EdgeInsets.only(top: 30)),
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: _aux.cover != null
                          ? FileImage(File(_aux.cover))
                          : AssetImage("Imagem/capa01.png"),
                      fit: BoxFit.cover),
                ),
              ),
            Divider(
              height: 20,
            ),
            Container(
              child: Row(children: [
                Text(
                    "Name: ",
                    style: TextStyle(
                      color: Colors.blueAccent, fontSize: 20.0
                    ),
                  textAlign: TextAlign.right,
                ),
                Text(
                    "  $_name",
                    style: TextStyle(
                      color: Colors.black, fontSize: 20.0
                    ),
                  textAlign: TextAlign.right,
                ), 
              ],)
            ),
            Divider(
              height: 20,
            ),
            Container(
              child: Row(children: [
                Text(
                    "Publisher: ",
                    style: TextStyle(
                      color: Colors.blueAccent, fontSize: 20.0
                    ),
                  textAlign: TextAlign.right,
                ),
                Text(
                    "  $_publisher",
                    style: TextStyle(
                      color: Colors.black, fontSize: 20.0
                    ),
                  textAlign: TextAlign.right,
                ), 
              ],)
            ),
            Divider(
              height: 20,
            ),
            Container(
              child: Row(children: [
                Text(
                    "Genre: ",
                    style: TextStyle(
                      color: Colors.blueAccent, fontSize: 20.0
                    ),
                  textAlign: TextAlign.right,
                ),
                Text(
                    "  $_genre",
                    style: TextStyle(
                      color: Colors.black, fontSize: 20.0
                    ),
                  textAlign: TextAlign.right,
                ), 
              ],)
            ),
            Divider(
              height: 20,
            ),
            Container(
              child: Row(children: [
                Text(
                    "Devs: ",
                    style: TextStyle(
                      color: Colors.blueAccent, fontSize: 20.0
                    ),
                  textAlign: TextAlign.right,
                ),
                Text(
                    "  $_devs",
                    style: TextStyle(
                      color: Colors.black, fontSize: 20.0
                    ),
                  textAlign: TextAlign.right,
                ), 
              ],)
            ),
            Divider(
              height: 20,
            ),
            Container(
              child: Row(children: [
                Text(
                    "Year: ",
                    style: TextStyle(
                      color: Colors.blueAccent, fontSize: 20.0
                    ),
                  textAlign: TextAlign.right,
                ),
                Text(
                    "  $_year",
                    style: TextStyle(
                      color: Colors.black, fontSize: 20.0
                    ),
                  textAlign: TextAlign.right,
                ), 
              ],)
            ),
            Divider(
              height: 20,
            ),
            Container(
              child: Row(children: [
                Text(
                    "Plataform: ",
                    style: TextStyle(
                      color: Colors.blueAccent, fontSize: 20.0
                    ),
                  textAlign: TextAlign.right,
                ),
                Text(
                    "  $_plataform",
                    style: TextStyle(
                      color: Colors.black, fontSize: 20.0
                    ),
                  textAlign: TextAlign.right,
                ), 
              ],)
            ),
            Padding(padding: EdgeInsets.only(top: 40.0)),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(_aux.name ?? "New Game"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _ScreenGame(game: _aux);
          updateState();
        },
        child: Icon(Icons.edit),
        backgroundColor: Colors.cyan,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        physics: ScrollPhysics(),
        child: Column(
          children: <Widget>[Tela()],
        ),
      ),
    );
  }
  
  void _ScreenGame({Game game}) async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => EditGame(
        games: game,
      )));
      updateState();
  }

}
