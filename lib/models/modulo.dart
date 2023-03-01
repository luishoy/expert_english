class Modulo {
  final int id;
  final String nombre;
  /* 
  final String descripcion;
  final String imagenUrl; */

  Modulo({this.id = 0, this.nombre});
  //Modulo({this.id, this.nombre, this.descripcion, this.imagenUrl});

  factory Modulo.fromJson(Map<String, dynamic> json) {
    return Modulo(
      id: json['id'],
      nombre: json['nombre'],
      /* 
      descripcion: json['descripcion'],
      imagenUrl: json['imagenUrl'], */
    );
  }
}
