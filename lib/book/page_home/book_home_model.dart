import 'package:flutter/material.dart';
import 'package:ray_memex_gui/api/api_book.dart';

class BookHomeModel extends ChangeNotifier {
  int currentPage = 1;
  List<Map<String, dynamic>> bookList = [];

  Future<void> loadBookList() async {
    bookList.addAll(await ApiBook.bookList(currentPage, 10));
    notifyListeners();
  }
}
