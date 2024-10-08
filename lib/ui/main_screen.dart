import 'package:flutter/material.dart';
import 'package:get_github/model/github.dart';
import 'package:get_github/services/github_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _isLoading = false;
  // ignore: unused_field
  bool _isEmpty = false;
  final TextEditingController _searchController = TextEditingController();
  List<Github> _github = <Github>[];
  String? name, description, url = 'N/A';
  final GithubService _githubService = GithubService();

  get http => null;

  void _searchGithub(String query) async {
    setState(() {
      _isLoading = true;
    });

    _github = await _githubService.searchRepositories(query);

    if (_github.isEmpty) {
      setState(() {
        _isEmpty = true;
      });
    } else {
      setState(() {
        _isLoading = false;
        _isEmpty = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Get GitHub Repositories'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Loading...',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 20),
                CircularProgressIndicator(),
              ],
            ))
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search for a GitHub repository',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) => _searchGithub(value),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: _github.length,
                    itemBuilder: (context, index) {
                      final repo = _github[index];
                      return ListTile(
                        title: Text(repo.name ?? 'N/A',
                            style: const TextStyle(
                              color: Colors.black,
                            )),
                        subtitle: Text(repo.description ?? 'N/A'),
                        trailing: Text('${repo.stars} stars'),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
