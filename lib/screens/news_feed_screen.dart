import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:news_app/providers/news_provider.dart';
import 'package:news_app/providers/bookmark_provider.dart';
import 'package:news_app/models/article.dart';
import 'package:news_app/screens/article_detail_screen.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

class NewsFeedScreen extends StatefulWidget {
  const NewsFeedScreen({super.key});

  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch news when the screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NewsProvider>(context, listen: false).fetchTopHeadlines();
    });
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Unknown Date';
    return DateFormat('dd MMMM, yyyy').format(date);
  }

  Future<void> _onRefresh() async {
    await Provider.of<NewsProvider>(context, listen: false).fetchTopHeadlines();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Headlines'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: NewsSearchDelegate());
            },
          ),
        ],
      ),
      body: Consumer<NewsProvider>(
        builder: (context, newsProvider, child) {
          if (newsProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (newsProvider.errorMessage != null) {
            return Center(child: Text('Error: ${newsProvider.errorMessage}'));
          }
          if (newsProvider.articles.isEmpty) {
            return const Center(child: Text('No news available.'));
          }

          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.builder(
              itemCount: newsProvider.articles.length,
              itemBuilder: (context, index) {
                final article = newsProvider.articles[index];
                return GestureDetector(
                  onTap: () {
                    if (article.url != null) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ArticleDetailScreen(
                            article: article,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('No URL available for this article.')),
                      );
                    }
                  },
                  child: Card(
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
                            child: Consumer<BookmarkProvider>(
                              builder: (context, bookmarkProvider, child) {
                                final isBookmarked = bookmarkProvider.isArticleBookmarked(article);
                                return IconButton(
                                  icon: Icon(
                                    isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                                    color: isBookmarked ? Colors.blue : null,
                                  ),
                                  onPressed: () {
                                    if (isBookmarked) {
                                      bookmarkProvider.removeBookmark(article);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Removed from bookmarks')),
                                      );
                                    } else {
                                      bookmarkProvider.addBookmark(article);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Added to bookmarks')),
                                      );
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}


// Optional: For search functionality
class NewsSearchDelegate extends SearchDelegate<Article?> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.length < 3) {
      return const Center(
        child: Text("Type at least 3 letters to search"),
      );
    }
    Provider.of<NewsProvider>(context, listen: false).searchNews(query);

    return Consumer<NewsProvider>(
      builder: (context, newsProvider, child) {
        if (newsProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (newsProvider.errorMessage != null) {
          return Center(child: Text('Error: ${newsProvider.errorMessage}'));
        }
        if (newsProvider.articles.isEmpty) {
          return const Center(child: Text('No results found for your search.'));
        }

        return ListView.builder(
          itemCount: newsProvider.articles.length,
          itemBuilder: (context, index) {
            final article = newsProvider.articles[index];
            return GestureDetector(
              onTap: () {
                if (article.url != null) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ArticleDetailScreen(
                        article: article,
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No URL available for this article.')),
                  );
                }
              },
              child: Card(
                margin: const EdgeInsets.all(8.0),
                elevation: 2.0,
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
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      const SizedBox(height: 8.0),
                      Text(
                        article.title ?? 'No Title',
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        article.sourceName ?? 'Unknown Source',
                        style: const TextStyle(fontSize: 12.0, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(
      child: Text("Search for news articles"),
    );
  }
}