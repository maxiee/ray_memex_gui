import 'package:flutter/material.dart';
import 'package:ray_memex_gui/book/tools/pdf_cover/pdf_cover_page.dart';

class BookToolsTab extends StatelessWidget {
  const BookToolsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        MaterialButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const PdfCoverPage(),
                )),
            child: const Text('PDF封面提取')),
      ],
    );
  }
}
