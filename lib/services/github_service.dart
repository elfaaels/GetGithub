import 'dart:convert';
import 'package:get_github/model/github.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class GithubService {
  final baseURL = 'https://api.github.com/search/repositories?';

  var logger = Logger();
  Future<List<Github>> searchRepositories(String query) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.github.com/search/repositories?q=$query'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        final List<dynamic> items =
            json['items']; // This is the list of repositories
        logger.d('Data fetched successfully: $items');
        return Github.parseGithubList(items); // Parse the list of repositories
      } else {
        logger.e('Failed to load data: ${response.statusCode}');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      logger.e('Failed to FETCH DATA: $e');
      throw Exception('Failed to FETCH DATA');
    }
  }
}
