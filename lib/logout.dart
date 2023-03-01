import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:expert_english/screens/login/LoginScreen.dart';

class Logout extends StatefulWidget {
  /* final bool isLoggedIn;
  const Logout({Key key, this.isLoggedIn}) : super(key: key); */

  @override
  _LogoutState createState() => _LogoutState();
}

class _LogoutState extends State<Logout> {
  //bool _isLoggedIn = true;

  @override
  void initState() {
    super.initState();
    _logout();
  }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // limpia todas las preferencias guardadas
    /* setState(() {
      _isLoggedIn = false;
    }); */
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
      ModalRoute.withName('/login'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
