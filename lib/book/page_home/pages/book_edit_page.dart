import 'package:flutter/material.dart';
import 'package:ray_memex_gui/api/api_image.dart';

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

  late Map<String, dynamic> bookInfo;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bookInfo =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
  }

  Row formItem(String label, TextEditingController controller, String initValue,
      {editable = true,
      IconButton? suffixIcon,
      int minLines = 1,
      int maxLines = 1}) {
    controller.text = initValue;
    return Row(
      children: [
        SizedBox(width: 60, child: Text(label)),
        Flexible(
          fit: FlexFit.loose,
          child: SizedBox(
            child: TextField(
              enabled: editable,
              controller: controller,
              minLines: minLines,
              maxLines: maxLines,
              decoration: const InputDecoration(
                isDense: true,
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
        if (suffixIcon != null) suffixIcon,
      ],
    );
  }

  String parseSize(String? size) {
    if (size == null || size.isEmpty) return 'Unknown';
    return '${int.parse(size)}MB';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("编辑书籍元信息")),
      body: Padding(
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
                      formItem("ID：", ctxId, bookInfo['id'], editable: false),
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
              formItem("出版社：", ctlPublisher, bookInfo['publisher'] ?? ''),
              const SizedBox(height: 8),
              formItem("出版年：", ctlPublishYear, bookInfo['publish_year'] ?? ''),
              const SizedBox(height: 8),
              formItem("描述：", ctlDescription, bookInfo['description'] ?? '',
                  minLines: 4, maxLines: 8),
              const SizedBox(height: 8),
              formItem("格式：", ctlFormat, bookInfo['format'] ?? '',
                  editable: false),
              const SizedBox(height: 8),
              formItem("大小", ctlSize, parseSize(bookInfo['size']),
                  editable: false,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        ctlSize.text = parseSize(bookInfo['size']);
                      });
                    },
                    icon: const Icon(Icons.refresh),
                  )),
            ],
          ),
        ]),
      ),
    );
  }
}
