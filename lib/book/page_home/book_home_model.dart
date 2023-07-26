import 'package:flutter/material.dart';
import 'package:ray_memex_gui/api/api_book.dart';

const int MODE_LIST = 1;
const int MODE_GRID = 2;

class BookHomeModel extends ChangeNotifier {
  // 图书列表及分页加载
  int currentPage = 1;
  List<Map<String, dynamic>> bookList = [];

  // 图书列表显示模式
  int mode = MODE_LIST;

  Future<void> loadBookList() async {
    bookList.addAll(await ApiBook.bookList(currentPage, 10));
    notifyListeners();
  }
}
