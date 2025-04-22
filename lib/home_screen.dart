import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    initDeepLinks();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  Future<void> initDeepLinks() async {
    _appLinks = AppLinks();

    final uri = await _appLinks.getInitialAppLink();
    if (uri != null) {
      handleDeepLink(uri);
    }

    _linkSubscription = _appLinks.uriLinkStream.listen(handleDeepLink);
  }

  void handleDeepLink(Uri uri) {
    String path = uri.path;

    if (path.contains('/view')) {
      Navigator.pushNamed(context, '/view', arguments: {
        'uri': uri.toString(), // Pass full URI as a string
      }).catchError((e) {
        print('Navigation error for /view: $e');
      });
    }else {
      print('Unknown path: $path');
    }
  }

  // void _openChildPage() {
  //   print('Opening ChildPage manually');
  //   Navigator.pushNamed(context, '/view', arguments: { // Example URI for manual navigation
  //   }).catchError((e) {
  //     print('Navigation error for manual /view: $e');
  //   });
  // }

  void _openWebView() {
    Navigator.pushNamed(context, '/webview', arguments: {
      'url': '<url>',
      'token': 'sample-auth-token-123',
    }).catchError((e) {
      print('Navigation error for manual /webview: $e');
    });
  }

  // Future<void> _testDeepLink() async {
  //   final Uri uri = Uri.parse(
  //       'yourapp://deeplink/view/project/6dc12038c231bc3e7dc7994e0a308610');
  //   print('Simulating deep link: $uri');
  //   handleDeepLink(uri);

  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(content: Text('Deep link simulation triggered')),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Deep Link Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ElevatedButton(
            //   onPressed: _openChildPage,
            //   child: const Text('Open Child Page'),
            // ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _openWebView,
              child: const Text('Open WebView'),
            ),
            // const SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: _testDeepLink,
            //   child: const Text('Test Deep Link'),
            // ),
          ],
        ),
      ),
    );
  }
}