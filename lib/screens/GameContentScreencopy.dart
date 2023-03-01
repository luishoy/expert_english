import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'; // para las sesion
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:audioplayers/audioplayers.dart';
//import 'package:http/http.dart' as http;

class GameContent extends StatefulWidget {
  @override
  _GameContentState createState() => _GameContentState();
}

AudioPlayer audioPlayer = AudioPlayer();

void _playAudio(String audioUrl) async {
  int result = await audioPlayer.play(audioUrl);
  if (result == 1) {
    // success
  }
}

void _stopAudio() async {
  await audioPlayer.stop();
}

class _GameContentState extends State<GameContent> {
  //AudioPlayer audioPlayer = AudioPlayer();

  var _listQuestionGame = [];
  var _listAlternativesGame = [];

  @override
  void initState() {
    super.initState();
    _getListQuestion();
  }

  Future<void> _getListQuestion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String idsesion = prefs.getString('idsesion');
    final Map<String, dynamic> gameData =
        ModalRoute.of(context).settings.arguments;

    try {
      final Response response = await Dio().post(
        'http://192.168.0.103/ingles/cursos_online/Api_functions/lista_preguntas_game',
        data: {'idtema': gameData['idtema']},
        options: Options(headers: {'Accept': 'application/json'}),
      );
      //Map<String, dynamic> data = jsonDecode(response.data);
      setState(() {
        _listQuestionGame = jsonDecode(response.data);
      });
      print(_listQuestionGame);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> gameData =
        ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(gameData['titulo']),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.0,
          ),
          itemCount: _listQuestionGame.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color: _listQuestionGame[index]['isCorrect'] != null &&
                      _listQuestionGame[index]['isCorrect']
                  ? Colors.green
                  : Colors.red,
              child: InkWell(
                onTap: () {
                  print(_listQuestionGame[index]['prega_titulo']);
                  showModal(
                      context,
                      int.parse(_listQuestionGame[index]['prega_id']),
                      _listQuestionGame[index]['prega_titulo'],
                      _listQuestionGame[index]['prega_titulo_ad1'],
                      _listQuestionGame[index]['prega_titulo_ad2'],
                      _listQuestionGame[index]['fga_titulo'],
                      index);
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromARGB(255, 255, 215, 0),
                        Color.fromARGB(255, 241, 209, 112),
                        Color.fromARGB(255, 255, 187, 0),
                        Color.fromARGB(255, 255, 162, 0),
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 10),
                      Text((index + 1).toString(),
                          style: TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            fontSize: 55,
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _updateQuestion(int questionIndex, bool isCorrect) {
    setState(() {
      _listQuestionGame[questionIndex]['isCorrect'] = isCorrect;
    });
  }

  void showModal(
      BuildContext context,
      int prega_id,
      String titulopreg,
      String titulo_ad1,
      String titulo_ad2,
      String file_preg,
      int questionIndex) async {
    int preguntaId = prega_id;
    String titulop = titulopreg;
    String titulo_format =
        titulop.replaceAll(RegExp(r'<em>(.*?)<\/em>'), '_ _ _ _ _ _ _ _');

    final alternatives = await _getListAlternatives(preguntaId, context);

    final isCorrect = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
          ),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height,
              maxWidth: MediaQuery.of(context).size.width,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Text(
                          'Modal pregunta',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    SizedBox(height: 10),
                    if (file_preg.contains('.png') ||
                        file_preg.contains('.jpg') ||
                        file_preg.contains('.jpeg') ||
                        file_preg.contains('.gif'))
                      Image.network(
                        'http://192.168.0.103/ingles/cursos_admin/uploads/files_game/$file_preg',
                        height: 200,
                        width: 200,
                      ),
                    if (file_preg.contains('.mp3') ||
                        file_preg.contains('.wav'))
                      IconButton(
                        icon: Icon(Icons.play_arrow),
                        onPressed: () {
                          _playAudio(
                              'http://192.168.0.103/ingles/cursos_admin/uploads/files_game/$file_preg');
                        },
                      ),
                    SizedBox(height: 10),
                    Text(
                      '$titulo_ad1',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '$titulo_ad2',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 15),
                    Text(
                      '$titulo_format',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: _buildAlternativesButtons(
                            context, alternatives, correctAlternative),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (isCorrect != null && isCorrect) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('¡Respuesta correcta!'),
          duration: Duration(seconds: 2),
        ),
      );
    } else if (isCorrect != null && !isCorrect) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Respuesta incorrecta'),
          duration: Duration(seconds: 2),
        ),
      );
    }

    if (isCorrect != null) {
      _updateQuestion(questionIndex, isCorrect);
    }
  }

  String correctAlternative;
  List<Widget> _buildAlternativesButtons(BuildContext context,
      List<dynamic> alternatives, String correctAlternative) {
    List<Widget> buttons = [];

    for (int i = 0; i < alternatives.length; i++) {
      String alternative = alternatives[i]['altga_titulo'];
      bool isCorrect = alternatives[i]['altga_correcta'] == 'C';
      if (isCorrect) {
        correctAlternative = alternative;
      }
      buttons.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              if (isCorrect) {
                print('Respuesta correcta');
                Navigator.pop(context, true); // Cerrar el modal y devolver true
              } else {
                print('Respuesta incorrecta');
                Navigator.pop(
                    context, false); // Cerrar el modal y devolver false
              }
            },
            style: ElevatedButton.styleFrom(
              primary: isCorrect ? Colors.green : null,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            child: Text(alternative),
          ),
        ),
      );
    }

    return buttons;
  }
}

Future<List<dynamic>> _getListAlternatives(
    int preguntaId, BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String idsesion = prefs.getString('idsesion');

  try {
    final Response response = await Dio().post(
      'http://192.168.0.103/ingles/cursos_online/Api_functions/lista_alternativas',
      data: {'preguntaid': preguntaId},
      options: Options(headers: {'Accept': 'application/json'}),
    );
    return jsonDecode(response.data);
  } catch (e) {
    print(e);
    return [];
  }
}



//bool _isCorrect = false;
