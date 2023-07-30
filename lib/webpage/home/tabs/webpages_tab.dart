import 'dart:io';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:ray_memex_gui/api/api_webpage.dart';
import 'package:ray_memex_gui/base/memex.dart';
import 'package:ray_memex_gui/webpage/home/webpage_home_model.dart';
import 'package:path/path.dart' as path;
import 'package:url_launcher/url_launcher.dart';

class WebpagesTab extends StatefulWidget {
  const WebpagesTab({super.key});

  @override
  State<WebpagesTab> createState() => _WebpagesTabState();
}

class _WebpagesTabState extends State<WebpagesTab> {
  void downloadWebpageAndOpen(String id) async {
    List<int> bytes = await ApiWebpage.downloadWebpageFile(id);
    String filepath = path.join(RayMemex.memexWebpage(), id);
    File file = File(filepath);
    if (!file.existsSync()) {
      await file.writeAsBytes(bytes);
    }
    await launchUrl(Uri.file(filepath));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WebpageHomeModel>(
      builder: (context, model, child) => PagedListView<int,
              Map<String, dynamic>>(
          pagingController: model.pagging,
          builderDelegate: PagedChildBuilderDelegate<Map<String, dynamic>>(
              itemBuilder: (context, item, index) => ListTile(
                    title: Text(item['title']),
                    subtitle: Text(item['site']),
                    onTap: () => downloadWebpageAndOpen(item['id']),
                  ),
              firstPageErrorIndicatorBuilder: (context) => Text('Error'),
              noItemsFoundIndicatorBuilder: (context) => Text('No Items Found'),
              newPageErrorIndicatorBuilder: (context) => Text('Error'),
              firstPageProgressIndicatorBuilder: (context) => Text('Loading'),
              newPageProgressIndicatorBuilder: (context) => Text('Loading'),
              noMoreItemsIndicatorBuilder: (context) => Text('No More Items'))),
    );
  }
}
