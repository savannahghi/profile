import 'package:flutter/material.dart';
import 'package:sil_ui_components/sil_platform_loader.dart';
import 'package:sil_user_profile/constants.dart';
import 'package:sil_user_profile/shared/widget_keys.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// A page that displays BeWell terms and conditions.
/// It has an embedded webview that links to the bewell site to load the terms & conditions.
class TermsAndConditionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: appBarKey,
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
      body: WebView(
        key: webViewKey,
        initialUrl: url,
        onPageStarted: (String url) => loadingState(context),
        onPageFinished: (String url) => completeLoading(context),
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }

  /// shows progress indicator
  Future<dynamic> loadingState(BuildContext context) {
    return showDialog(
      context: context,
      barrierColor: Colors.black12,
      builder: (BuildContext context) => const SILPlatformLoader(),
    );
  }

  ///  progress indicator
  void completeLoading(BuildContext context) {
    return Navigator.pop(context);
  }
}
