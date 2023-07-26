import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ray_memex_gui/api/api_image.dart';
import 'package:ray_memex_gui/book/page_home/book_home_model.dart';

class BookListTab extends StatefulWidget {
  const BookListTab({super.key});

  @override
  State<BookListTab> createState() => _BookListTabState();
}

class _BookListTabState extends State<BookListTab> {
  @override
  Widget build(BuildContext context) {
    return Consumer<BookHomeModel>(
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
          itemCount: model.bookList.length),
    );
  }
}
