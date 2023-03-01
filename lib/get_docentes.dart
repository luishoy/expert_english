/* import 'dart:convert';

import 'package:http/http.dart' as http;

Future<List<Docente>> fetchDocentes() async {
  final response = await http
      .get('http://192.168.0.107/ingles/cursos_online/page/get_docentes');

  print(response.body);
  if (response.statusCode == 200) {
    // Si la petición fue exitosa, parseamos la respuesta JSON
    List<dynamic> jsonResponse = jsonDecode(response.body);
    List<Docente> docentes = [];
    for (var docente in jsonResponse) {
      docentes.add(Docente.fromJson(docente));
    }
    //print(docentes); // Agregamos este print statement aquí
    return docentes;
  } else {
    // Si la petición no fue exitosa, lanzamos un error
    throw Exception('Failed to load docentes');
  }
}

class Docente {
  final int id;
  final String nombre;

  Docente({this.id, this.nombre});

  factory Docente.fromJson(Map<String, dynamic> json) {
    return Docente(
      id: json['alu_id'],
      nombre: json['alu_nombres'],
    );
  }
}
 */