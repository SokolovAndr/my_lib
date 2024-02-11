import 'package:flutter/material.dart';
import 'package:my_lib/models/models.dart';

class GenreChooseScreen extends StatefulWidget {
  const GenreChooseScreen({super.key});

  @override
  State<GenreChooseScreen> createState() => _GenreChooseScreenState();
}

class _GenreChooseScreenState extends State<GenreChooseScreen> {

  List<Genre> genres = []; //будем выбирать айтемы в этом листа
  /*List<String> genresString = ["Романы", "Детективы", "Ужасы", "Фантастика", "Стихи"];
  saveData() async {
    for (int i = 0; i < genresString.length; i++) {
      final Genre genre = Genre(
          //id: i,
          name: genresString[i]
      );
      await genre.save();
    }
  }*/

  loadData() async //функция загружающая их
  {
    //saveData();
    genres = await Genre().select().toList(); //преобразование всех айтемов в лист
    setState(() {}); //set state необходим после внсения изменений
  }

  @override
  void initState() {
    loadData(); //загрузка списка при запуске
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: const Text("Выбор жанра"),
          centerTitle: true,
          toolbarHeight: 50,
        ),
        body: ListView.builder(
            itemCount: genres.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(genres[index].name ?? ""),
                onTap: () {
                  Navigator.pop<Genre>(context, genres[index]);
                },
              );
            }));
  }
}
