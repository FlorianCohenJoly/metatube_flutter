import 'package:flutter/material.dart';
import 'package:metatube_app/services/api_service.dart';
import 'package:metatube_app/services/sharedPreferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String username;
  late String email;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final token = await AuthHelper
        .getToken(); // Récupérez le token depuis les SharedPreferences
    if (token != null) {
      await fetchUserData(token);
    } else {
      // Gérer le cas où le token n'est pas disponible (l'utilisateur n'est pas connecté)
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchUserData(String token) async {
    final response = await http.get(
      Uri.parse('${RequestResource.baseUrl}${RequestResource.USER}'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final userData = jsonDecode(response.body);
      setState(() {
        username = userData['username'];
        email = userData['email'];
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load user data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    'Email: ${email ?? 'Loading...'}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {},
                    child: const Text('Déconnexion'),
                  ),
                ],
              ),
            ),
    );
  }
}

class AuthService {}
