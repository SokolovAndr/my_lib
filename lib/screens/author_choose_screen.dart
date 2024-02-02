import 'package:flutter/material.dart';
import 'package:my_lib/models/models.dart';

class AuthorChooseScreen extends StatefulWidget {
  const AuthorChooseScreen({super.key});

  @override
  State<AuthorChooseScreen> createState() => _AuthorChooseScreenState();
}

class _AuthorChooseScreenState extends State<AuthorChooseScreen> {
  List<Author> authors = []; //будем выбирать айтемы в этом листа
  loadData() async //функция загружающая их
      {
    authors = await Author().select().toList(); //преобразование всех айтемов в лист
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
          title: Text("Выбор автора"),
          centerTitle: true,
          toolbarHeight: 50,
        ),

        body: ListView.builder(
            itemCount: authors.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(authors[index].name ?? ""),
                onTap: ()  {
                  //ЗДЕСЬ НУЖЕН КОД

                  //Navigator.pop(context, authors[index].name);
                  Navigator.pop<Author>(context, authors[index]);

                },
              );
            })
    );
  }
}
