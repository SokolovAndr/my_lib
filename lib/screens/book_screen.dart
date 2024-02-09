import 'package:flutter/material.dart';
import 'package:my_lib/models/models.dart';
import 'package:my_lib/screens/author_choose_screen.dart';

class BookScreen extends StatefulWidget {
  final Book? book;
  final Author? auth;
  const BookScreen({Key? key, this.book, this.auth}) : super(key: key);

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final authorNameController = TextEditingController();
    Author? author = Author();


    if (widget.book != null) {
      titleController.text = widget.book!.title!;
      authorNameController.text = widget.book!.plAuthor!.name!;
    }



    return Scaffold(
        appBar: AppBar(
          title: Text(widget.book == null
              ? 'Добавление книги'
              : 'Редактирование книги'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: TextFormField(
                controller: titleController,
                textCapitalization:
                    TextCapitalization.sentences, //текст с заглавной буквы
                maxLines: 1,
                decoration: const InputDecoration(
                    hintText: 'Название',
                    labelText: 'Название книги',
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 0.75,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),

                child: TextFormField(
                  readOnly: true,
                  controller: authorNameController,
                  textCapitalization:
                  TextCapitalization.sentences, //текст с заглавной буквы
                  maxLines: 1,
                  decoration:  InputDecoration(
                      hintText: 'Автор',
                      labelText: author.name ?? "Имя автора",
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 0.75,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ))),
                  onTap: () async {
                    author = await Navigator.push<Author>(context,
                        MaterialPageRoute(builder: (context) {
                          return const AuthorChooseScreen();
                        }));
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(  content: Text(
                        "Выбранный автор: ${author!.name}" ??
                            "User doesn't press anything")));
                    authorNameController.text = author!.name.toString();
                  },
                )

            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: ElevatedButton(
                  onPressed: () async {
                    final myTitle = titleController.value.text;
                    final myName = authorNameController.value.text;
                    final authId = await MyAppDatabaseModel().execScalar('SELECT id FROM authors WHERE name = "$myName" ');

                    if (myTitle.isEmpty || myName.isEmpty) {
                      return;
                    }

                    final Book book = Book(
                        title: myTitle,
                        isInactive: false,
                        authorsId: author?.id = authId,
                        //authorsId: author?.id,
                        id: widget.book?.id);

                    await book.save();
                    Navigator.pop<Book>(context, book);
                  },
                  child: Text(
                    widget.book == null ? 'Добавить' : 'Редактировать',
                  )),
            )
          ]),
        ));
  }
}
