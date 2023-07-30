import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ray_memex_gui/webpage/home/webpage_home_model.dart';

class WebpageToolsTab extends StatelessWidget {
  const WebpageToolsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WebpageHomeModel>(
        builder: (context, model, child) => Wrap(
              children: [
                MaterialButton(
                    onPressed: () => Navigator.of(context)
                        .pushNamed('/webpage/upload', arguments: model),
                    child: const Text("上传归档网页"))
              ],
            ));
  }
}
