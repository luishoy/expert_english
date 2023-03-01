import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'; // para las sesion
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:expert_english/screens/GameContentScreen.dart';

class ListGame extends StatefulWidget {
  @override
  _ListGameState createState() => _ListGameState();
}

class _ListGameState extends State<ListGame> {
  var _listGames = [];

  @override
  void initState() {
    super.initState();
    _getListGames();
  }

  Future<void> _getListGames() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String idsesion = prefs.getString('idsesion');
    try {
      final Response response = await Dio().post(
        'http://192.168.0.103/ingles/cursos_online/Api_functions/lista_games',
        data: {'idsesion': idsesion},
        options: Options(headers: {'Accept': 'application/json'}),
      );
      //Map<String, dynamic> data = jsonDecode(response.data);
      setState(() {
        _listGames = jsonDecode(response.data);
      });
      print(_listGames);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Games'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.0,
          ),
          itemCount: _listGames.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              elevation: 2,
              color: Color.fromARGB(255, 255, 255, 255),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => GameContent(),
                      settings: RouteSettings(
                        arguments: {
                          'idtema': _listGames[index]['tema_id'],
                          'titulo': _listGames[index]['tema_titulo'],
                        },
                      ),
                    ),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.gamepad,
                      size: 50,
                      color: Color.fromARGB(255, 217, 111, 215),
                    ),
                    SizedBox(height: 10),
                    Text(_listGames[index]['tema_titulo']),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
