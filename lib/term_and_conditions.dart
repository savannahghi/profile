import 'package:flutter/material.dart';
import 'package:sil_user_profile/constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// A page that displays BeWell terms and conditions.
/// It has an embedded webview that links to the bewell site to load the terms & conditions.
class TermsAndConditionsPage extends StatefulWidget {
  @override
  _TermsAndConditionsPageState createState() => _TermsAndConditionsPageState();
}

class _TermsAndConditionsPageState extends State<TermsAndConditionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          termsTitle,
        ),
      ),
      body: const WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
