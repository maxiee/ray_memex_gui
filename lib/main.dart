import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:ray_memex_gui/api/api_book.dart';
import 'package:ray_memex_gui/book/home/book_home_page.dart';
import 'package:ray_memex_gui/book/pages/book_edit_page.dart';
import 'package:ray_memex_gui/webpage/pages/webpage_upload_page.dart';
import 'package:ray_memex_gui/widgets/drop_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/book/edit': (context) => const BookEditPage(),
        '/webpage/upload': (context) => const WebPageUploadPage()
      },
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  onUploadFile(String filePath) {
    if (filePath.endsWith('.pdf')) {
      ApiBook.uploadPdf(filePath).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('File uploaded successfully!'),
          ),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unsupported file type!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DropTarget(
                onDragDone: (details) {
                  if (details.files.isNotEmpty) {
                    onUploadFile(details.files.first.path);
                  }
                },
                child: DropWidget()),
            MaterialButton(
                onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const BookHomePage(),
                      ),
                    ),
                child: const Text('书库')),
            MaterialButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed('/webpage/upload'),
                child: const Text('上传网页')),
          ],
        ),
      ),
    );
  }
}
