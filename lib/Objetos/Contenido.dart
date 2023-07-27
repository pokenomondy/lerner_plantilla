class Contenido {
  List<Map<String, dynamic>> contenido;

  Contenido(this.contenido);

  Map<String, dynamic> toMap(){
    return{
      "contenido":contenido,
    };
  }

}