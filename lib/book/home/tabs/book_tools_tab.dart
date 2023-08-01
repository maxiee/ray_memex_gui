import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ray_memex_gui/book/home/book_home_model.dart';
import 'package:ray_memex_gui/book/pages/pdf_cover_page.dart';

class BookToolsTab extends StatelessWidget {
  const BookToolsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BookHomeModel>(
        builder: (context, model, child) => Wrap(
              children: [
                MaterialButton(
                    onPressed: () =>
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const PdfCoverPage(),
                        )),
                    child: const Text('PDF封面提取')),
              ],
            ));
  }
}
