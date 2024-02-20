import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:metatube_app/services/api_service.dart';
import 'package:metatube_app/services/sharedPreferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String username;
  late String avatar;
  late String channel;
  late List<dynamic> subscriptions;
  late List<dynamic> playlists;
  late List<dynamic> history;
  late List<dynamic> likedVideos;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final token = await AuthHelper.getToken();
    if (token != null) {
      try {
        await fetchUserData(token);
      } catch (e) {
        print('Failed to load user data: $e');
        setState(() {
          isLoading = false;
        });
      }
    } else {
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
        avatar = userData['avatar'];
        channel = userData['channel'];
        subscriptions = List<dynamic>.from(userData['subscriptions']);
        playlists = List<dynamic>.from(userData['playlists']);
        history = List<dynamic>.from(userData['history']);
        likedVideos = List<dynamic>.from(userData['likedVideos']);
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load user data: ${response.statusCode}');
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      // Mettez à jour l'avatar dans la base de données en utilisant la méthode PATCH
      await _updateAvatar(file);
    }
  }

  Future<void> _updateAvatar(File file) async {
    final token = await AuthHelper.getToken();
    if (token != null) {
      final url = '${RequestResource.baseUrl}${RequestResource.USER}';
      final headers = {
        'Content-Type': 'multipart/form-data',
        'Authorization': 'Bearer $token',
      };
      final request = http.MultipartRequest('PATCH', Uri.parse(url))
        ..headers.addAll(headers)
        ..files.add(await http.MultipartFile.fromPath('avatar', file.path));

      final response = await http.Response.fromStream(await request.send());
      if (response.statusCode == 200) {
        // Avatar updated successfully
        print('Avatar updated successfully');
        // Rechargez les données de l'utilisateur pour afficher le nouvel avatar
        await loadUserData();
      } else {
        // Handle error
        throw Exception('Failed to update avatar: ${response.statusCode}');
      }
    } else {
      // Handle error when token is null
      throw Exception('Token is null');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Username: ${username ?? 'Loading...'}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Avatar: ${avatar ?? 'Loading...'}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Channel: ${channel ?? 'Loading...'}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Subscriptions: ${subscriptions ?? 'Loading...'}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Playlists: ${playlists ?? 'Loading...'}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'History: ${history ?? 'Loading...'}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Liked Videos: ${likedVideos ?? 'Loading...'}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: const Text('Choisir un Avatar'),
                  ),
                ],
              ),
            ),
    );
  }
}
