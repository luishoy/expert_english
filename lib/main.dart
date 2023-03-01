import 'package:flutter/material.dart';
import './second_screen.dart';
import 'package:expert_english/screens/ProgresScreen.dart';
//import './screens/DetalleModuloScreen.dart';
import 'package:expert_english/screens/DetalleModuloScreen.dart';
import 'package:expert_english/screens/login/LoginScreen.dart';
import 'package:expert_english/screens/MiPerfilScreen.dart';
import 'package:expert_english/screens/ListGameScreen.dart';
import 'get_modulos.dart';
//import 'package:expert_english/logout.dart';
import 'package:shared_preferences/shared_preferences.dart';

//void main() => runApp(MyApp());

/* void main() {
  runApp(MaterialApp(
    home: LoginScreen(),
  ));
} */
SharedPreferences prefs;
bool isLoggedIn = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();

  // Verificar si el usuario ha iniciado sesión
  dataSesion().then((isLoggedIn) {
    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isLoggedIn ? MyApp() : LoginScreen(),
    ));
  });
}

// función que sirve para consultar y mostrar datos de sesión
Future<bool> dataSesion() async {
  String user = prefs.getString('user');
  String password = prefs.getString('password');
  // Verificar si los datos de sesión son válidos
  if (user != null && password != null) {
    // Verificar si la sesión no ha caducado
    String fechaCaducidad = prefs.getString('expirationDate');
    // Consultamos la fecha de termino de clase en la sesion
    String alu_fech = prefs.getString('alu_fech');
    //print('Valor de fechaCaducidad en SharedPreferences: $fechaCaducidad');
    if (fechaCaducidad != null && alu_fech != null) {
      DateTime caducidadFecha = DateTime.parse(fechaCaducidad);
      //fecha termino de clase
      DateTime fechaClases = DateTime.parse(alu_fech);
      if (caducidadFecha.isAfter(DateTime.now()) &&
          fechaClases.isAfter(DateTime.now())) {
        // La sesión no ha caducado
        return true;
      }
    }
  }
  // Los datos de sesión no son válidos o la sesión ha caducado
  return false;
}

/* 
void main() {
  //print(isLoggedIn);
  // Verificar si el usuario ha iniciado sesión
  isLoggedIn = true;
  //checkLoginStatus();
  dataSesion();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: isLoggedIn ? MyApp() : LoginScreen(),
  ));
}

// funcion que sirve para consultar y mostrar datos de sesion
void dataSesion() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String user = prefs.getString('user');
  String password = prefs.getString('password');
  //print(user);
  //print(prefs.getString('caducidad'));
} */

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String userss = prefs.getString('user');
    String firstLetter = userss.substring(0, 1).toUpperCase();

    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/login': (context) => LoginScreen(),
        '/app': (context) => MyApp(),
        //'/logout': (context) => Logout()
      },
      debugShowCheckedModeBanner: false,
      home: Navigator(
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(
            builder: (BuildContext context) {
              return Scaffold(
                appBar: AppBar(
                  title: Container(
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      'assets/logo.png',
                      height: 100,
                      width: 100,
                    ),
                  ),
                  actions: [
                    /* GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MiPerfil(),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Icon(
                          Icons.person,
                          size: 30,
                        ),
                      ),
                    ), */

                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MiPerfil(),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.orange[700],
                        ),
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          '$firstLetter',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                      ),
                    ),
                  ],
                ),
                drawer: Drawer(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      Container(
                        height: 70,
                        child: DrawerHeader(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                          ),
                          child: Text(
                            'Menu',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                      FutureBuilder<List<Modulo>>(
                        future: fetchModulos(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                              children: snapshot.data.map((modulo) {
                                return ExpansionTile(
                                  // se agrego para los submenus
                                  title: Text(modulo.nombre),
                                  children: modulo.subMenus.map((subMenu) {
                                    return ListTile(
                                      title: Text(subMenu.nombre),
                                      onTap: () {
                                        // Agrega aquí lo que deseas hacer cuando se seleccione un submenú
                                      },
                                    );
                                  }).toList(),
                                );
                                /* return InkWell(
                                  onTap: () {
                                    //print("Botón de módulo pulsado");
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DetalleModuloScreen(),
                                        settings: RouteSettings(arguments: {
                                          'id': modulo.id,
                                          'nombre': modulo.nombre,
                                        }),
                                      ),
                                    );
                                  },
                                  child: ListTile(
                                    title: Text(modulo.nombre),
                                  ),
                                ); */
                              }).toList(),
                            );
                          } else if (snapshot.hasError) {
                            return Text("No se encontraron módulos");
                          }

                          // Por defecto, muestra un indicador de carga
                          return CircularProgressIndicator();
                        },
                      )
                    ],
                  ),
                ),
                body: Center(
                  child: Column(
                    children: [
                      SizedBox(height: 30),
                      Text(
                        'Quieres aprender Inglés...?',
                        style: TextStyle(
                          color: Color.fromARGB(255, 81, 83, 232),
                          fontSize: 25,
                        ),
                      ),
                      SizedBox(height: 30),
                      Container(
                        width: 300,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(148, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                elevation: 5,
                                shadowColor: Color.fromARGB(255, 158, 158, 158),
                                backgroundColor:
                                    Color.fromARGB(255, 79, 224, 63),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'My progress',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 16, 16, 16),
                                    ),
                                  ),
                                  Icon(
                                    Icons.list_alt,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ],
                              ),
                              onPressed: () {
                                // Acción al presionar el botón "Lista de docentes"
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    // llamamos ala funcion Progress en el ProresScreen.dart
                                    builder: (context) => Progress(),
                                  ),
                                );
                              },
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(145, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                elevation: 5,
                                shadowColor: Colors.grey,
                                backgroundColor: Colors.red,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Docentes',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Icon(Icons.video_call_rounded,
                                      color: Colors.white),
                                ],
                              ),
                              onPressed: () {
                                String tipouser = prefs.getString('tipouser');
                                //print('Valor user: $tipouser');
                                // Acción al presionar el botón "Lista de docentes"
                                if (tipouser == "2") {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SecondScreen()),
                                  );
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        icon: Icon(
                                          Icons.error_outline,
                                          color:
                                              Color.fromARGB(255, 255, 109, 5),
                                          size: 50,
                                        ),
                                        title: Text(
                                          'Perfil incorrecto',
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 255, 109, 5),
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        content: Text(
                                            'Contactese con Soporte para que actualicen su acceso'),
                                        actions: [
                                          TextButton(
                                            child: Text('Cerrar'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      /* SizedBox(height: 20),
                      Container(
                        width: 200.0,
                        height: 50.0,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            elevation: 5,
                            shadowColor: Colors.grey,
                            backgroundColor: Color.fromARGB(255, 54, 133, 244),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Lista de temas!',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Icon(Icons.book, color: Colors.white),
                            ],
                          ),
                          onPressed: () {
                            // Acción al presionar el botón "Lista de docentes"
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ThemeScreen(),
                              ),
                            );
                          },
                        ),
                      ), */
                      SizedBox(height: 30),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: GridView.count(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10.0,
                            crossAxisSpacing: 10.0,
                            childAspectRatio: 1.0,
                            padding: EdgeInsets.all(10.0),
                            children: [
                              Card(
                                elevation: 5,
                                color: Color.fromARGB(255, 255, 255, 255),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.book,
                                      size: 50,
                                      color: Color.fromARGB(255, 12, 124, 215),
                                    ),
                                    SizedBox(height: 10),
                                    Text('GRAMMAR'),
                                  ],
                                ),
                              ),
                              Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.home,
                                      size: 50,
                                      color: Color.fromARGB(255, 6, 188, 79),
                                    ),
                                    SizedBox(height: 10),
                                    Text('EXAM'),
                                  ],
                                ),
                              ),
                              Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.book,
                                      size: 50,
                                      color: Color.fromARGB(255, 12, 124, 215),
                                    ),
                                    SizedBox(height: 10),
                                    Text('VOCABULARY'),
                                  ],
                                ),
                              ),
                              Card(
                                elevation: 5,
                                color: Color.fromARGB(255, 255, 255, 255),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ListGame(),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.gamepad,
                                        size: 50,
                                        color:
                                            Color.fromARGB(255, 217, 111, 215),
                                      ),
                                      SizedBox(height: 10),
                                      Text('GAME'),
                                    ],
                                  ),
                                ),
                              ),
                              // Aquí irían más cards con sus respectivos iconos y títulos
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/* class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Segunda pantalla'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('Lista de docentes de inglés'),
            SizedBox(height: 20),
            ListView(
              shrinkWrap: true,
              children: [
                ListTile(
                  title: Text('Elemento 1 de la lista'),
                ),
                ListTile(
                  title: Text('Elemento 2 de la lista'),
                ),
                ListTile(
                  title: Text('Elemento 3 de la lista'),
                ),
              ],
            ),
            ElevatedButton(
              child: Text('Vuelve a la pantalla anterior'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
} */

// esto la pantalla2(lista de temas)
class ThemeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pantalla Temas'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('Lista de temas de inglés'),
            SizedBox(height: 20),
            ListView(
              shrinkWrap: true,
              children: [
                ListTile(
                  title: Text('Elemento 1 de la lista'),
                ),
                ListTile(
                  title: Text('Elemento 2 de la lista'),
                ),
                ListTile(
                  title: Text('Elemento 3 de la lista'),
                ),
              ],
            ),
            ElevatedButton(
              child: Text('Vuelve a la pantalla anterior'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
