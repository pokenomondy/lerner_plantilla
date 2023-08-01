class Parciales {
  String fraseparcial;
  String universidad;
  String materia;
  List<String> tema; //Lista de temas
  List<String> subtemas; //subtemas, puede tener varios, toca tenerlos identificados
  String indicedificultad;  // bajo, medio , alto

  Parciales(this.fraseparcial,this.universidad,this.materia,this.tema,this.subtemas,this.indicedificultad);

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
}