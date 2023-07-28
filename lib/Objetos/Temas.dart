import 'package:lerner_plantilla/Objetos/Subtemas.dart';

class Temas {
  String nombreTema = "";
  int ordentema = 1;
  List<SubTemas> subtemas;


  Temas(this.nombreTema,this.ordentema, this.subtemas);


  Map<String, dynamic> toMap(){
    return{
      "nombre Tema":nombreTema,
      "Orden tema":ordentema,
    };
  }

  static Temas fromJson(Map<String, dynamic> json) {
    String nombreTema = json['nombreTema'];
    int ordenTema = json['ordenTema'];
    List<dynamic> subtemasData = json['subtemasList'];
    List<SubTemas> subtemasList = subtemasData.map((subtemaData) => SubTemas.fromJson(subtemaData)).toList();

    return Temas(nombreTema, ordenTema, subtemasList);
  }

  Map<String, dynamic> toJson() {
    return {
      'nombreTema': nombreTema,
      'ordenTema': ordentema,
      'subtemasList': subtemas.map((subtema) => subtema.toJson()).toList(),
    };
  }

  // Método que devuelve la longitud de la lista de temas
}

