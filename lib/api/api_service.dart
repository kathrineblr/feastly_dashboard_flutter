import 'package:dio/dio.dart';

import 'server_ip.dart';

class ApiService {

  final options = BaseOptions(
    baseUrl: ServerIp.baseUrl,
    connectTimeout: const Duration(seconds: 60 * 30),
    receiveTimeout: const Duration(seconds: 60 * 30),
  );
}