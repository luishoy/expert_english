import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:expert_english/logout.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MiPerfil extends StatefulWidget {
  @override
  _MiPerfilState createState() => _MiPerfilState();
}

class _MiPerfilState extends State<MiPerfil> {
  String user = '';
  String nombre = '';
  String email = '';
  String telefono = '';
  String alu_fech = '';
  String inscripcion = '';

  @override
  void initState() {
    super.initState();
    dataSesion();
  }

  void dataSesion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = prefs.getString('user');
    String nombre = prefs.getString('nombre');
    String email = prefs.getString('email');
    String telefono = prefs.getString('telefono');
    String alu_fech = prefs.getString('alu_fech');
    String inscripcion = prefs.getString('inscripcion');

    setState(() {
      this.user = user;
      this.nombre = nombre;
      this.email = email;
      this.telefono = telefono;
      this.alu_fech = alu_fech;
      this.inscripcion = inscripcion;
    });
  }

  @override
  Widget build(BuildContext context) {
    String name_tab = "Mis datos";
    return Scaffold(
      appBar: AppBar(
        title: Text(name_tab),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /* Text(
              'Mi perfil',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ), */
            SizedBox(height: 2),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.person,
                        color: Color.fromARGB(255, 55, 104, 253)),
                    title: Text('$nombre'),
                    subtitle: Text('$user'),
                  ),
                  ListTile(
                    leading: Icon(Icons.email,
                        color: Color.fromARGB(255, 55, 104, 253)),
                    title: Text('$email'),
                    subtitle: Text('Email'),
                  ),
                  ListTile(
                    leading: Icon(Icons.phone,
                        color: Color.fromARGB(255, 55, 104, 253)),
                    title: Text('$telefono'),
                    subtitle: Text('Telefono'),
                  ),
                  ListTile(
                    leading: Icon(Icons.calendar_month,
                        color: Color.fromARGB(255, 55, 104, 253)),
                    title: Text('$inscripcion'),
                    subtitle: Text('Fecha Incripcion'),
                  ),
                  ListTile(
                    leading: Icon(Icons.calendar_month,
                        color: Color.fromARGB(255, 55, 104, 253)),
                    title: Text('$alu_fech'),
                    subtitle: Text('Fecha fin de clases'),
                  ),
                  // Agrega más elementos de la lista aquí
                ],
              ),
            ),
            SizedBox(height: 1),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(148, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                elevation: 4,
                shadowColor: Color.fromARGB(255, 229, 95, 95),
                backgroundColor: Color.fromARGB(255, 255, 255, 255),
              ),
              onPressed: () {
                // Call funtion cerrar sesion
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Logout(),
                    settings: RouteSettings(arguments: {}),
                  ),
                );
              },
              child: Text(
                'Cerrar Session',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 255, 0, 0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
