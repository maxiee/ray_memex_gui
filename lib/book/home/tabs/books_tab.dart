import 'package:context_menus/context_menus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ray_memex_gui/api/api_image.dart';
import 'package:ray_memex_gui/book/home/book_home_model.dart';
import 'package:ray_memex_gui/book/home/widgets/book_home_toolbar.dart';

class BooksTab extends StatefulWidget {
  const BooksTab({super.key});

  @override
  State<BooksTab> createState() => _BooksTabState();
}

class _BooksTabState extends State<BooksTab> {
  Widget getListView() => Consumer<BookHomeModel>(
      builder: (context, model, child) => ListView.builder(
          itemBuilder: (context, index) {
            return Column(
              children: [
                ContextMenuRegion(
                  contextMenu: GenericContextMenu(
                    buttonConfigs: [
                      ContextMenuButtonConfig(
                        '编辑元数据',
                        onPressed: () => Navigator.of(context).pushNamed(
                            '/book/edit',
                            arguments: model.bookList[index]['id']),
                      ),
                      ContextMenuButtonConfig(
                        '拷贝id',
                        onPressed: () {
                          Clipboard.setData(
                              ClipboardData(text: model.bookList[index]['id']));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('已拷贝id'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(model.bookList[index]['title']),
                    subtitle: Text(model.bookList[index]['author']),
                    trailing: Image.network(
                      ApiImage.getImage(model.bookList[index]['id'] + '.png'),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                // divider
                const Divider(),
              ],
            );
          },
          itemCount: model.bookList.length));

  int getCrossAxisCount() {
    var width = MediaQuery.of(context).size.width;
    return (width / 150).floor();
  }

  Widget getGridView() => Consumer<BookHomeModel>(
      builder: (context, model, child) => GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: getCrossAxisCount(), childAspectRatio: 0.7),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                children: [
                  Expanded(
                    child: Image.network(
                      ApiImage.getImage(model.bookList[index]['id'] + '.png'),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  Text(
                    model.bookList[index]['title'],
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(model.bookList[index]['author'],
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            );
          },
          itemCount: model.bookList.length));

  @override
  Widget build(BuildContext context) {
    return Consumer<BookHomeModel>(
        builder: (context, model, child) => Column(
              children: [
                const BookHomeToolbar(),
                if (model.mode == MODE_LIST) Expanded(child: getListView()),
                if (model.mode == MODE_GRID) Expanded(child: getGridView()),
              ],
            ));
  }
}
