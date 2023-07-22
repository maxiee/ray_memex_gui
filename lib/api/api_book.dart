import 'package:dio/dio.dart';

class ApiBook {
  static Future<dynamic> bookList(int page, int pageSize) async {
    final dio = Dio();
    final response =
        await dio.get('http://localhost:9003/book/list', queryParameters: {
      'page': page,
      'pageSize': pageSize,
    });
    if (response.statusCode == 200) {
      return response.data;
    } else {
      return null;
    }
  }
}
