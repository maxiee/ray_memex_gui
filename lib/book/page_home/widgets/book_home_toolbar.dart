import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ray_memex_gui/book/page_home/book_home_model.dart';

class BookHomeToolbar extends StatelessWidget {
  const BookHomeToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BookHomeModel>(
      builder: (context, model, child) => Row(
        children: [
          if (model.mode == MODE_LIST)
            IconButton(
              icon: const Icon(Icons.grid_3x3),
              onPressed: () {
                model.mode = MODE_GRID;
                model.notifyListeners();
              },
            ),
          if (model.mode == MODE_GRID)
            IconButton(
              icon: const Icon(Icons.list),
              onPressed: () {
                model.mode = MODE_LIST;
                model.notifyListeners();
              },
            ),
        ],
      ),
    );
  }
}
