import 'dart:convert'; // importación de la librería para convertir datos a JSON
import 'package:dio/dio.dart'; // importación de la librería para hacer peticiones HTTP
import 'package:html_unescape/html_unescape_small.dart';

Future<Detalle_tema> obtenerDetalleTema(int tema_id) async {
  try {
    var response = await Dio().get(
      'http://192.168.0.103/ingles/cursos_online/Api_functions/get_detalle_tema',
      queryParameters: {'tema_id': tema_id},
    );
    if (response.statusCode == 200) {
      // convierte el string en un mapa antes de pasarlo al método fromJson
      final Map<String, dynamic> data = json.decode(response.data);
      return Detalle_tema.fromJson(data);
    }
    throw Exception('Failed to load detail topic');
  } catch (e) {
    throw Exception('Failed to load detail topic: $e');
  }
}

class Detalle_tema {
  final int idTema;
  final String tituloTema;
  final String nivelTema;
  final List<String> parrafosDescripcionTema;

  Detalle_tema({
    this.idTema = 0,
    this.tituloTema,
    this.nivelTema,
    this.parrafosDescripcionTema,
  });

  factory Detalle_tema.fromJson(Map<String, dynamic> json) {
    String descripcion = HtmlUnescape()
        .convert(json['tema_descripcion'].replaceAll(RegExp(r'<[^>]*>'), ''));
    List<String> parrafos = descripcion.split('\n');
    return Detalle_tema(
      idTema: int.parse(json['tema_id']),
      tituloTema: json['tema_titulo'],
      nivelTema: json['tema_nivel'],
      parrafosDescripcionTema: parrafos,
    );
  }
}

/* Future<List<Tema>> obtenerDetalleTema(int idModulo) async {
  final response = await http.get(Uri.parse(
      'http://192.168.0.107/ingles/cursos_online/Api_functions/get_temas?id_modulo=$idModulo'));

  if (response.statusCode == 200) {
    final temasJson = jsonDecode(response.body) as List<dynamic>;

    final temas = temasJson.map((json) => Tema.fromJson(json)).toList();

    return temas;
  } else {
    throw Exception('Error al obtener los temas del módulo');
  }
} */
