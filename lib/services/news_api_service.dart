import 'package:dio/dio.dart';
import 'package:news_app/models/article.dart';

class NewsApiService {
  final Dio _dio = Dio();
  final String _apiKey = 'c176d7749b65409f9811797b2b2040e6';
  final String _baseUrl = 'https://newsapi.org/v2';

  Future<List<Article>> getTopHeadlines({String country = 'us'}) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/top-headlines',
        queryParameters: {
          'country': country,
          'apiKey': _apiKey,
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> articlesJson = response.data['articles'];
        return articlesJson.map((json) => Article.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load news: $e');
    }
  }

  // Optional: Add search functionality
  Future<List<Article>> searchNews(String query) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/everything',
        queryParameters: {
          'q': query,
          'language': 'en',
          'sortBy': 'relevancy',
          'apiKey': _apiKey,
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> articlesJson = response.data['articles'];
        return articlesJson.map((json) => Article.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search news: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to search news: $e');
    }
  }
}