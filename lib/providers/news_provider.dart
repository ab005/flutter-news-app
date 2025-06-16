import 'package:flutter/material.dart';
import 'package:news_app/models/article.dart';
import 'package:news_app/services/news_api_service.dart';

class NewsProvider extends ChangeNotifier {
  final NewsApiService _newsApiService = NewsApiService();
  List<Article> _articles = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Article> get articles => _articles;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchTopHeadlines() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _articles = await _newsApiService.getTopHeadlines();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchNews(String query) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _articles = await _newsApiService.searchNews(query);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}