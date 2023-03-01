import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'; // para las sesion
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class Progress extends StatefulWidget {
  @override
  _ProgressState createState() => _ProgressState();
}

// funcion que sirve para consultar y mostrar datos de sesion
/* void dataSesion() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String user = prefs.getString('user');
  String password = prefs.getString('password');
  //print(user);
} */

class _ProgressState extends State<Progress> {
  // se declara el array con los modulos en 0, y los muestra mientras llega la conulta de la base de datos, se tiene tienes que tener los mismos nombres.
  Map<String, String> _progress = {
    'Grammar': '0',
    'Vocabulary2': '0',
    'Reading': '0',
    'Listening': '0',
    'Song': '0',
    'Audio': '0',
  };

  @override
  void initState() {
    super.initState();
    _getProgress();
  }

  Future<void> _getProgress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String idsesion = prefs.getString('idsesion');
    try {
      final Response response = await Dio().post(
        'http://192.168.0.102/ingles/cursos_online/Api_functions/get_progress',
        data: {'idsesion': idsesion},
        options: Options(headers: {'Accept': 'application/json'}),
      );

      Map<String, dynamic> data = jsonDecode(response.data);
      data.forEach((key, value) {
        setState(() {
          _progress[key] = value.toString();
        });
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Progress'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _progress.keys
              .map(
                (key) => Column(
                  children: [
                    SizedBox(height: 16),
                    //Text(key), // texto sale encima de la barra
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: LinearProgressIndicator(
                            minHeight: 25,
                            backgroundColor: Color.fromARGB(255, 202, 221, 237),
                            value: double.parse(_progress[key]) / 100.0,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color.fromARGB(255, 89, 52, 211)),
                          ),
                        ),
                        Center(
                          child: Text(
                            _progress[key],
                            style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Positioned(
                          top: 5,
                          left: 5,
                          child: Text(
                            key,
                            style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255)),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
