## Flutter News App
A simple and clean Flutter app for reading the latest news, logging in, and saving articles for later reading.

## Features
Login Page: Basic login using email and password. Login status is remembered even if the app is closed.

News Feed: Shows top news headlines using the NewsAPI, with article image, title, description, source, and date.

Article View: Opens full articles inside the app using WebView.

Bookmarking: We can save your favorite articles to read later.

Bookmarks Page: View all your saved articles and remove any you don’t want.

Smooth Navigation: Easily switch between News Feed and Bookmarks using the bottom tab bar.

Pull-to-Refresh: Swipe down to refresh news on the main screen.

## Screenshots

![Login Page](assets/images/Login.png)
![bookmarks Page](assets/images/bookmarks.png)
![article Page](assets/images/article.png)
![news Page](assets/images/news.png)

## Setup Instructions
Requirements: 
Latest Flutter SDK
Android Studio with Flutter and Dart plugins
Internet connection to fetch news

## Getting Started
1.Clone the repo
git clone https://github.com/YOUR_GITHUB_USERNAME/flutter_news_app.git
cd flutter_news_app
2.Install packages
flutter pub get
3.Get a News API Key
Go to newsapi.org and sign up for a free key.
4.Add the API Key
Open lib/utils/app_constants.dart and replace 'OUR_NEWS_API_KEY' with our actual key:
5.Run the app
flutter run
6.Architecture
The app follows a clean structure with separate folders for different features:

models/ – Data models like Article

services/ – Code for calling APIs

providers/ – State management (login, news, bookmarks)

screen/ – Screens like Login, NewsFeed, Bookmarks

## Packages Used
dio: To fetch news from the internet
provider : Manages app state like login, news list, bookmarks
shared_preferences	: Saves login info and bookmarks locally
webview_flutte :Opens the full article inside the app
intl: Formats dates to be user-friendly
cached_network_image: Loads images faster and saves them for reuse
