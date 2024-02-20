import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:metatube_app/screens/video_detail_page.dart';
import 'package:metatube_app/services/api_service.dart';

class VideoList extends StatefulWidget {
  const VideoList({Key? key}) : super(key: key);

  @override
  _VideoListState createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  late Future<List<dynamic>> _videosFuture;

  @override
  void initState() {
    super.initState();
    _videosFuture = fetchVideos();
  }

  Future<List<dynamic>> fetchVideos() async {
    final response = await http
        .get(Uri.parse('${RequestResource.baseUrl}${RequestResource.VIDEO}'));
    if (response.statusCode == 200) {
      final List<dynamic> videoData = jsonDecode(response.body);
      return videoData.map((video) {
        final String videoUrl = video['url'];
        return {
          ...video,
          'videoUrl': videoUrl,
        };
      }).toList();
    } else {
      throw Exception('Failed to load videos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _videosFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final List<dynamic> videos = snapshot.data!;
          return ListView.builder(
            itemCount: videos.length,
            itemBuilder: (context, index) {
              final video = videos[index];
              return ListTile(
                title: Text(video['title']),
                subtitle: Text(video['description']),
                leading: video['thumbnail'] != null
                    ? Image.network(
                        '${RequestResource.baseUrl}${video['thumbnail']}',
                        errorBuilder: (context, error, stackTrace) {
                          return Image.network(
                              'https://images.pexels.com/photos/842711/pexels-photo-842711.jpeg');
                        },
                      )
                    : Image.network(
                        'https://images.pexels.com/photos/842711/pexels-photo-842711.jpeg'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoDetailsPage(
                        videoId: video['_id'],
                        videoUrl: video['videoUrl'],
                      ),
                    ),
                  );
                },
              );
            },
          );
        }
      },
    );
  }
}
