import 'package:flutter_test/flutter_test.dart';
import 'package:get_github/model/github.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:get_github/services/github_service.dart';
import 'dart:convert';
import 'package:mockito/annotations.dart';

import 'github_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('GithubServiceTest', () {
    late GithubService githubService;
    late MockClient mockClient;
    String baseURL = '';

    setUp(() {
      mockClient = MockClient();
      githubService = GithubService();
      baseURL = 'https://api.github.com/search/repositories?';
    });

    test(
        'returns a list of Github repositories if the http call completes successfully',
        () async {
      // Arrange
      final responseJson = {
        'items': [
          {
            'name': 'flutter',
            'description':
                'Google’s UI toolkit for building natively compiled applications.',
            'html_url': 'https://github.com/flutter/flutter',
            'language': 'Dart',
            'stargazers_count': 123456,
            'forks_count': 7890,
            'watchers_count': 123456,
            'created_at': '2015-03-06T22:54:58Z',
            'updated_at': '2023-08-08T11:29:27Z',
            'pushed_at': '2023-08-08T10:29:27Z',
            'license': {'name': 'BSD-3-Clause'},
            'homepage': 'https://flutter.dev',
          }
        ]
      };

      when(mockClient.get(Uri.parse(baseURL))).thenAnswer(
          (_) async => http.Response(jsonEncode(responseJson), 200));

      // Act
      final result = await githubService.searchRepositories('flutter');

      // Assert
      expect(result, isA<List<Github>>());
      expect(result.length, 30);
      expect(result[0].name, 'flutter');
    });

    test('throws exception on bad request', () async {
      var client = MockClient();
      when(client.get(Uri.parse(baseURL))).thenAnswer((_) async {
        return http.Response('bad request', 404);
      });
      expect(githubService.searchRepositories(''), throwsException);
    });

    test('throws an exception when an error occurs', () async {
      // Arrange
      when(mockClient.get(any)).thenThrow(Exception('Failed to FETCH DATA'));

      // Act & Assert
      await expectLater(githubService.searchRepositories(''), throwsException);
    });
  });
}
