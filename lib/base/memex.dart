import 'dart:io';
import 'package:path/path.dart' as path;

const RAY_MEMEX_NAME = 'RayMemex';
const RAY_MEMEX_WEBPAGE_NAME = 'webpage';

abstract class RayMemex {
  static String memexHome() {
    String home = path.join(_homeDirectory(), RAY_MEMEX_NAME);
    if (!Directory(home).existsSync()) {
      Directory(home).createSync(recursive: true);
    }
    return home;
  }

  static String memexWebpage() {
    String webpage = path.join(memexHome(), RAY_MEMEX_WEBPAGE_NAME);
    if (!Directory(webpage).existsSync()) {
      Directory(webpage).createSync(recursive: true);
    }
    return webpage;
  }

  static String _homeDirectory() {
    return Platform.environment['HOME']!;
  }
}
