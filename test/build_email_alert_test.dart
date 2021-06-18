import 'dart:convert';

import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:domain_objects/value_objects.dart';
import 'package:shared_ui_components/buttons.dart';
import 'package:user_profile/contact_item.dart';
import 'package:user_profile/contact_utils.dart';
import 'package:user_profile/set_to_primary.dart';
import 'package:user_profile/shared/widget_keys.dart';
import 'package:user_profile/sil_contacts.dart';

import 'mocks.dart';
import 'test_utils.dart';

void main() {
  group('buildEmailAlert', () {
    testWidgets('should render continue button and navigate with error',
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

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(builder: (BuildContext context) {
              return SILPrimaryButton(
                buttonKey: testButtonKey,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<dynamic>(
                        builder: (BuildContext context) =>
                            BuildSetContactToPrimaryPhone(
                              mockShortSILGraphQlClient:
                                  mockShortSILGraphQlClient,
                              type: ContactInfoType.email,
                            )),
                  );
                },
              );
            }),
          ),
        ),
      );

      await tester.tap(find.byKey(testButtonKey));
      await tester.pumpAndSettle();

      expect(find.byType(Column), findsWidgets);

      expect(find.byKey(emailAlertContinueButtonKey), findsOneWidget);
      await tester.tap(find.byKey(emailAlertContinueButtonKey));
      await tester.pumpAndSettle();

      expect(find.byType(BuildSetContactToPrimaryPhone), findsNothing);
    });

    testWidgets('should render continue button and save OTP',
        (WidgetTester tester) async {
      final MockSILGraphQlClient mockSILGraphQlClient = MockSILGraphQlClient();
      final SetToPrimaryBehaviorSubject setToPrimaryBehaviorSubject =
          SetToPrimaryBehaviorSubject();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(builder: (BuildContext context) {
              return SILPrimaryButton(
                buttonKey: testButtonKey,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<dynamic>(
                        builder: (BuildContext context) =>
                            BuildSetContactToPrimaryPhone(
                              mockSILGraphQlClient: mockSILGraphQlClient,
                              type: ContactInfoType.email,
                            )),
                  );
                },
              );
            }),
          ),
        ),
      );

      await tester.tap(find.byKey(testButtonKey));
      await tester.pumpAndSettle();

      expect(find.byType(Column), findsWidgets);

      expect(find.byKey(emailAlertContinueButtonKey), findsOneWidget);
      await tester.tap(find.byKey(emailAlertContinueButtonKey));
      await tester.pumpAndSettle();

      expect(setToPrimaryBehaviorSubject.otp.valueOrNull, testOTP);
    });
  });
}

bool setToTrue({required String flag}) {
  return true;
}

bool setToFalse({required String flag}) {
  return false;
}

class BuildSetContactToPrimaryPhone extends StatelessWidget {
  const BuildSetContactToPrimaryPhone({
    Key? key,
    this.mockSILGraphQlClient,
    required this.type,
    this.mockShortSILGraphQlClient,
    this.isWaiting = false,
  }) : super(key: key);

  final MockSILGraphQlClient? mockSILGraphQlClient;
  final MockShortSILGraphQlClient? mockShortSILGraphQlClient;
  final ContactInfoType type;
  final bool isWaiting;

  @override
  Widget build(BuildContext context) {
    void testUpdateState(
        {required BuildContext context,
        required StateContactType type,
        required String? value}) {}
    return Scaffold(
      body: SetContactToPrimary(
        type: type,
        value: 'value',
        provider: ContactProvider(
          primaryEmail: EmailAddress.withValue(testEmail),
          primaryPhone: PhoneNumber.withValue(testPhoneNumber),
          secondaryEmails: <EmailAddress>[EmailAddress.withValue(testEmail)],
          secondaryPhones: <PhoneNumber>[
            PhoneNumber.withValue(testPhoneNumber)
          ],
          contactUtils: ContactUtils(
            toggleLoadingIndicator: (
                {BuildContext? context, String? flag, bool? show}) {},
            client: mockShortSILGraphQlClient != null
                ? mockSILGraphQlClient
                : mockSILGraphQlClient,
            updateStateFunc: testUpdateState,
          ),
          wait: Wait(),
          checkWaitingFor: isWaiting ? setToTrue : setToFalse,
          child: ContactItem(
            type: type,
            value: testPhoneNumber,
          ),
        ),
      ),
    );
  }
}
