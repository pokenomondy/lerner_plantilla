class SubTemas {
  String nombreSubTema = "";
  int ordenSubtema = 1;

  SubTemas(this.nombreSubTema,this.ordenSubtema);

  Map<String, dynamic> toMap(){
    return{
      "nombreSubTema":nombreSubTema,
      "ordenSubtema":ordenSubtema,
    };
  }

}