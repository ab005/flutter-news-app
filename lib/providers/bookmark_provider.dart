import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:news_app/models/article.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkProvider extends ChangeNotifier {
  List<Article> _bookmarks = [];
  List<Article> get bookmarks => _bookmarks;

  BookmarkProvider() {
    loadBookmarks();
  }

  Future<void> loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? bookmarksJson = prefs.getStringList('bookmarks');
    if (bookmarksJson != null) {
      _bookmarks = bookmarksJson
          .map((jsonString) => Article.fromJson(json.decode(jsonString)))
          .toList();
    }
    notifyListeners();
  }

  Future<void> _saveBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> bookmarksJson =
    _bookmarks.map((article) => json.encode(article.toJson())).toList();
    await prefs.setStringList('bookmarks', bookmarksJson);
  }

  void addBookmark(Article article) {
    if (!isArticleBookmarked(article)) {
      _bookmarks.add(article);
      _saveBookmarks();
      notifyListeners();
    }
  }

  void removeBookmark(Article article) {
    _bookmarks.removeWhere((element) => element.url == article.url);
    _saveBookmarks();
    notifyListeners();
  }

  bool isArticleBookmarked(Article article) {
    return _bookmarks.any((element) => element.url == article.url);
  }
}