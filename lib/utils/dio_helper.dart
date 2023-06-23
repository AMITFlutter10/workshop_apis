import 'package:dio/dio.dart';
import 'package:workshop_apis/utils/end_points.dart';

class DioHelper {
  static late Dio dio;

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
      ),
    );
  }
}
