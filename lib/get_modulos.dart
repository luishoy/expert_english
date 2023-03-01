import 'dart:convert'; // importación de la librería para convertir datos a JSON
import 'package:dio/dio.dart'; // importación de la librería para hacer peticiones HTTP

Future<List<Modulo>> fetchModulos() async {
  try {
    final response = await Dio().get(
      'http://192.168.0.103/ingles/cursos_online/Api_functions/get_modulos',
      //options: Options(headers: {'Accept': 'application/json'}),
    );
    // Se realiza una petición GET a la URL indicada
    //print(response.data);
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.data.toString());
      // Se convierte la respuesta a un mapa de datos
      List<Modulo> modulos = [];
      for (var modulo in jsonResponse) {
        List<SubMenu> subMenus = await fetchSubMenus(modulo['modo_id']);
        Modulo newModulo = Modulo.fromJson(modulo);
        newModulo.subMenus = subMenus;
        modulos.add(newModulo);
      }
      // Se recorre la lista de datos y se convierten a objetos Modulo
      return modulos;
    } else {
      throw Exception('Failed to load modulos');
    }
  } catch (e) {
    print(e); // línea agregada para imprimir el error especifico en la consola
    throw Exception('Failed to load modulossssss');
  }
}

Future<List<SubMenu>> fetchSubMenus(int idModulo) async {
  try {
    final response = await Dio().get(
      'http://192.168.0.103/ingles/cursos_online/Api_functions/get_submenus?id_modulo=$idModulo',
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.data.toString());
      List<SubMenu> subMenus = [];
      for (var subMenu in jsonResponse) {
        subMenus.add(SubMenu.fromJson(subMenu));
      }
      return subMenus;
    } else {
      throw Exception('Failed to load submenus');
    }
  } catch (e) {
    print(e);
    throw Exception('Failed to load submenus');
  }
}

class Modulo {
  final int id;
  final String nombre;

  List<SubMenu> subMenus; // Agregar la lista de submenus como propiedad

  Modulo(
      {this.id = 0,
      this.nombre,
      this.subMenus}); // Agregar el argumento subMenus al constructor

  set setSubMenus(List<SubMenu> subMenus) {
    // Agregar el setter setSubMenus
    this.subMenus = subMenus;
  }

  factory Modulo.fromJson(Map<String, dynamic> json) {
    return Modulo(
      id: int.parse(json['modo_id']), // Se convierte el id a un entero
      nombre: json['modo_title'],
    );
  }
}

class SubMenu {
  final int id;
  final String nombre;
  final String url;

  SubMenu({this.id = 0, this.nombre, this.url});

  factory SubMenu.fromJson(Map<String, dynamic> json) {
    return SubMenu(
      //id: json['modo_id'],
      id: int.parse(json['modo_id']), // Se convierte el id a un entero
      nombre: json['modo_title'],
      url: json['modo_link'],
    );
  }
}
