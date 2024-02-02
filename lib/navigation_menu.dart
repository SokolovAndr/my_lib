import 'package:flutter/material.dart';
import 'package:my_lib/screens/authors_screen.dart';
import 'package:my_lib/screens/books_screen.dart';

class NavMenu extends StatefulWidget{
  const NavMenu ({Key? key}) : super(key: key);

  @override
  State<NavMenu> createState() => _NavMenuState();

}

class _NavMenuState extends State<NavMenu>{
  int myCurrentIndex = 0;
  List pages = const [
    BooksScreen(),
    AuthorsScreen(),
  ];

  @override build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: const Text('Библиотека Flutter'),
          centerTitle: true,
        ),
        body: pages[myCurrentIndex],
        bottomNavigationBar: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 25,
                offset: const Offset(8, 20))
          ]),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BottomNavigationBar(
              backgroundColor: Colors.white,
              selectedItemColor: Colors.redAccent,
              unselectedItemColor: Colors.black,
              currentIndex: myCurrentIndex,
              showUnselectedLabels: true,
              onTap: (index) {
                setState(() {
                  myCurrentIndex = index;
                });
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.library_books), label: "Книги"),
                BottomNavigationBarItem(icon: Icon(Icons.create), label: "Авторы"),
              ],
            ),
          ),
        )
    );
  }
}