import 'dart:convert';
import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import '/../main.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: prefer_const_constructors_in_immutables
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  Future<void> saveExpirationDate() async {
    // Obtener la fecha actual
    DateTime now = DateTime.now();
    // Definir una duración de expiración de 7 días
    Duration duration = Duration(days: 7);
    // Sumar la duración a la fecha actual para obtener la fecha de expiración
    DateTime expirationDate = now.add(duration);
    // Guardar la fecha de expiración en SharedPreferences
    await prefs.setString('expirationDate', expirationDate.toString());
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    Response response;

    try {
      final response = await Dio().get(
        'http://192.168.0.103/ingles/cursos_online/Api_functions/auth',
        queryParameters: {'email': email, 'password': password},
        options: Options(headers: {'Accept': 'application/json'}),
      );
      var data = response.data;
      //print(data['id']);
      if (data.containsKey('error')) {
        setState(() {
          _errorMessage = data['error'];
        });
      } else {
        //guardamos en variables sesion
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('idsesion', data['id']);
        await prefs.setString('user', data['user']);
        await prefs.setString('password', data['password']);
        await prefs.setString('nombre', data['nombre']);
        await prefs.setString('email', data['email']);
        await prefs.setString('inscripcion', data['inscripcion']);
        await prefs.setString('alu_fech', data['caducidad']);
        await prefs.setString('perfil', data['perfil']);
        await prefs.setString('tipouser', data['tipouser']);
        await prefs.setString('telefono', data['telefono']);
        // Guardar la fecha de expiración en SharedPreferences
        await saveExpirationDate();
        isLoggedIn = true;
        //print(isLoggedIn); // para ver si se actuliza a true
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyApp()),
        );
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'Error en el servidor, intenta de nuevo más tarde';
      });
    } finally {
      // Limpiar los campos de correo electrónico y contraseña
      _emailController.clear();
      _passwordController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Iniciar sesión',
              style: Theme.of(context).textTheme.headline4,
            ),
            if (_errorMessage != null)
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            SizedBox(height: 20),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email o usuario',
                hintText: 'ejemplo@gmail.com',
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Contraseña',
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleLogin,
              child: Text('Iniciar sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
