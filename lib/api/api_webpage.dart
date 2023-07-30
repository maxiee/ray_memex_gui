import 'package:dio/dio.dart';

abstract class ApiWebpage {
  static Future<String> uploadWebpageFile(String filePath) async {
    final dio = Dio();
    final response = await dio.post('http://localhost:9003/webpage/upload/file',
        data: FormData.fromMap({
          'file': await MultipartFile.fromFile(filePath,
              filename: filePath.split('/').last),
        }));
    if (response.statusCode == 200) {
      return response.data as String;
    } else {
      return '';
    }
  }

  static Future<void> uploadWebpageMeta(Map<String, dynamic> page) async {
    final dio = Dio();
    final response =
        await dio.post('http://localhost:9003/webpage/upload/meta', data: page);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      return;
    }
  }
}
