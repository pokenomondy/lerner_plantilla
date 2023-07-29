import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lerner_plantilla/Pages/Dashboard.dart';
import 'package:lerner_plantilla/Pages/Temario.dart';
import 'package:lerner_plantilla/Pages/wait_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      initialRoute: "/home",
            routes: {
        '/': (context) => const WaitScreenBuild(),
        '/home': (context) => const Dashboard(),
        '/home/temario': (context) => Temario(),
      }, onUnknownRoute: (RouteSettings settings){
        return MaterialPageRoute(
            builder: (context) => const WaitScreenBuild()
        );
    },

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  //variables
  final db = FirebaseFirestore.instance; //inicializar firebase
  List<Temas> temasList = [];

  @override
  void initState() {
    super.initState();
    obtenerTemasDesdeFirebase();
  }


  Future obtenerTemasDesdeFirebase() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool datosDescargados = prefs.getBool('datos_descargados_listatemas') ??
        false;
    if (!datosDescargados) {
      print("Los datos apenas se van a descargar, priemra vez");
      CollectionReference referenceTemas = FirebaseFirestore.instance
          .collection("MATERIAS").doc(Config.Tema_app).collection("TEMAS");
      QuerySnapshot queryTemas = await referenceTemas.get();

      for (var temaDoc in queryTemas.docs) {
        String nombreTema = temaDoc['nombre Tema'];
        int ordenTema = temaDoc['Orden tema'];
        print("$ordenTema $nombreTema");

        //Ahora metemos subtemas para crear la lista y guardar
        QuerySnapshot subtemasDocs = await temaDoc.reference.collection(
            'SUBTEMAS').get();
        List<SubTemas> subtemasList = [];
        for (var subtemaDoc in subtemasDocs.docs) {
          String nombreSubTema = subtemaDoc['nombreSubTema']; // Suponiendo que 'nombreSubTema' es el campo que contiene el nombre del subtema
          int ordenSubtema = subtemaDoc['ordenSubtema'];
          print("$ordenSubtema $nombreSubTema");

          //Ahora cargamos el contenido
          QuerySnapshot contenidoDocs = await subtemaDoc.reference.collection(
              "CONTENIDO").get();

          List<Contenido> contenidos = [];
          List<Map<String, dynamic>> contenidoData = [];
          for (var contenidoDoc in contenidoDocs.docs) {
            final data = contenidoDoc.data() as Map<String, dynamic>;
            contenidoData =
                (data['contenido'] as List).cast<Map<String, dynamic>>();
            Contenido contenido = Contenido(contenidoData,);
            contenidos.add(contenido);
            print("contenido = $contenidoData");
          }
          //guaramos subtemas
          SubTemas subtema = SubTemas(nombreSubTema, ordenSubtema, contenidos);
          subtemasList.add(subtema);
        }

        Temas tema = Temas(nombreTema, ordenTema, subtemasList);
        temasList.add(tema);
        print("temalist $temasList");
      }
      guardardatos();
      return temasList;
    } else {
      print('ya descargados los datos, se cargan de sharedpreferences');
    }
  }

  Future guardardatos() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("se guardan datos");
    String temasJson = jsonEncode(temasList); //convertios a Json para guardar
    await prefs.setString('temas_list', temasJson); // Guardamos en shared preferecnes
    await prefs.setBool('datos_descargados_listatemas', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Dashboard()),
              );
      }, child: Text('A DASH')),
          ],
        ),
      ),
    );
  }
}
