import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:my_lib/models/models.dart';
import 'package:my_lib/screens/book_screen.dart';
import 'package:my_lib/widgets/book_widget.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  List<Book>? books = [];
  List<Genre> genres = [];

  List<String?> categories = [];
  List<String> selectedCategories = [];

  loadData() async {
    books = await Book().select().toList(preload: true);
    genres = await Genre().select().toList();
    categories = genres.map((genre) => genre.name).toList();
    setState(() {});
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final filterBooks = books!.where((book) {
      return selectedCategories.isEmpty ||
          selectedCategories.contains(book.plGenre?.name);
    }).toList();

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
      body: Column(
        children: [
          SizedBox(
            width: 400,
            height: 50,
            child: Container(
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: categories
                    .map(
                      (category) => Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: FilterChip(
                            selected: selectedCategories.contains(category),
                            label: Text(category!),
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  selectedCategories.add(category);
                                } else {
                                  selectedCategories.remove(category);
                                }
                              });
                            }),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filterBooks?.length,
              itemBuilder: (context, int index) => BookWidget(
                book: filterBooks?[index],
                onTap: () async {
                  await Navigator.push<Book>(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BookScreen(
                                book: books?[index],
                                auth: books?[index].plAuthor,
                              )));
                  loadData();
                },
                onLongPress: () async {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text(
                              'Вы уверены, что хотите удалить книгу?'),
                          actions: [
                            ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.red)),
                                onPressed: () async {
                                  await books?[index].delete();

                                  Navigator.pop(context);
                                  loadData();
                                },
                                child: const Text('Да')),
                            ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Нет'))
                          ],
                        );
                      });
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
