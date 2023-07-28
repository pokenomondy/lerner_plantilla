class Contenido {
  List<Map<String, dynamic>> contenido;

  Contenido(this.contenido);

  Map<String, dynamic> toMap(){
    return{
      "contenido":contenido,
    };
  }

  // Método estático para convertir un mapa JSON en una instancia de Contenido
  static Contenido fromJson(Map<String, dynamic> json) {
    List<dynamic> contenidoDataJson = json['contenidoData'];
    List<Map<String, dynamic>> contenidoData =
    contenidoDataJson.cast<Map<String, dynamic>>();

    return Contenido(contenidoData);
  }

  // Método para convertir la instancia de Contenido a un mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'contenidoData': contenido,
    };
  }

}