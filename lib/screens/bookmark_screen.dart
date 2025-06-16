import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:news_app/providers/bookmark_provider.dart';
import 'package:news_app/models/article.dart';
import 'package:news_app/screens/article_detail_screen.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  String _formatDate(DateTime? date) {
    if (date == null) return 'Unknown Date';
    return DateFormat('dd MMMM, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
      ),
      body: Consumer<BookmarkProvider>(
        builder: (context, bookmarkProvider, child) {
          if (bookmarkProvider.bookmarks.isEmpty) {
            return const Center(child: Text('No bookmarked articles yet.'));
          }

          return ListView.builder(
            itemCount: bookmarkProvider.bookmarks.length,
            itemBuilder: (context, index) {
              final article = bookmarkProvider.bookmarks[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                elevation: 4.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (article.urlToImage != null)
                        CachedNetworkImage(
                          imageUrl: article.urlToImage!,
                          placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                          width: double.infinity,
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      const SizedBox(height: 8.0),
                      Text(
                        article.title ?? 'No Title',
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        article.description ?? 'No Description',
                        style: const TextStyle(fontSize: 14.0),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            article.sourceName ?? 'Unknown Source',
                            style: const TextStyle(fontSize: 12.0, color: Colors.grey),
                          ),
                          Text(
                            _formatDate(article.publishedAt),
                            style: const TextStyle(fontSize: 12.0, color: Colors.grey),
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          icon: const Icon(Icons.bookmark),
                          color: Colors.blue,
                          onPressed: () {
                            bookmarkProvider.removeBookmark(article);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Removed from bookmarks')),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}