import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:ray_memex_gui/api/api_book.dart';

const int MODE_LIST = 1;
const int MODE_GRID = 2;

class BookHomeModel extends ChangeNotifier {
  // 图书列表及分页加载
  static const _pageSize = 20;
  final PagingController<int, Map<String, dynamic>> pagging =
      PagingController(firstPageKey: 1);

  BookHomeModel() {
    pagging.addPageRequestListener((pageKey) {
      loadBookList(pageKey);
    });
  }

  // 图书列表显示模式
  int mode = MODE_LIST;

  Future<void> loadBookList(int pageKey) async {
    final newItems = await ApiBook.bookList(pageKey, _pageSize);
    final isLastPage = newItems.length < _pageSize;
    if (isLastPage) {
      pagging.appendLastPage(newItems);
    } else {
      final nextPageKey = pageKey + _pageSize;
      pagging.appendPage(newItems, nextPageKey);
    }
    notifyListeners();
  }

  Future<void> relaod() async {
    pagging.refresh();
    notifyListeners();
  }
}
