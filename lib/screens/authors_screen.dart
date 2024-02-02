import 'package:flutter/material.dart';
import 'package:my_lib/models/models.dart';

class AuthorsScreen extends StatefulWidget {
  const AuthorsScreen({super.key});

  @override
  State<AuthorsScreen> createState() => _AuthorsScreenState();
}

class _AuthorsScreenState extends State<AuthorsScreen> {
  List<Author> authors = []; //будем выбирать айтемы в этом листа
  loadData() async //функция загружающая их
  {
    authors =
        await Author().select().toList(); //преобразование всех айтемов в лист
    setState(() {}); //set state необходим после внсения изменений
  }

  @override
  void initState() {
    loadData(); //загрузка списка при запуске
    super.initState();
  }

  authorAdd(String newName) async {
    Author authorToAdd = Author();
    authorToAdd.name = newName;
    authorToAdd.isInactive = false;
    await authorToAdd.save();
    loadData();
  }

  showToAddDialog() {
    String myName = "";
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Добавить автора"),
        content: TextField(

          onChanged: (value) => myName = value,
        ),
        actions: <Widget>[
          ElevatedButton(
              onPressed: () async {
                if(myName.isEmpty) {
                  return;
                }
                else {
                  authorAdd(myName);
                }
                Navigator.pop(context);
              },
              child: Text("Добавить"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: Text("Авторы"),
          centerTitle: true,
          toolbarHeight: 50,
          actions: [
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                await Author().select().isInactive.equals(true).delete();
                loadData();
              },
            )
          ],
        ),
        floatingActionButton: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.black),
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: IconButton(
                onPressed: showToAddDialog,
                icon: Icon(Icons.add)
            )
        ),
        body: ListView.builder(
            itemCount: authors.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(authors[index].name ?? ""),
                trailing: authors[index].isInactive == true
                    ? Icon(Icons.check_box)
                    : Icon(Icons.check_box_outline_blank),
                onTap: () async {
                  authors[index].isInactive = !authors[index].isInactive!;
                  await authors[index].save();
                  loadData();
                },
              );
            })
    );
  }
}
