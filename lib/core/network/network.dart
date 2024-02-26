import 'package:ava_hesab/core/database/boxes.dart';
import 'package:ava_hesab/core/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class NetworkClient {
  NetworkClient._internal();

  static final _singleton = NetworkClient._internal();

  factory NetworkClient() => _singleton;

  static Dio _createDio() {
    final authBox = HiveBoxes.getAuthBox();
    final String? token = authBox.get('authBox')?.token;
    Dio dio = Dio(
      BaseOptions(
        baseUrl: Constants.baseUrl,
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'Authorization=$token',
        },
      ),
    );

    // Pretty Dio Logger
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );

    return dio;
  }

  Future<Response> postRequest(String endPoint, {required Map<String, dynamic> variables}) async {
    final dio = _createDio();
    final request = await dio.post(
      endPoint,
      data: variables,
    );

    return request;
  }

  Future<Response> getRequest(String endPoint, {required Map<String, dynamic> variables}) async {
    final dio = _createDio();
    final request = await dio.get(
      endPoint,
      data: variables,
    );

    return request;
  }
}
