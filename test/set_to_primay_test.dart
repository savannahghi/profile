import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:async_redux/async_redux.dart';
import 'package:http/http.dart' as http;

import 'package:sil_core_domain_objects/value_objects.dart';
import 'package:sil_ui_components/sil_buttons.dart';
import 'package:sil_ui_components/sil_inputs.dart';
import 'package:sil_ui_components/sil_platform_loader.dart';
import 'package:sil_user_profile/contact_item.dart';
import 'package:sil_user_profile/contact_utils.dart';
import 'package:sil_user_profile/set_to_primary.dart';
import 'package:sil_user_profile/sil_contacts.dart';

import 'mocks.dart';
import 'test_utils.dart';

void main() {
  group('upgradeToPrimaryBottomSheet', () {
    void testUpdateState(
        {required BuildContext context,
        required StateContactType type,
        required String? value}) {}
    final MockSILGraphQlClient mockSILGraphQlClient = MockSILGraphQlClient();
    final SetToPrimaryBehaviorSubject setToPrimaryBehaviorSubject =
        SetToPrimaryBehaviorSubject();

    testWidgets('should render SetContactToPrimary correctly',
        (WidgetTester tester) async {
      bool setToTrue({required String flag}) {
        return true;
      }

      await tester.pumpWidget(
        MaterialApp(
          home: SetContactToPrimary(
            type: ContactInfoType.email,
            value: 'value',
            provider: ContactProvider(
              primaryEmail: EmailAddress.withValue('someone@example.com'),
              primaryPhone: PhoneNumber.withValue(testPhoneNumber),
              secondaryEmails: <EmailAddress>[
                EmailAddress.withValue('example@mail')
              ],
              secondaryPhones: <PhoneNumber>[
                PhoneNumber.withValue('+254189123456')
              ],
              contactUtils: ContactUtils(
                toggleLoadingIndicator: () {},
                client: mockSILGraphQlClient,
                updateStateFunc: testUpdateState,
              ),
              wait: Wait(),
              checkWaitingFor: setToTrue,
              child: const ContactItem(
                type: ContactInfoType.phone,
                value: testPhoneNumber,
              ),
            ),
          ),
        ),
      );
      expect(find.byType(Column), findsWidgets);
      expect(find.byType(SILPlatformLoader), findsOneWidget);
    });

    testWidgets('should render SetContactToPrimary and show button',
        (WidgetTester tester) async {
      bool setToFalse({required String flag}) {
        return false;
      }

      await tester.pumpWidget(
        MaterialApp(
          home: SetContactToPrimary(
            type: ContactInfoType.email,
            value: 'value',
            provider: ContactProvider(
              primaryEmail: EmailAddress.withValue('someone@example.com'),
              primaryPhone: PhoneNumber.withValue(testPhoneNumber),
              secondaryEmails: <EmailAddress>[
                EmailAddress.withValue('example@mail')
              ],
              secondaryPhones: <PhoneNumber>[
                PhoneNumber.withValue('+254189123456')
              ],
              contactUtils: ContactUtils(
                toggleLoadingIndicator: () {},
                client: mockSILGraphQlClient,
                updateStateFunc: testUpdateState,
              ),
              wait: Wait(),
              checkWaitingFor: setToFalse,
              child: const ContactItem(
                type: ContactInfoType.phone,
                value: testPhoneNumber,
              ),
            ),
          ),
        ),
      );
      expect(find.byType(SILPrimaryButton), findsOneWidget);
      expect(find.byType(SILSecondaryButton), findsOneWidget);

      await tester.tap(find.byType(SILSecondaryButton));
      await tester.pumpAndSettle();
    });

    testWidgets('should cancel buildPhoneAlert', (WidgetTester tester) async {
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
                              type: ContactInfoType.phone,
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

      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(SILSecondaryButton), findsOneWidget);
      await tester.tap(find.byType(SILSecondaryButton));
      await tester.pumpAndSettle();
      expect(find.byType(BuildSetContactToPrimaryPhone), findsNothing);
    });

    testWidgets('should buildPhoneAlert and navigate with error',
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
                              type: ContactInfoType.phone,
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

      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(SILPrimaryButton), findsOneWidget);
      await tester.tap(find.byType(SILPrimaryButton));
      await tester.pumpAndSettle();
      expect(find.byType(BuildSetContactToPrimaryPhone), findsNothing);
    });

    testWidgets('should buildPhoneAlert', (WidgetTester tester) async {
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
                              type: ContactInfoType.phone,
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

      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(SILPrimaryButton), findsOneWidget);
      await tester.tap(find.byType(SILPrimaryButton));
      await tester.pumpAndSettle();
      expect(setToPrimaryBehaviorSubject.otp.valueWrapper!.value, '123456');
    });

    testWidgets(
        'should buildVerifyWidget with valid code and Contact type is phone and navigate',
        (WidgetTester tester) async {
      setToPrimaryBehaviorSubject.otp.add('123456');

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
                              type: ContactInfoType.phone,
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

      expect(find.byType(SILPinCodeTextField), findsOneWidget);
      await tester.tap(find.byType(SILPinCodeTextField));
      await tester.pump(const Duration(seconds: 1));
      await tester.enterText(find.byType(SILPinCodeTextField), '123456');
      await tester.pumpAndSettle();

      expect(find.byType(BuildSetContactToPrimaryPhone), findsNothing);
    });

    testWidgets(
        'should buildVerifyWidget with valid code and navigate successfully',
        (WidgetTester tester) async {
      setToPrimaryBehaviorSubject.otp.add('123456');

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

      expect(find.byType(SILPinCodeTextField), findsOneWidget);
      await tester.tap(find.byType(SILPinCodeTextField));
      await tester.pump(const Duration(seconds: 1));
      await tester.enterText(find.byType(SILPinCodeTextField), '123456');
      await tester.pumpAndSettle();

      expect(find.byType(BuildSetContactToPrimaryPhone), findsNothing);
    });

    testWidgets(
        'should buildVerifyWidget with valid code and navigate with error',
        (WidgetTester tester) async {
      setToPrimaryBehaviorSubject.otp.add('123456');

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

      expect(find.byType(SILPinCodeTextField), findsOneWidget);
      await tester.tap(find.byType(SILPinCodeTextField));
      await tester.pump(const Duration(seconds: 1));
      await tester.enterText(find.byType(SILPinCodeTextField), '123456');
      await tester.pumpAndSettle();

      expect(find.byType(BuildSetContactToPrimaryPhone), findsNothing);
    });

    testWidgets('should buildVerifyWidget with invalid code and navigate',
        (WidgetTester tester) async {
      setToPrimaryBehaviorSubject.otp.add('123456');

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
                              type: ContactInfoType.phone,
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

      expect(find.byType(SILPinCodeTextField), findsOneWidget);
      await tester.tap(find.byType(SILPinCodeTextField));
      await tester.pump(const Duration(seconds: 1));
      await tester.enterText(find.byType(SILPinCodeTextField), '654321');
      await tester.pumpAndSettle();

      expect(setToPrimaryBehaviorSubject.invalidCode.valueWrapper!.value, true);
    });

    testWidgets(
        'should buildVerifyWidget with invalid code then enter correct code',
        (WidgetTester tester) async {
      setToPrimaryBehaviorSubject.otp.add('123456');

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
                              type: ContactInfoType.phone,
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

      expect(find.byType(SILPinCodeTextField), findsOneWidget);
      await tester.tap(find.byType(SILPinCodeTextField));
      await tester.pump(const Duration(seconds: 1));
      await tester.enterText(find.byType(SILPinCodeTextField), '654321');
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(SILPinCodeTextField), '123456');
      await tester.pumpAndSettle();

      expect(setToPrimaryBehaviorSubject.invalidCode.valueWrapper!.value, true);
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
