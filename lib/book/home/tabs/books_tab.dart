import 'package:context_menus/context_menus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:ray_memex_gui/api/api_image.dart';
import 'package:ray_memex_gui/book/home/book_home_model.dart';
import 'package:ray_memex_gui/book/home/widgets/book_home_toolbar.dart';

class BooksTab extends StatefulWidget {
  const BooksTab({super.key});

  @override
  State<BooksTab> createState() => _BooksTabState();
}

Text bookTitle(String title) {
  return Text(
    title,
    overflow: TextOverflow.ellipsis,
    style: const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    ),
  );
}

class _BooksTabState extends State<BooksTab> {
  Widget getListView() => Consumer<BookHomeModel>(
      builder: (context, model, child) => PagedListView<int,
              Map<String, dynamic>>(
          pagingController: model.pagging,
          builderDelegate: PagedChildBuilderDelegate<Map<String, dynamic>>(
              itemBuilder: (context, item, index) {
                return Column(
                  children: [
                    ContextMenuRegion(
                      contextMenu: GenericContextMenu(
                        buttonConfigs: [
                          ContextMenuButtonConfig(
                            '编辑元数据',
                            onPressed: () => Navigator.of(context).pushNamed(
                                '/book/edit',
                                arguments: {'id': item['id'], 'model': model}),
                          ),
                          ContextMenuButtonConfig(
                            '拷贝id',
                            onPressed: () {
                              Clipboard.setData(
                                  ClipboardData(text: item['id']));
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
                        title: bookTitle(item['title']),
                        subtitle: Text(item['author']),
                        trailing: Image.network(
                          ApiImage.getImage(item['id'] + '.png'),
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                    // divider
                    const Divider(),
                  ],
                );
              },
              firstPageErrorIndicatorBuilder: (context) => Text('Error'),
              noItemsFoundIndicatorBuilder: (context) => Text('No Items Found'),
              newPageErrorIndicatorBuilder: (context) => Text('Error'),
              firstPageProgressIndicatorBuilder: (context) => Text('Loading'),
              newPageProgressIndicatorBuilder: (context) => Text('Loading'),
              noMoreItemsIndicatorBuilder: (context) =>
                  Text('No More Items'))));

  int getCrossAxisCount() {
    var width = MediaQuery.of(context).size.width;
    return (width / 150).floor();
  }

  Widget getGridView() => Consumer<BookHomeModel>(
      builder: (context, model, child) =>
          PagedGridView<int, Map<String, dynamic>>(
              pagingController: model.pagging,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: getCrossAxisCount(), childAspectRatio: 0.7),
              builderDelegate: PagedChildBuilderDelegate(
                itemBuilder: (context, item, index) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.network(
                            ApiImage.getImage(item['id'] + '.png'),
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        bookTitle(item['title']),
                        Text(item['author'], overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  );
                },
              )));

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
