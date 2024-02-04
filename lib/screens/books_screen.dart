import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:my_lib/models/models.dart';
import 'package:my_lib/screens/book_screen.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {

  List<Book> books = [];
  List<Book> books2 = [];
  List<Author> authors = [];
  String nameeee = "";

  loadData() async {
    //books = await Author().plBooks;
    books = await Book().select().toList();
    //authors = await Author().select().toList();
    authors = await Author().select().toList();

    setState(() {});
  }



  /*Book? book = Book();
  Author? author = Author();

  loadData2() async {
    book = await Book().getById(1);
    author = await book?.getAuthor();
  setState(() {});
  }*/

  Book? book = Book();
  Author? author = Author();

  loadData2() async {
    book = await Book().getById(1);
    author = await book?.getAuthor();
    setState(() {});
  }


  @override
  void initState() {
    loadData();
    //loadData2();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: const Text("Книги"),
          centerTitle: true,
          toolbarHeight: 50,
          actions: [
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await Book().select().isInactive.equals(true).delete();
                loadData();
                loadData2();
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
                //onPressed: showToAddDialog,
                onPressed: () async {
                  await Navigator.push<Book>(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BookScreen()));

                  loadData();
                  loadData2();
                },
                icon: const Icon(Icons.add))),
        body: ListView.builder(
            itemCount: books.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(books[index].title ?? ""),

                subtitle: Text(books[index].authorsId.toString() ?? "error"),
                //subtitle: Text(author?.name ?? "error"),
                //subtitle: Text(books[index].plAuthor?.name ?? "error"),
                //subtitle: Text(books2[index].plAuthor!.name ?? "error"),
                //subtitle: Text(books[index].plAuthor?.name ?? "error"),
                //subtitle: Text(authors[index].name.toString() ?? "error"),
                //subtitle: Text(books[index].plAuthor?.name.toString() ?? "error"),

                trailing: books[index].isInactive == true
                    ? const Icon(Icons.check_box)
                    : const Icon(Icons.check_box_outline_blank),
                onTap: () async {
                  books[index].isInactive = !books[index].isInactive!;
                  await books[index].save();
                  loadData();
                  loadData2();
                },
              );
            }
        )
    );
  }
}
