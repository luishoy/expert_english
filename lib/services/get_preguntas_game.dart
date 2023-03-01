/* import 'dart:convert'; // importación de la librería para convertir datos a JSON
import 'package:dio/dio.dart'; // importación de la librería para hacer peticiones HTTP

Future<List<Game>> obtenerPreguntasGame(String temaid) async {
  try {
    var response = await Dio().get(
      'http://192.168.0.103/ingles/cursos_online/Api_functions/get_temas',
      queryParameters: {'temaid': temaid},
    );
    if (response.statusCode == 200) {
      var game = (json.decode(response.data) as List)
          .map((gameData) => Game.fromJson(gameData))
          .toList();
      return game;
    }
  } catch (e) {
    print(e);
  }
  return null;
}

class Game {
  final int idGame;
  final String prega_titulo;

  Game({this.idGame = 0, this.prega_titulo});

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      idGame: int.parse(json['tema_id']), // Se convierte el id a un entero
      prega_titulo: json['prega_titulo'],
    );
  }
}
 */