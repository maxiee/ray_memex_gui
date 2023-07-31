import 'package:dio/dio.dart';

class ApiBook {
  static Future<dynamic> updateBookInfo(Map<String, dynamic> info) {
    final dio = Dio();
    return dio.post('http://localhost:9003/book/info/update', data: info);
  }

  static Future<Map<String, dynamic>> getBookInfo(String id) {
    final dio = Dio();
    return dio.get('http://localhost:9003/book/info/$id').then((response) {
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        return {};
      }
    });
  }

  static Future<dynamic> bookList(int key, int pageSize) async {
    final dio = Dio();
    final response =
        await dio.get('http://localhost:9003/book/list', queryParameters: {
      'key': key,
      'pageSize': pageSize,
    });
    if (response.statusCode == 200) {
      return (response.data as List)
          .map((e) => e as Map<String, dynamic>)
          .toList();
    } else {
      return null;
    }
  }

  static Future<double> bookSize(String id) async {
    final dio = Dio();
    final response = await dio.get('http://localhost:9003/book/size/$id');
    if (response.statusCode == 200) {
      return response.data as double;
    } else {
      return -1;
    }
  }

  static Future<dynamic> uploadPdf(String filePath) async {
    final dio = Dio();
    final response = await dio.post('http://localhost:9003/book/pdf/upload',
        data: FormData.fromMap({
          'file': await MultipartFile.fromFile(filePath),
        }));
    if (response.statusCode == 200) {
      return response.data;
    } else {
      return null;
    }
  }
}
