import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ray_memex_gui/book/page_home/book_home_model.dart';
import 'package:ray_memex_gui/book/page_home/tabs/book_list_tab.dart';

class BookHomePage extends StatefulWidget {
  const BookHomePage({super.key});

  @override
  State<BookHomePage> createState() => _BookHomePageState();
}

class _BookHomePageState extends State<BookHomePage> {
  int _selectedIndex = 0; // 底部导航栏当前选中项的索引
  int currentPage = 1;
  List<Map<String, dynamic>> bookList = [];
  BookHomeModel model = BookHomeModel();

  @override
  void initState() {
    super.initState();
    model.loadBookList();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: model,
      builder: (context, child) => Scaffold(
        appBar: AppBar(title: const Text("书库")),
        body: Stack(
          children: [if (_selectedIndex == 0) const BookListTab(), Container()],
        ),
        bottomNavigationBar: BottomNavigationBar(
          // 添加的底部导航栏
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: '图书列表',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_3x3),
              label: '工具箱',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    // 当点击底部导航栏的某一项时，更新选中项的索引
    setState(() {
      _selectedIndex = index;
    });
  }
}