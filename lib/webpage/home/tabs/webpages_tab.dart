import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ray_memex_gui/webpage/home/webpage_home_model.dart';

class WebpagesTab extends StatefulWidget {
  const WebpagesTab({super.key});

  @override
  State<WebpagesTab> createState() => _WebpagesTabState();
}

class _WebpagesTabState extends State<WebpagesTab> {
  @override
  Widget build(BuildContext context) {
    return Consumer<WebpageHomeModel>(
      builder: (context, model, child) => ListView.builder(
          itemCount: model.webpageList.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(model.webpageList[index]['title']),
              subtitle: Text(model.webpageList[index]['site']),
              onTap: () => null,
            );
          }),
    );
  }
}
