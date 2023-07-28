import 'package:lerner_plantilla/Objetos/Contenido.dart';

class SubTemas {
  String nombreSubTema = "";
  int ordenSubtema = 1;
  List<Contenido> contenidos;


  SubTemas(this.nombreSubTema,this.ordenSubtema,this.contenidos);

  Map<String, dynamic> toMap(){
    return{
      "nombreSubTema":nombreSubTema,
      "ordenSubtema":ordenSubtema,
    };
  }

  static SubTemas fromJson(Map<String, dynamic> json) {
    String nombreSubTema = json['nombreSubTema'];
    int ordenSubtema = json['ordenSubtema'];
    List<dynamic> contenidosData = json['contenidos'];
    List<Contenido> contenidos = contenidosData.map((contenidoData) => Contenido.fromJson(contenidoData)).toList();

    return SubTemas(nombreSubTema, ordenSubtema, contenidos);
  }

  // Método para convertir la instancia de SubTemas a un mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'nombreSubTema': nombreSubTema,
      'ordenSubtema': ordenSubtema,
      'contenidos': contenidos.map((contenido) => contenido.toJson()).toList(),
    };
  }

}