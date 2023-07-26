abstract class ApiImage {
  static String getImage(String fileName) =>
      'http://localhost:9003/image/$fileName';
}
