import 'package:flutter/material.dart';
import 'package:ray_memex_gui/api/api_webpage.dart';

class WebpageHomeModel extends ChangeNotifier {
  // 网页列表及分页加载
  int currentPage = 1;
  List<Map<String, dynamic>> webpageList = [];

  Future<void> loadWebpageList() async {
    webpageList.addAll(await ApiWebpage.webpageList(currentPage, 10));
    notifyListeners();
  }
}
