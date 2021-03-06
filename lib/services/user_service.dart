import 'package:dio/dio.dart';
import 'package:sevenclass/models/login_model.dart';
import 'package:sevenclass/models/user_model.dart';

import '../app.dart';

class UserService {
  Dio dio = App().dio;

  Future<Response> isEmailRegistered(Map<String, dynamic> payload) async {
    Response response = await dio.post('user/email', data: payload);
    return response;
  }

  Future<UserModel> doRegister(Map<String, dynamic> payload) async {
    Response response = await dio.post('user/register', data: payload);
    return UserModel.fromJson(response.data);
  }

  Future<LoginModel> doLogin(Map<String, dynamic> payload) async {
    Response response = await dio.post('user/auth', data: payload);
    return LoginModel.fromJson(response.data);
  }
}