import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:ray_memex_gui/api/api_webpage.dart';

class WebpageHomeModel extends ChangeNotifier {
  // 网页列表及分页加载
  static const _pageSize = 20;
  final PagingController<int, Map<String, dynamic>> pagging =
      PagingController(firstPageKey: 1);

  WebpageHomeModel() {
    pagging.addPageRequestListener((pageKey) {
      loadWebpageList(pageKey);
    });
  }

  Future<void> loadWebpageList(int pageKey) async {
    final newItems = await ApiWebpage.webpageList(pageKey, _pageSize);
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
