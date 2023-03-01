import 'dart:convert'; // importación de la librería para convertir datos a JSON
import 'package:dio/dio.dart'; // importación de la librería para hacer peticiones HTTP

Future<List<Tema>> obtenerTemasDelModulo(String moduloPrefijo) async {
  try {
    var response = await Dio().get(
      'http://192.168.0.103/ingles/cursos_online/Api_functions/get_temas',
      queryParameters: {'modulo_prefijo': moduloPrefijo},
    );
    if (response.statusCode == 200) {
      var temas = (json.decode(response.data) as List)
          .map((temaData) => Tema.fromJson(temaData))
          .toList();
      return temas;
    }
  } catch (e) {
    print(e);
  }
  return null;
}

class Tema {
  final int idTema;
  final String tituloTema;

  Tema({this.idTema = 0, this.tituloTema});

  factory Tema.fromJson(Map<String, dynamic> json) {
    return Tema(
      idTema: int.parse(json['tema_id']), // Se convierte el id a un entero
      tituloTema: json['tema_titulo'],
    );
  }
}

/* Future<List<Tema>> obtenerTemasDelModulo(int idModulo) async {
  final response = await http.get(Uri.parse(
      'http://192.168.0.107/ingles/cursos_online/page/get_temas?id_modulo=$idModulo'));

  if (response.statusCode == 200) {
    final temasJson = jsonDecode(response.body) as List<dynamic>;

    final temas = temasJson.map((json) => Tema.fromJson(json)).toList();

    return temas;
  } else {
    throw Exception('Error al obtener los temas del módulo');
  }
} */
