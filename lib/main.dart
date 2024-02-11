import 'package:flutter/material.dart';
import 'package:my_lib/models/models.dart';
import 'package:my_lib/navigation_menu.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatefulWidget {
   MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  List<Genre> genres = []; //будем выбирать айтемы в этом листа
  List<String> genresString = ["Романы", "Детективы", "Ужасы", "Фантастика", "Стихи"];

  saveData() async {
    for (int i = 0; i < genresString.length; i++) {
      final Genre genre = Genre(
        //id: i,
          name: genresString[i]
      );
      await genre.save();
    }
  }

  checkData() async {
    genres = await Genre().select().toList(); //преобразование всех айтемов в лист
    setState(() {}); //set state необходим после внсения изменений
    if (genres.isEmpty) {
      saveData();
    }
    else {
      return;
    }
  }

   @override
   void initState() {
     checkData(); //загрузка списка при запуске
     super.initState();
   }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Local Database demo app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const NavMenu(),
    );
  }
}