import 'package:flutter/material.dart';

class PdfCoverPage extends StatefulWidget {
  const PdfCoverPage({super.key});

  @override
  State<PdfCoverPage> createState() => _PdfCoverPageState();
}

class _PdfCoverPageState extends State<PdfCoverPage> {
  TextEditingController textController = TextEditingController();
  TextEditingController pageController = TextEditingController(text: '0');
  String? previewUrl;

  String genUrl(fileName, previewPage) {
    return 'http://localhost:9003/book/pdf/cover/preview?file_name=$fileName&page=$previewPage';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PDF封面提取工具")),
      body: Column(children: [
        const SizedBox(height: 20),
        TextField(
          controller: textController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'PDF文件名称',
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: pageController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: '封面页码',
          ),
        ),
        MaterialButton(
            onPressed: () {
              if (textController.text.isNotEmpty) {
                setState(() {
                  previewUrl = genUrl(
                      textController.text, int.parse(pageController.text));
                });
              }
            },
            child: const Text('预览')),
        if (previewUrl != null) ...[
          const SizedBox(height: 20),
          Image.network(previewUrl!, height: 300, fit: BoxFit.fitHeight)
        ]
      ]),
    );
  }
}
