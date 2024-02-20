import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:metatube_app/services/api_service.dart';

class AuthHelper {
  static const storage = FlutterSecureStorage();

  static Future<void> storeToken(String token) async {
    await storage.write(key: 'token', value: token);
  }

  static Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }

  static Future<void> deleteToken() async {
    await storage.delete(key: 'token');
  }

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }
}

class RequestHelper {
  static Future<http.Response> fetchUserData() async {
    final token = await AuthHelper.getToken();
    final response = await http.get(
      Uri.parse('${RequestResource.baseUrl}${RequestResource.LOGIN}'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to load user data');
    }
  }
}
