class Article {
  final String? title;
  final String? description;
  final String? urlToImage;
  final String? url;
  final String? sourceName;
  final DateTime? publishedAt;
  final String? content;

  Article({
    this.title,
    this.description,
    this.urlToImage,
    this.url,
    this.sourceName,
    this.publishedAt,
    this.content,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'],
      description: json['description'],
      urlToImage: json['urlToImage'],
      url: json['url'],
      sourceName: json['source'] != null ? json['source']['name'] : 'Unknown',
      publishedAt: json['publishedAt'] != null
          ? DateTime.parse(json['publishedAt'])
          : null,
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'urlToImage': urlToImage,
      'url': url,
      'sourceName': sourceName,
      'publishedAt': publishedAt?.toIso8601String(),
      'content': content,
    };
  }
}