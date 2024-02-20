import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class RequestResource {
  static String _serverUrl = "";

  static Future<void> initialize() async {
    await dotenv.load(
      fileName: 'environments/.env',
    );
    _serverUrl = dotenv.env['SERVEUR_URL'] ?? "";
  }

  static String get baseUrl =>
      _serverUrl.isNotEmpty ? _serverUrl : "https://metatubeapi.onrender.com/";

  static const String REGISTER = "auth/register";
  static const String LOGIN = "auth/login";
  static const String VIDEO = "video";
  static const String USER = "user";
}

class RequestHelper {
  static const String POSTS = "posts";

  static Future<http.Response> fetchPosts() async {
    final url = '${RequestResource.baseUrl}$POSTS';
    try {
      return await http.get(Uri.parse(url));
    } catch (e) {
      print('Error fetching posts: $e');
      throw e;
    }
  }
}
