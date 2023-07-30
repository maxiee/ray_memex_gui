import 'package:context_menus/context_menus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ray_memex_gui/webpage/home/tabs/webpage_tools_tab.dart';
import 'package:ray_memex_gui/webpage/home/tabs/webpages_tab.dart';
import 'package:ray_memex_gui/webpage/home/webpage_home_model.dart';

class WebpageHomePage extends StatefulWidget {
  const WebpageHomePage({super.key});

  @override
  State<WebpageHomePage> createState() => _WebpageHomePageState();
}

class _WebpageHomePageState extends State<WebpageHomePage> {
  int _selectedIndex = 0; // 底部导航栏当前选中项的索引
  WebpageHomeModel model = WebpageHomeModel();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: model,
        builder: (context, child) => Scaffold(
            appBar: AppBar(title: const Text("归档网页库")),
            body: ContextMenuOverlay(
              child: Stack(children: [
                if (_selectedIndex == 0) const WebpagesTab(),
                if (_selectedIndex == 1) const WebpageToolsTab()
              ]),
            ),
            bottomNavigationBar: BottomNavigationBar(items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                label: '网页列表',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.grid_3x3),
                label: '工具箱',
              ),
            ], currentIndex: _selectedIndex, onTap: _onItemTapped)));
  }

  void _onItemTapped(int index) {
    // 当点击底部导航栏的某一项时，更新选中项的索引
    setState(() {
      _selectedIndex = index;
    });
  }
}
