import 'package:flutter/material.dart';
import 'package:ray_memex_gui/api/api_book.dart';

class BookHomePage extends StatefulWidget {
  const BookHomePage({super.key});

  @override
  State<BookHomePage> createState() => _BookHomePageState();
}

class _BookHomePageState extends State<BookHomePage> {
  int currentPage = 1;
  List<Map<String, dynamic>> bookList = [];

  @override
  void initState() {
    super.initState();
    ApiBook.bookList(currentPage, 10).then((value) => setState(() {
          bookList
              .addAll((value as List).map((e) => e as Map<String, dynamic>));
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("书库")),
      body: ListView.builder(
          itemBuilder: (context, index) {
            return Column(
              children: [
                ListTile(
                  title: Text(bookList[index]['title']),
                  subtitle: Text(bookList[index]['author']),
                ),
                // divider
                const Divider(),
              ],
            );
          },
          itemCount: bookList.length),
    );
  }
}
