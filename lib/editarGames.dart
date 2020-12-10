import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'games.dart';

class EditGame extends StatefulWidget {
  final Game games;

  EditGame({this.games});

  @override
  _CardEditGameState createState() => _CardEditGameState();
}

enum SingingCharacter { Lido, Lendo, Nao_Lido }

class _CardEditGameState extends State<EditGame> {

  TextEditingController _name = TextEditingController();
  TextEditingController _publisher = TextEditingController();
  TextEditingController _genre = TextEditingController();
  TextEditingController _devs = TextEditingController();
  TextEditingController _year = TextEditingController();
  TextEditingController _plataform = TextEditingController();
  int valida;
  final _nameFocus = FocusNode();
  final _yearFocus = FocusNode();

  helper crud = helper();
  Game _aux;

  @override
  void initState() {
    super.initState();
    if (widget.games == null) {
      _aux = Game();
      valida = 0;
    } else {
      _aux = Game.fromMap(widget.games.toMap());
      _name.text = _aux.name;
      _publisher.text = _aux.publisher;
      _genre.text = _aux.genre;
      _devs.text = _aux.devs;
      _year.text = _aux.year.toString();
      _plataform.text = _aux.plataform;
      valida = 1;
    }
  }

  @override
  Widget build(BuildContext context) {

    Widget tela() {
      return Container(
        child: Column(
          children: <Widget>[
            Text(
              "Para tirar foto é so clicar na imagem",style: TextStyle(
              color: Colors.grey,
            ),),
            Padding(padding: EdgeInsets.only(top: 30)),

            GestureDetector(
              child: Container(
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
              onTap: () {
                ImagePicker.pickImage(source: ImageSource.camera).then((file) {
                  if (file == null) return;
                  setState(() {
                    _aux.cover = file.path;
                  });
                });
              },
            ),
            TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: "Name",
                labelStyle: TextStyle(
                  color: Colors.blueAccent,
                ),
              ),
              controller: _name,
              focusNode: _nameFocus,
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.black, fontSize: 20.0),
            ),
            TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: "Publisher",
                labelStyle: TextStyle(
                  color: Colors.blueAccent,
                ),
              ),
              controller: _publisher,
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.black, fontSize: 20.0),
            ),
            TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: "Genre",
                labelStyle: TextStyle(
                  color: Colors.blueAccent,
                ),
              ),
              controller: _genre,
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.black, fontSize: 20.0),
            ),
            TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: "Devs",
                labelStyle: TextStyle(
                  color: Colors.blueAccent,
                ),
              ),
              controller: _devs,
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.black, fontSize: 20.0),
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Year",
                labelStyle: TextStyle(
                  color: Colors.blueAccent,
                ),
              ),
              focusNode: _yearFocus,
              controller: _year,
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.black, fontSize: 20.0),
            ),
            TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: "Plataform",
                labelStyle: TextStyle(
                  color: Colors.blueAccent,
                ),
              ),
              controller: _plataform,
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.black, fontSize: 20.0),
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
          if (_name.text != null && _name.text.isNotEmpty) {
            if (_year.text != null && _year.text.isNotEmpty) {
              _aux.name = _name.text;
              _aux.publisher = _publisher.text;
              _aux.genre = _genre.text;
              _aux.devs = _devs.text;
              _aux.year = int.parse(_year.text);
              _aux.plataform = _plataform.text;
              if (valida == 0) {
                crud.InsertGame(_aux);
              } else {
                crud.EditGame(_aux);
              }
              Navigator.pop(
                context,
              );
            } else {
              FocusScope.of(context).requestFocus(_yearFocus);
            }
          } else {
            FocusScope.of(context).requestFocus(_nameFocus);
          }
        },
        child: Icon(Icons.save),
        backgroundColor: Colors.cyan,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        physics: ScrollPhysics(),
        child: Column(
          children: <Widget>[tela()],
        ),
      ),
    );
  }
}
