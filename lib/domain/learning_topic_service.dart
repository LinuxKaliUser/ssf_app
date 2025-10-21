import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ssf_app/data/learning_topic.dart';

class LearningTopicService {
  // Update baseUrl to your backend (use 10.0.2.2 for Android emulator)
  final String baseUrl;

  LearningTopicService({String? baseUrl})
    : baseUrl = baseUrl ?? 'http://localhost:8080';

  Uri _topicsUri() => Uri.parse('$baseUrl/api/elearning/topics');

  /// Fetch all learning topics from backend.
  /// Throws an exception on non-200 responses.
  Future<List<LearningTopic>> fetchAllTopics() async {
    final resp = await http.get(
      _topicsUri(),
      headers: {'Accept': 'application/json'},
    );

    if (resp.statusCode != 200) {
      throw Exception(
        'Failed to load topics: ${resp.statusCode} ${resp.reasonPhrase}',
      );
    }

    final List<dynamic> data = jsonDecode(resp.body) as List<dynamic>;
    return data.map((e) {
      if (e is Map<String, dynamic>) return LearningTopic.fromJson(e);
      return LearningTopic.fromJson(Map<String, dynamic>.from(e as Map));
    }).toList();
  }

  /// Fetch single topic by topicId (string id) if backend supports it.
  Future<LearningTopic?> fetchById(String topicId) async {
    final uri = Uri.parse('$baseUrl/api/elearning/topics/$topicId');
    final resp = await http.get(uri, headers: {'Accept': 'application/json'});
    if (resp.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(resp.body);
      return LearningTopic.fromJson(data);
    }
    if (resp.statusCode == 404) return null;
    throw Exception('Failed to load topic: ${resp.statusCode}');
  }
}
