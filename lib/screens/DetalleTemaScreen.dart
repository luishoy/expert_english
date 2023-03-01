import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;// fue reemplazado por "dio"
import 'package:dio/dio.dart';
import 'package:expert_english/models/modulo.dart'; // Importación de la clase Modulo
import 'package:expert_english/services/get_detalle_temas.dart';

// Modificar la clase DetalleTemaScreen
class DetalleTemaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> temaData =
        ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(temaData['titulo']),
      ),
      body: FutureBuilder<Detalle_tema>(
        future: obtenerDetalleTema(temaData['id']),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var tema = snapshot.data;
            //tema.parrafosDescripcionTema.forEach((parrafo) => print(parrafo));// para mostrar por consola
            return Column(
              children: [
                ListTile(
                  leading: Icon(Icons.class_outlined,
                      color: Color.fromARGB(255, 255, 89, 0)),
                  title: Text(
                    tema.tituloTema,
                    style: TextStyle(
                      color: Color.fromRGBO(16, 16, 17, 1),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(tema.nivelTema),
                  contentPadding: EdgeInsets.only(right: 2),
                ),
                SizedBox(height: 3),
                Wrap(
                  alignment: WrapAlignment.start,
                  children: tema.parrafosDescripcionTema
                      .where((parrafo) =>
                          parrafo.trim().isNotEmpty) // Filtrar párrafos vacíos
                      .map((parrafo) {
                    return Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      child: Text(
                        parrafo.trim(),
                        textAlign: TextAlign.justify,
                      ),
                    );
                  }).toList(),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            print('Error al mostrar los datos: ${snapshot.error}');
            return Text("Error al cargar el tema");
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

/* class DetalleTemaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> moduloData =
        ModalRoute.of(context).settings.arguments;

    int id = moduloData['id'];
    String nombre = moduloData['titulo'];

    return Scaffold(
      appBar: AppBar(
        title: Text(nombre),
      ),
      body: Center(
        child: Text('Detalles del módulo con id $id'),
      ),
    );
  }
}
 */