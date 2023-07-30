import 'package:flutter/material.dart';
import 'package:ray_memex_gui/api/api_book.dart';
import 'package:ray_memex_gui/api/api_image.dart';
import 'package:ray_memex_gui/widgets/form.dart';

class BookEditPage extends StatefulWidget {
  const BookEditPage({super.key});

  @override
  State<BookEditPage> createState() => _BookEditPageState();
}

class _BookEditPageState extends State<BookEditPage> {
  final ctxId = TextEditingController();
  final ctlTitle = TextEditingController();
  final ctlAuthor = TextEditingController();
  final ctlPublisher = TextEditingController();
  final ctlPublishYear = TextEditingController();
  final ctlFormat = TextEditingController();
  final ctlSize = TextEditingController();
  final ctlDescription = TextEditingController();

  late Map<String, dynamic> bookInfo = {};

  @override
  void initState() {
    super.initState();
  }

  void onSave() {
    double size = double.parse(ctlSize.text);
    assert(size > 0);

    int? publishYear;
    if (ctlPublishYear.text.isNotEmpty) {
      publishYear = int.parse(ctlPublishYear.text);
    }

    ApiBook.updateBookInfo({
      'id': bookInfo['id'],
      'title': ctlTitle.text,
      'author': ctlAuthor.text,
      'publisher': ctlPublisher.text,
      'publish_year': publishYear,
      'description': ctlDescription.text,
      'format': ctlFormat.text,
      'size': size,
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Book info updated successfully!'),
        ),
      );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    String bookId = ModalRoute.of(context)!.settings.arguments as String;
    ApiBook.getBookInfo(bookId).then((value) {
      setState(() {
        bookInfo = value;
        ctxId.text = bookInfo['id'];
        ctlTitle.text = bookInfo['title'];
        ctlAuthor.text = bookInfo['author'];
        ctlPublisher.text = bookInfo['publisher'] ?? '';
        ctlPublishYear.text = bookInfo['publish_year']?.toString() ?? '';
        ctlDescription.text = bookInfo['description'] ?? '';
        ctlFormat.text = bookInfo['format'] ?? '';
        ctlSize.text = bookInfo['size'].toString();
      });
    });
  }

  void requestBookSize() {
    ApiBook.bookSize(bookInfo['id']).then((value) {
      print('size=$value');
      setState(() {
        bookInfo['size'] = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("编辑书籍元信息")),
        body: bookInfo.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Flexible(
                          fit: FlexFit.loose,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              formItem("ID：", ctxId, bookInfo['id'],
                                  editable: false),
                              const SizedBox(height: 8),
                              formItem("书名：", ctlTitle, bookInfo['title']),
                              const SizedBox(height: 8),
                              formItem("作者：", ctlAuthor, bookInfo['author']),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Image.network(
                            ApiImage.getImage(bookInfo['id'] + '.png'),
                            width: 120,
                            fit: BoxFit.fitHeight,
                          ),
                        )
                      ]),
                      const SizedBox(height: 8),
                      formItem(
                          "出版社：", ctlPublisher, bookInfo['publisher'] ?? ''),
                      const SizedBox(height: 8),
                      formItem("出版年：", ctlPublishYear,
                          bookInfo['publish_year']?.toString() ?? ''),
                      const SizedBox(height: 8),
                      formItem(
                          "描述：", ctlDescription, bookInfo['description'] ?? '',
                          minLines: 4, maxLines: 8),
                      const SizedBox(height: 8),
                      formItem("格式：", ctlFormat, bookInfo['format'] ?? ''),
                      const SizedBox(height: 8),
                      formItem("大小", ctlSize, bookInfo['size'].toString(),
                          editable: false,
                          suffixIcon: IconButton(
                            onPressed: () => requestBookSize(),
                            icon: const Icon(Icons.refresh),
                          )),
                    ],
                  ),
                ]),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => onSave(),
          tooltip: '保存',
          child: const Icon(Icons.save),
        ));
  }
}
