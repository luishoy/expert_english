import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;// fue reemplazado por "dio"
import 'package:dio/dio.dart';
import 'package:expert_english/models/modulo.dart'; // Importación de la clase Modulo
import 'package:expert_english/services/get_temas.dart';
import 'package:expert_english/services/get_detalle_temas.dart';
import 'package:expert_english/screens/DetalleTemaScreen.dart';

class DetalleModuloScreen extends StatelessWidget {
  //final Map<String, dynamic> modulo;
  //DetalleModuloScreen({this.modulo});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> moduloData =
        ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(moduloData['nombre']),
      ),
      body: FutureBuilder<List<Tema>>(
        future: obtenerTemasDelModulo(moduloData['nombre']),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 7.0),
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                var tema = snapshot.data[index];
                return ListTile(
                  tileColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                  leading: Text("${index + 1}"),
                  title: Text(tema.tituloTema),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DetalleTemaScreen(),
                        settings: RouteSettings(
                          arguments: {
                            'id': tema.idTema,
                            'titulo': tema.tituloTema,
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text("Error al cargar los temas");
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


/* class DetalleModuloScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> moduloData =
        ModalRoute.of(context).settings.arguments;

    int id = moduloData['id'];
    String nombre = moduloData['nombre'];

    return Scaffold(
      appBar: AppBar(
        title: Text(nombre),
      ),
      body: Center(
        child: Text('Detalles del módulo con id $id'),
      ),
    );
  }
} */
