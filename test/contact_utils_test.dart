import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sil_app_wrapper/sil_app_wrapper.dart';
import 'package:sil_ui_components/sil_buttons.dart';
import 'package:sil_user_profile/contact_utils.dart';

import 'mocks.dart';
import 'test_utils.dart';

void main() {
  void testUpdateState(
      {required BuildContext context,
      required StateContactType type,
      required String? value}) {}
  final MockSILGraphQlClient mockSILGraphQlClient = MockSILGraphQlClient();

  testWidgets('should test sendPhoneOtp', (WidgetTester tester) async {
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

  testWidgets('should test retireSecondaryContact',
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
}
