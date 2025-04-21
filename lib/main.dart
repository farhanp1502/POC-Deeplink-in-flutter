import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'home_screen.dart';
import 'deeplink_page.dart';
import 'webview_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Deep Link Demo',
      home: const HomeScreen(),
      routes: {
        '/view': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, String>?;
          return DeeplinkPage(
            uri: args?['uri'],
          );
        }
      },
      onGenerateRoute: (settings) {
        final uri = Uri.parse(settings.name ?? '');
        if (uri.path == '/view') {
          return MaterialPageRoute(
            builder: (context) => DeeplinkPage(
              uri: uri.toString(),
            ),
          );
        }
        return null;
      },
    );
  }
}