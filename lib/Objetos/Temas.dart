class Temas {
  String nombreTema = "";
  int ordentema = 1;

  Temas(this.nombreTema,this.ordentema);

  Map<String, dynamic> toMap(){
    return{
      "nombre Tema":nombreTema,
      "Orden tema":ordentema,
    };
  }

}