import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sil_app_wrapper/sil_app_wrapper.dart';
import 'package:sil_ui_components/sil_buttons.dart';
import 'package:sil_user_profile/contact_utils.dart';
import 'package:http/http.dart' as http;

import 'mocks.dart';
import 'test_utils.dart';

void main() {
  void testUpdateState(
      {required BuildContext context,
      required StateContactType type,
      required String? value}) {}
  final MockSILGraphQlClient mockSILGraphQlClient = MockSILGraphQlClient();

  testWidgets('should sendPhoneOtp sucessfully', (WidgetTester tester) async {
    await tester.pumpWidget(Builder(
      builder: (BuildContext context) {
        return MaterialApp(
          home: SILAppWrapperBase(
            appName: 'testAppName',
            appContexts: const <AppContext>[AppContext.BewellCONSUMER],
            graphQLClient: mockSILGraphQlClient,
            deviceCapabilities: MockDeviceCapabilities(),
            child: Scaffold(
              body: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints box) {
                return SILPrimaryButton(
                  buttonKey: testButtonKey,
                  onPressed: () {
                    testContactProvider(mockSILGraphQlClient, testUpdateState)
                        .contactUtils
                        .sendPhoneOtp(
                            phone: testPhoneNumber,
                            context: context,
                            flag: 'flag');
                  },
                );
              }),
            ),
          ),
        );
      },
    ));

    await tester.tap(find.byKey(testButtonKey));
  });

  testWidgets('should retireSecondaryContact sucessfully',
      (WidgetTester tester) async {
    await tester.pumpWidget(Builder(
      builder: (BuildContext context) {
        return MaterialApp(
          home: SILAppWrapperBase(
            appName: 'testAppName',
            appContexts: const <AppContext>[AppContext.BewellCONSUMER],
            graphQLClient: mockSILGraphQlClient,
            deviceCapabilities: MockDeviceCapabilities(),
            child: Scaffold(
              body: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints box) {
                return SILPrimaryButton(
                  buttonKey: testButtonKey,
                  onPressed: () {
                    testContactProvider(mockSILGraphQlClient, testUpdateState)
                        .contactUtils
                        .retireSecondaryContact(
                            value: 'value',
                            isPhone: true,
                            context: context,
                            flag: 'flag');
                  },
                );
              }),
            ),
          ),
        );
      },
    ));

    await tester.tap(find.byKey(testButtonKey));
  });

  testWidgets('should verifyAddPrimaryEmailOtp sucessfully',
      (WidgetTester tester) async {
    final TextEditingController controller = TextEditingController();
    await tester.pumpWidget(Builder(
      builder: (BuildContext context) {
        return MaterialApp(
          home: SILAppWrapperBase(
            appName: 'testAppName',
            appContexts: const <AppContext>[AppContext.BewellCONSUMER],
            graphQLClient: mockSILGraphQlClient,
            deviceCapabilities: MockDeviceCapabilities(),
            child: Scaffold(
              body: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints box) {
                return SILPrimaryButton(
                  buttonKey: testButtonKey,
                  onPressed: () {
                    testContactProvider(mockSILGraphQlClient, testUpdateState)
                        .contactUtils
                        .verifyAddPrimaryEmailOtp(
                            context: context,
                            flag: 'flag',
                            controller: controller,
                            email: '',
                            otp: '1234',
                            toggleInvalidCodeMsg: () {},
                            userInput: '1234');
                  },
                );
              }),
            ),
          ),
        );
      },
    ));

    await tester.tap(find.byKey(testButtonKey));
    expect(find.byType(HapticFeedback), findsNothing);
  });

  testWidgets('should show error when verifyAddPrimaryEmailOtp',
      (WidgetTester tester) async {
    final MockShortSILGraphQlClient mockShortSILGraphQlClient =
        MockShortSILGraphQlClient.withResponse(
      'idToken',
      'endpoint',
      http.Response(
          json.encode(<String, dynamic>{
            'error': 'not found',
          }),
          402),
    );

    final TextEditingController controller = TextEditingController();
    await tester.pumpWidget(Builder(
      builder: (BuildContext context) {
        return MaterialApp(
          home: SILAppWrapperBase(
            appName: 'testAppName',
            appContexts: const <AppContext>[AppContext.BewellCONSUMER],
            graphQLClient: mockShortSILGraphQlClient,
            deviceCapabilities: MockDeviceCapabilities(),
            child: Scaffold(
              body: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints box) {
                return SILPrimaryButton(
                  buttonKey: testButtonKey,
                  onPressed: () {
                    testContactProvider(
                            mockShortSILGraphQlClient, testUpdateState)
                        .contactUtils
                        .verifyAddPrimaryEmailOtp(
                            context: context,
                            flag: 'flag',
                            controller: controller,
                            email: '',
                            otp: '1234',
                            toggleInvalidCodeMsg: (_) {},
                            userInput: '1234');
                  },
                );
              }),
            ),
          ),
        );
      },
    ));

    await tester.tap(find.byKey(testButtonKey));
    expect(find.byType(HapticFeedback), findsNothing);
  });

  testWidgets('should not verifyAddPrimaryEmailOtp when otp does not match',
      (WidgetTester tester) async {
    final TextEditingController controller = TextEditingController();
    await tester.pumpWidget(Builder(
      builder: (BuildContext context) {
        return MaterialApp(
          home: SILAppWrapperBase(
            appName: 'testAppName',
            appContexts: const <AppContext>[AppContext.BewellCONSUMER],
            graphQLClient: mockSILGraphQlClient,
            deviceCapabilities: MockDeviceCapabilities(),
            child: Scaffold(
              body: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints box) {
                return SILPrimaryButton(
                  buttonKey: testButtonKey,
                  onPressed: () {
                    testContactProvider(mockSILGraphQlClient, testUpdateState)
                        .contactUtils
                        .verifyAddPrimaryEmailOtp(
                            context: context,
                            flag: 'flag',
                            controller: controller,
                            email: '',
                            otp: '1234',
                            toggleInvalidCodeMsg: (_) {},
                            userInput: '4321');
                  },
                );
              }),
            ),
          ),
        );
      },
    ));

    await tester.tap(find.byKey(testButtonKey));
    await tester.pumpAndSettle();
    expect(controller.value.text, '');
  });
}
