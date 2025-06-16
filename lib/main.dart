import 'package:flutter/material.dart';
import 'package:news_app/providers/news_provider.dart';
import 'package:news_app/screens/login_screen.dart';
import 'package:news_app/screens/home_screen.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:news_app/providers/auth_provider.dart';
import 'package:news_app/providers/bookmark_provider.dart';
import 'package:news_app/providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => BookmarkProvider()),
        ChangeNotifierProvider(create: (_) => NewsProvider()), // Add NewsProvider
        ChangeNotifierProvider(create: (_) => ThemeProvider()), // Add ThemeProvider
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthProvider>(context, listen: false).loadLoginStatus();
      Provider.of<BookmarkProvider>(context, listen: false).loadBookmarks();
      //
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, ThemeProvider>(
      builder: (context, authProvider, themeProvider, child) {
        return MaterialApp(
          title: 'News App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            primarySwatch: Colors.indigo,
            brightness: Brightness.dark,
          ),
          themeMode: themeProvider.themeMode, // Set theme mode from provider
          home: authProvider.isLoggedIn ? const HomeScreen() : const LoginScreen(),
        );
      },
    );
  }
}