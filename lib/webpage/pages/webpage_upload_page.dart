import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ray_memex_gui/api/api_webpage.dart';
import 'package:ray_memex_gui/webpage/home/webpage_home_model.dart';
import 'package:ray_memex_gui/widgets/form.dart';
import 'package:url_launcher/url_launcher.dart';

class WebPageUploadPage extends StatefulWidget {
  const WebPageUploadPage({super.key});

  @override
  State<WebPageUploadPage> createState() => _WebPageUploadPageState();
}

class _WebPageUploadPageState extends State<WebPageUploadPage> {
  final ctxTitle = TextEditingController();
  final ctxUrl = TextEditingController();
  final ctxFilePath = TextEditingController();
  final ctxExtension = TextEditingController();
  final ctxSize = TextEditingController();
  final ctxSite = TextEditingController();

  String? latestDownloadedFile;
  late String url;

  @override
  initState() {
    super.initState();
    _getLatestDownloadedFile();
  }

  Future<void> onSave() async {
    String id = await ApiWebpage.uploadWebpageFile(latestDownloadedFile!);
    print('id: $id');
    await ApiWebpage.uploadWebpageMeta({
      'id': id,
      'title': ctxTitle.text,
      'url': ctxUrl.text,
      'format': ctxExtension.text,
      'size': getSizeInMBfromFile(),
      'site': ctxSite.text,
    });
    if (mounted) {
      WebpageHomeModel model =
          ModalRoute.of(context)!.settings.arguments! as WebpageHomeModel;
      await model.relaod();
      Navigator.pop(context);
    }
  }

  /// 函数：读取 Downloads 目录下的最新的一个文件
  Future<void> _getLatestDownloadedFile() async {
    final downloadsPath = await getDownloadsDirectory();

    if (downloadsPath == null) {
      return;
    }

    List<FileSystemEntity> files = downloadsPath.listSync();
    files
        .sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));

    setState(() {
      latestDownloadedFile = files.first.path;
      url = getUrlFromFile();
    });
  }

  bool isPostfixValid() {
    if (latestDownloadedFile == null) {
      return false;
    }

    final postfix = p.extension(latestDownloadedFile!);
    return postfix == '.html' || postfix == '.htm';
  }

  String getTitleFromFile() {
    if (latestDownloadedFile == null) {
      return '';
    }

    final file = File(latestDownloadedFile!);
    final content = file.readAsStringSync();
    final title = RegExp(r'<title>(.*)</title>').firstMatch(content)?.group(1);
    return title ?? '';
  }

  /// 从网页文件中的 <meta name="savepage-url" content="https://weibo.com/2194035935/NbUCiwU6Y"> 部分提取出 url
  String getUrlFromFile() {
    if (latestDownloadedFile == null) {
      return '';
    }

    final file = File(latestDownloadedFile!);
    final content = file.readAsStringSync();
    final url = RegExp(r'<meta name="savepage-url" content="(.*)">')
        .firstMatch(content)
        ?.group(1);
    return url ?? '';
  }

  /// 从 url 中提取出域名，不带 www，举例，https://weibo.com/2194035935/NbUCiwU6Y 返回 weibo.com
  String getDomainFromUrl() {
    final uri = Uri.parse(url);
    final domain = uri.host;
    return domain.startsWith('www.') ? domain.substring(4) : domain;
  }

  // 获取文件后缀，举例，.html 返回 html
  String getExtensionFromFile() {
    if (latestDownloadedFile == null) {
      return '';
    }

    final postfix = p.extension(latestDownloadedFile!);
    return postfix.substring(1);
  }

  double getSizeInMBfromFile() {
    if (latestDownloadedFile == null) {
      return -1;
    }

    final file = File(latestDownloadedFile!);
    final size = file.statSync().size;
    return double.parse((size / 1000.0 / 1000.0).toStringAsFixed(2));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('上传归档网页'),
        ),
        body: latestDownloadedFile == null
            ? const Center(child: CircularProgressIndicator())
            : !isPostfixValid()
                ? Center(
                    child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('不支持的文件类型'),
                      Text(latestDownloadedFile ?? '')
                    ],
                  ))
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        formItem('标题', ctxTitle, getTitleFromFile()),
                        const SizedBox(height: 8),
                        formItem("Url", ctxUrl, url),
                        const SizedBox(height: 8),
                        formItem('站点', ctxSite, getDomainFromUrl(),
                            editable: false),
                        const SizedBox(height: 8),
                        formItem('文件后缀', ctxExtension, getExtensionFromFile(),
                            editable: false),
                        const SizedBox(height: 8),
                        formItem("大小", ctxSize,
                            '${getSizeInMBfromFile().toStringAsFixed(2)} MB',
                            editable: false),
                        const SizedBox(height: 8),
                        formItem('本地路径', ctxFilePath, latestDownloadedFile!,
                            editable: false),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MaterialButton(
                                onPressed: () => _getLatestDownloadedFile(),
                                child: const Text('刷新')),
                            MaterialButton(
                                onPressed: () =>
                                    launchUrl(Uri.file(latestDownloadedFile!)),
                                child: const Text('打开文件')),
                          ],
                        )
                      ],
                    ),
                  ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => onSave(),
          tooltip: '提交',
          child: const Icon(Icons.save),
        ));
  }
}
