import 'package:flutter/material.dart';
import 'package:my_lib/models/models.dart';
import 'package:my_lib/screens/author_choose_screen.dart';

class BookScreen extends StatefulWidget {
  final Book? book;
  const BookScreen({Key? key, this.book}) : super(key: key);

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();

    Author? auth = Author();

    return Scaffold(
        appBar: AppBar(
          title: Text('Добавление книги'),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
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
              child: ListTile(
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),

                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () async {
                  auth = await Navigator.push<Author>(
                      context,
                      MaterialPageRoute(
                          builder: (context) {
                            return const AuthorChooseScreen();
                          }));
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Выбранный автор: ${auth!.name.toString()}" ?? "User doesn't press anything")));
                },
                title: Text('Выберите автора'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: ElevatedButton(
                  onPressed: () async {
                    final title = titleController.value.text;
                    if (title.isEmpty) {
                      return;
                    }
                    final Book book = Book(
                      title: title,
                      isInactive: false,
                      authorsId: auth?.id,
                    );
                    await book.save();
                    //Navigator.pop(context);
                    //Navigator.pop<Author>(context, authors[index]);
                    Navigator.pop<Book>(context, book);
                  },
                  child: Text('Добавить')),
            )
          ]),
        ));
  }
}
