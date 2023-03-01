import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class SecondScreen extends StatefulWidget {
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  var _docentes = [];

  @override
  void initState() {
    super.initState();
    _getDocentes();
  }
  /* 
  Future<Response> getDocentes() async {
    final response = await Dio()
        .get('http://192.168.0.107/ingles/cursos_online/page/get_docentes');
    return response;
  } */

  Future<void> _getDocentes() async {
    Response response = await Dio().get(
        'http://192.168.0.102/ingles/cursos_online/Api_functions/get_docentes');
    setState(() {
      _docentes = jsonDecode(response.data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Docente Expert English'),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              'Lista de docentes de inglés',
              style: TextStyle(
                color: Color.fromARGB(255, 81, 83, 232),
                fontSize: 24,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _docentes.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Row(
                      children: [
                        Icon(Icons.person),
                        SizedBox(width: 5),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_docentes[index]['alu_nombres'] ?? ''),
                              //Text(_docentes[index]['alu_email'] ?? ''),
                              //Text(_docentes[index]['alu_telefono'] ?? ''),
                            ],
                          ),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.video_call_outlined),
                      onPressed: () async {
                        //var url = _docentes[index]['alu_skype'];
                        if (_docentes[index]['alu_skype'] != null &&
                            await canLaunch(_docentes[index]['alu_skype'])) {
                          await launch(_docentes[index]['alu_skype']);
                        } else {
                          print("La URL es inválida o no se puede lanzar.");
                        }
                      },
                    ),
                  );
                },
              ),
            ),
            /* ElevatedButton(
              child: Text('Vuelve a la pantalla anterior'),
              onPressed: () {
                Navigator.pop(context);
              },
            ), */
          ],
        ),
      ),
    );
  }
}
