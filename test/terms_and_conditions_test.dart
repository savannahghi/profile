import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sil_user_profile/term_and_conditions.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:sil_user_profile/constants.dart';

void main() {
  testWidgets('WebViewPage renders TermsAndConditions.url correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Builder(builder: (BuildContext context) {
        return Scaffold(
            body: Center(
                child: MaterialButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute<TermsAndConditionsPage>(
                              builder: (BuildContext context) =>
                                  TermsAndConditionsPage()));
                    },
                    child: const Text('Launch Webview'))));
      }),
    ));

    // verify renders correctly
    expect(find.byType(MaterialButton), findsOneWidget);

    // launch webview
    await tester.tap(find.byType(MaterialButton));
    await tester.pumpAndSettle();

    // verify webview is open
    expect(find.text(termsTitle), findsOneWidget);
    expect(find.byType(WebView), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    expect(find.byType(MaterialButton), findsNothing);

    // close webview
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    // verify webview is closed
    expect(find.byType(TermsAndConditionsPage), findsNothing);
    expect(find.byType(MaterialButton), findsOneWidget);
  });
}
