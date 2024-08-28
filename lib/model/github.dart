class Github {
  String? name;
  String? description;
  String? url;
  String? language;
  String? stars;
  String? forks;
  String? watchers;
  String? createdAt;
  String? updatedAt;
  String? pushedAt;
  String? license;
  String? homepage;
  String? topics;

  Github({
    this.name,
    this.description,
    this.url,
    this.language,
    this.stars,
    this.forks,
    this.watchers,
    this.createdAt,
    this.updatedAt,
    this.pushedAt,
    this.license,
    this.homepage,
  });

  factory Github.fromJson(Map<String, dynamic> json) {
    return Github(
      name: json['name'],
      description: json['description'],
      url: json['html_url'], // Adjusted based on GitHub API
      language: json['language'],
      stars:
          json['stargazers_count'].toString(), // Adjusted based on GitHub API
      forks: json['forks_count'].toString(), // Adjusted based on GitHub API
      watchers:
          json['watchers_count'].toString(), // Adjusted based on GitHub API
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      pushedAt: json['pushed_at'],
      license: json['license'] != null
          ? json['license']['name']
          : null, // Adjusted based on GitHub API
      homepage: json['homepage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'url': url,
      'language': language,
      'stars': stars,
      'forks': forks,
      'watchers': watchers,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'pushed_at': pushedAt,
      'license': license,
      'homepage': homepage,
    };
  }

  static List<Github> parseGithubList(List<dynamic> jsonList) {
    return jsonList.map<Github>((json) => Github.fromJson(json)).toList();
  }
}
