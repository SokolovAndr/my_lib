import 'package:flutter/material.dart';
import 'package:my_lib/models/models.dart';
import 'package:my_lib/screens/author_choose_screen.dart';
import 'package:my_lib/screens/genre_choose_screen.dart';

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
    final genreNameController = TextEditingController();
    final imageController = TextEditingController();

    Author? author = Author();
    Genre? genre = Genre();

    if (widget.book != null) {
      titleController.text = widget.book!.title!;
      authorNameController.text = widget.book!.plAuthor!.name!;
      genreNameController.text = widget.book!.plGenre!.name!;
      imageController.text = widget.book!.image!;
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
                  decoration: InputDecoration(
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
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Выбранный автор: ${author!.name}" ??
                            "User doesn't press anything")));
                    authorNameController.text = author!.name.toString();
                  },
                )),
            Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: TextFormField(
                  readOnly: true,
                  controller: genreNameController,
                  textCapitalization:
                      TextCapitalization.sentences, //текст с заглавной буквы
                  maxLines: 1,
                  decoration: InputDecoration(
                      hintText: 'Жанр',
                      labelText: genre.name ?? "Название жанра",
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 0.75,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ))),
                  onTap: () async {
                    genre = await Navigator.push<Genre>(context,
                        MaterialPageRoute(builder: (context) {
                      return const GenreChooseScreen();
                    }));
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Выбранный жанр: ${genre!.name}" ??
                            "User doesn't press anything")));
                    genreNameController.text = genre!.name.toString();
                  },
                )),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: TextFormField(
                controller: imageController,
                decoration: const InputDecoration(
                    hintText: 'Изображение',
                    labelText: 'Ссылка на книгу',
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 0.75,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ))),
                keyboardType: TextInputType.multiline,
                onChanged: (str) {},
                //maxLines: 5,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: ElevatedButton(
                  onPressed: () async {
                    final myTitle = titleController.value.text;

                    final myAuthor = authorNameController.value.text;
                    final authId = await MyAppDatabaseModel().execScalar(
                        'SELECT id FROM authors WHERE name = "$myAuthor" ');

                    final myGenre = genreNameController.value.text;
                    final genreId = await MyAppDatabaseModel().execScalar(
                        'SELECT id FROM genres WHERE name = "$myGenre" ');

                    final myImage = imageController.value.text;

                    if (myTitle.isEmpty ||
                        myAuthor.isEmpty ||
                        myGenre.isEmpty ||
                        myImage.isEmpty) {
                      return;
                    }

                    final Book book = Book(
                        title: myTitle,
                        isInactive: false,
                        authorsId: author?.id = authId,
                        genresId: genre?.id = genreId,
                        image: myImage,
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
