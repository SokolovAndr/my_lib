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

  List<Book>? books = [];

  loadData() async {
    books = await Book().select().toList(preload: true);
    setState(() {});
  }

  @override
  void initState() {
    loadData();
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
                onPressed: () async {
                  await Navigator.push<Book>(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BookScreen()));
                  loadData();
                },
                icon: const Icon(Icons.add))),
        body: ListView.builder(
            itemCount: books?.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(books?[index].title ?? ""),
                subtitle: Text(books?[index].plAuthor?.name ?? "error"),
                trailing: books?[index].isInactive == true
                    ? const Icon(Icons.check_box)
                    : const Icon(Icons.check_box_outline_blank),
                onTap: () async {
                  books?[index].isInactive = books?[index].isInactive!;
                  await books?[index].save();
                  loadData();
                },
              );
            }
        )
    );
  }
}
