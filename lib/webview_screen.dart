import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  final String url;
  final String? token;

  const WebViewScreen({Key? key, required this.url, this.token}) : super(key: key);

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url))
      ..addJavaScriptChannel(
        "FlutterChannel",
        onMessageReceived: (message) {
          print("Received data from WebView: ${message.message}");
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) {
            if (widget.token != null) {
              _setTokenInWebView(widget.token!);
            }
          }
        )
      );
  }

  void _setTokenInWebView(String token) {
    _controller.runJavaScript("""
      localStorage.setItem('auth_token', '$token');
      console.log('Token set in WebView');
    """);
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
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("WebView"),
        ),
        body: WebViewWidget(controller: _controller),
      ),
    );
  }
}