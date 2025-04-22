import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:poc_deeplink/utils/constants.dart';

class DeeplinkPage extends StatefulWidget {
  final String? uri;

  const DeeplinkPage({
    Key? key,
    this.uri,
  }) : super(key: key);

  @override
  State<DeeplinkPage> createState() => _DeeplinkPageState();
}

class _DeeplinkPageState extends State<DeeplinkPage> {
  String? url;
  String? newUrl;
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) {
            print('WebView page finished loading: $url');
          },
          onWebResourceError: (error) {
            print('WebView error: ${error.description}');
          },
        ),
      );

    if (widget.uri != null) {
      final parsedUri = Uri.parse(widget.uri!);
      final path = parsedUri.path;
        if (path.contains(Constants.projectsPath)){
          final segments = path.split('/');
          final projectId = segments.last;
          newUrl = '<url>/$projectId';
        }
        else {
          newUrl = null;
        }

    } else {
      newUrl = null;
    }

    if (newUrl != null && Uri.tryParse(newUrl!)?.isAbsolute == true) {
      _controller.loadRequest(Uri.parse(newUrl!));
    } else {
      print('Invalid or no URL, WebView not loaded');
    }
  }

  Future<bool> _onWillPop() async {
    if (await _controller.canGoBack()) {
      _controller.goBack();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final route = ModalRoute.of(context);

    if (route != null) {

      final args = route.settings.arguments as Map<String, String>?;
      url = args?['url'];
    }


    return WillPopScope(
  onWillPop: _onWillPop,
  child: Scaffold(
    appBar: AppBar(),
    body: newUrl != null && Uri.tryParse(newUrl!)?.isAbsolute == true
        ? WebViewWidget(controller: _controller)
        : Builder(
            builder: (context) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('The provided link is not valid'),
                    duration: Duration(seconds: 2),
                  ),
                );
              });
              return const SizedBox();
            },
          ),
  ),
);
  }
}