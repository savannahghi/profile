import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui_components/platform_loader.dart';
import 'package:shared_ui_components/small_appbar.dart';
import 'package:user_profile/constants.dart';
import 'package:user_profile/shared/widget_keys.dart';
import 'package:user_profile/term_and_conditions.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
                                  const TermsAndConditionsPage()));
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
    expect(find.byKey(appBarKey), findsOneWidget);
    expect(find.byKey(webViewKey), findsOneWidget);
    expect(find.byType(SILSmallAppBar), findsOneWidget);
    expect(find.byType(WebView), findsOneWidget);
    expect(find.byType(MaterialButton), findsNothing);

    // close webview
    await tester.tap(find.byKey(appBarBackButtonKey));
    await tester.pumpAndSettle();

    // verify webview is closed
    expect(find.byType(TermsAndConditionsPage), findsNothing);
    expect(find.byType(MaterialButton), findsOneWidget);
  });

  testWidgets('WebViewPage renders TermsAndConditions and call loading state',
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
                                  const TermsAndConditionsPage()));
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
    expect(find.byKey(appBarKey), findsOneWidget);
    expect(find.byKey(webViewKey), findsOneWidget);
    expect(find.byType(WebView), findsOneWidget);
    expect(find.byType(MaterialButton), findsNothing);

    // get the state
    final State<StatefulWidget> testState = tester.allStates.singleWhere(
        (State<StatefulWidget> element) =>
            element.toString() == termsAndConditionsState);

    // check if it is null
    expect(testState, isNotNull);

    // call the method
    final TermsAndConditionsPageState termsAndConditionState =
        testState as TermsAndConditionsPageState;
    termsAndConditionState.onPageStarted(bewellTermsAndConditionsUrl);

    // assert that is was called
    expect(
        () => termsAndConditionState.onPageStarted(bewellTermsAndConditionsUrl),
        returnsNormally);
  });

  testWidgets(
      'WebViewPage renders TermsAndConditions and call complete loading',
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
                                  const TermsAndConditionsPage()));
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
    expect(find.byKey(appBarKey), findsOneWidget);
    expect(find.byKey(webViewKey), findsOneWidget);
    expect(find.byType(WebView), findsOneWidget);
    expect(find.byType(MaterialButton), findsNothing);

    // get the state
    final State<StatefulWidget> testState = tester.allStates.singleWhere(
        (State<StatefulWidget> element) =>
            element.toString() == termsAndConditionsState);

    // check if it is null
    expect(testState, isNotNull);

    // call the method
    final TermsAndConditionsPageState termsAndConditionState =
        testState as TermsAndConditionsPageState;
    termsAndConditionState.onPageFinished(bewellTermsAndConditionsUrl);

    // assert that is was called
    expect(
        () =>
            termsAndConditionState.onPageFinished(bewellTermsAndConditionsUrl),
        returnsNormally);
  });

  testWidgets('WebViewPage loadingState works', (WidgetTester tester) async {
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
                                  const TermsAndConditionsPage()));
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
    expect(find.byKey(appBarKey), findsOneWidget);
    expect(find.byKey(webViewKey), findsOneWidget);
    expect(find.byType(WebView), findsOneWidget);
    expect(find.byType(MaterialButton), findsNothing);

    // get the state
    final State<StatefulWidget> testState = tester.allStates.singleWhere(
        (State<StatefulWidget> element) =>
            element.toString() == termsAndConditionsState);

    // check if it is null
    expect(testState, isNotNull);

    // call the method
    final TermsAndConditionsPageState termsAndConditionState =
        testState as TermsAndConditionsPageState;
    termsAndConditionState.loadingState();

    await tester.pump();

    // assert that is was called
    expect(() => termsAndConditionState.loadingState(), returnsNormally);
    expect(find.byType(SILPlatformLoader), findsOneWidget);
  });
}
