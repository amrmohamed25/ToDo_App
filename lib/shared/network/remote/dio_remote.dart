import 'package:dio/dio.dart';

class DioHelper {
  static late Dio dio;

  //https://newsapi.org/v2/top-headlines?country=eg&category=business&apiKey=b1b94dcee3984948801fddb3917ea7e2

  static init() {
    dio = Dio(BaseOptions(
        baseUrl: 'https://newsapi.org',
        receiveDataWhenStatusError: true));
    // 'https://newsapi.org';
    // 'https://student.valuxapps.com/api/';
  }

  static Future<Response> getData(
      {required String url,
      Map<String, dynamic>? query,
      String lang = 'en',
      String? token}) async {
    dio.options.headers = {
      'lang': lang,
      'Authorization': token ?? '',
      'Content-Type': 'application/json',
    };
    return await dio.get(url, queryParameters: query);
  }

  static Future<Response> postData(
      {required String url,
      Map<String, dynamic>? query,
      required dynamic data,
      String lang = 'en',
      String? token}) async {
    dio.options.headers = {
      'lang': lang,
      'Authorization': token ?? '',
      'Content-Type': 'application/json',
    };
    return await dio.post(url, data: data);
  }

  static Future<Response> putData(
      {required String url,
        Map<String, dynamic>? query,
        required dynamic data,
        String lang = 'en',
        String? token}) async {
    dio.options.headers = {
      'lang': lang,
      'Authorization': token ?? '',
      'Content-Type': 'application/json',
    };
    return await dio.put(url, data: data);
  }
}
