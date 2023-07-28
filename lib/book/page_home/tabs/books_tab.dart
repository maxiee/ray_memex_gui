import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ray_memex_gui/api/api_image.dart';
import 'package:ray_memex_gui/book/page_home/book_home_model.dart';
import 'package:ray_memex_gui/book/page_home/widgets/book_home_toolbar.dart';

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
                ListTile(
                    title: Text(model.bookList[index]['title']),
                    subtitle: Text(model.bookList[index]['author']),
                    trailing: Image.network(
                      ApiImage.getImage(model.bookList[index]['id'] + '.png'),
                      fit: BoxFit.fitHeight,
                    ),
                    onLongPress: () => showMenu(
                            context: context,
                            position: RelativeRect.fromLTRB(100, 100, 100, 200),
                            items: [
                              const PopupMenuItem(
                                value: 'copy_id',
                                child: Text('拷贝id'),
                              ),
                            ]).then((item) {
                          if (item == 'copy_id') {
                            Clipboard.setData(ClipboardData(
                                text: model.bookList[index]['id']));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('已拷贝id'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          }
                        })),
                // divider
                const Divider(),
              ],
            );
          },
          itemCount: model.bookList.length));

  int getCrossAxisCount() {
    var width = MediaQuery.of(context).size.width;
    return (width / 200).floor();
  }

  Widget getGridView() => Consumer<BookHomeModel>(
      builder: (context, model, child) => GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: getCrossAxisCount(), childAspectRatio: 0.7),
          itemBuilder: (context, index) {
            return Column(
              children: [
                Expanded(
                  child: Image.network(
                    ApiImage.getImage(model.bookList[index]['id'] + '.png'),
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Text(model.bookList[index]['title'],
                    overflow: TextOverflow.ellipsis),
                Text(model.bookList[index]['author'],
                    overflow: TextOverflow.ellipsis),
              ],
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
