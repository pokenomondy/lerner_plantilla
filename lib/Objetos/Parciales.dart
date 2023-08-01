import 'Contenido.dart';

class Parciales {
  String fraseparcial;
  String universidad;
  String materia;
  List<String> tema; //Lista de temas
  List<String> subtemas; //subtemas, puede tener varios, toca tenerlos identificados
  String indicedificultad;  // bajo, medio , alto
  List<Contenido> contenidos;

  Parciales(this.fraseparcial,this.universidad,this.materia,this.tema,this.subtemas,this.indicedificultad,this.contenidos);

  Map<String, dynamic> toMap(){
    return{
      "fraseparcial":fraseparcial,
      "universidad":universidad,
      "materia":materia,
      "tema":tema,
      "subtemas":subtemas,
      "indicedificultad":indicedificultad,
    };
  }

  static Parciales fromJson(Map<String, dynamic> json) {
    String fraseparcial = json['fraseparcial'];
    String universidad = json['universidad'];
    String materia = json['materia'];
    List<dynamic> temasData  = json['tema'];
    List<dynamic> subtemasData  = json['subtemas'];
    List<String> tema = List<String>.from(temasData);
    List<String> subtemas = List<String>.from(subtemasData);
    String indicedificultad = json['indicedificultad'];
    List<dynamic> contenidosData = json['contenidos'];
    List<Contenido> contenidos = contenidosData.map((contenidoData) => Contenido.fromJson(contenidoData)).toList();

    return Parciales(fraseparcial, universidad, materia,tema,subtemas,indicedificultad,contenidos);
  }

  // Método para convertir la instancia de SubTemas a un mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'fraseparcial': fraseparcial,
      'universidad': universidad,
      'materia': materia,
      'tema': tema,
      'subtemas': subtemas,
      'indicedificultad': indicedificultad,
      'contenidos': contenidos.map((contenido) => contenido.toJson()).toList(),
    };
  }
}