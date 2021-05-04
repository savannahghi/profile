import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:async_redux/async_redux.dart';

import 'package:sil_core_domain_objects/value_objects.dart';
import 'package:sil_ui_components/sil_buttons.dart';
import 'package:sil_ui_components/sil_inputs.dart';
import 'package:sil_ui_components/sil_platform_loader.dart';
import 'package:sil_user_profile/add_contact.dart';
import 'package:sil_user_profile/constants.dart';
import 'package:sil_user_profile/contact_utils.dart';
import 'package:sil_user_profile/shared/widget_keys.dart';
import 'package:sil_user_profile/sil_contacts.dart';

import 'mocks.dart';
import 'test_utils.dart';

void main() {
  void testUpdateState(
      {required BuildContext context,
      required StateContactType type,
      required String? value}) {}
  final MockSILGraphQlClient mockSILGraphQlClient = MockSILGraphQlClient();
  final AddContactBehaviorSubject addContactBehaviorSubject =
      AddContactBehaviorSubject();

  bool checkWaitingFor({required String flag}) {
    return false;
  }

  group('addContactInfoBottomSheet', () {
    testWidgets('should render correctly for email',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(builder: (BuildContext context) {
            return SILPrimaryButton(
              buttonKey: testButtonKey,
              onPressed: () {
                addContactInfoBottomSheet(
                    context: context,
                    type: ContactInfoType.email,
                    onSave: () {},
                    primary: true);
              },
            );
          }),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.byKey(testButtonKey));
      await tester.pumpAndSettle();
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
      await tester.enterText(find.byType(TextFormField), testEmail);
      await tester.pumpAndSettle();
      expect(find.text(testEmail), findsOneWidget);
      expect(find.text(emailValidationMessage), findsNothing);
    });

    testWidgets('should show error message for invalid email',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ContactProvider(
            primaryEmail: EmailAddress.withValue('someone@example.com'),
            primaryPhone: PhoneNumber.withValue(testPhoneNumber),
            secondaryEmails: <EmailAddress>[
              EmailAddress.withValue('example@mail')
            ],
            secondaryPhones: <PhoneNumber>[
              PhoneNumber.withValue(testPhoneNumber)
            ],
            contactUtils: ContactUtils(
              toggleLoadingIndicator: () {},
              client: mockSILGraphQlClient,
              updateStateFunc: testUpdateState,
            ),
            wait: Wait(),
            checkWaitingFor: checkWaitingFor,
            child: Builder(builder: (BuildContext context) {
              return SILPrimaryButton(
                buttonKey: testButtonKey,
                onPressed: () {
                  addContactInfoBottomSheet(
                      context: context,
                      type: ContactInfoType.email,
                      onSave: () {},
                      primary: true);
                },
              );
            }),
          ),
        ),
      );

      await tester.pump();

      await tester.tap(find.byKey(testButtonKey));
      await tester.pumpAndSettle();
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
      await tester.enterText(find.byType(TextFormField), testInvalidEmail);
      await tester.pumpAndSettle();
      expect(find.text(testInvalidEmail), findsOneWidget);

      expect(find.byKey(saveButtonKey), findsOneWidget);
      await tester.tap(find.byKey(saveButtonKey));
      await tester.pumpAndSettle();
      expect(find.text(emailValidationMessage), findsOneWidget);
    });

    testWidgets('should show error message for empty email',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ContactProvider(
            primaryEmail: EmailAddress.withValue(''),
            primaryPhone: PhoneNumber.withValue(testPhoneNumber),
            secondaryEmails: <EmailAddress>[EmailAddress.withValue('')],
            secondaryPhones: <PhoneNumber>[
              PhoneNumber.withValue(testPhoneNumber)
            ],
            contactUtils: ContactUtils(
              toggleLoadingIndicator: () {},
              client: mockSILGraphQlClient,
              updateStateFunc: testUpdateState,
            ),
            wait: Wait(),
            checkWaitingFor: checkWaitingFor,
            child: Builder(builder: (BuildContext context) {
              return SILPrimaryButton(
                buttonKey: testButtonKey,
                onPressed: () {
                  addContactInfoBottomSheet(
                      context: context,
                      type: ContactInfoType.email,
                      onSave: () {},
                      primary: true);
                },
              );
            }),
          ),
        ),
      );

      await tester.pump();

      await tester.tap(find.byKey(testButtonKey));
      await tester.pumpAndSettle();
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
      await tester.enterText(find.byType(TextFormField), testEmail);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), '');
      await tester.pumpAndSettle();

      expect(find.byKey(saveButtonKey), findsOneWidget);
      await tester.tap(find.byKey(saveButtonKey));
      await tester.pumpAndSettle();
      expect(find.text(emailValidationMessage), findsOneWidget);
    });

    testWidgets('should save email contact', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ContactProvider(
            primaryEmail: EmailAddress.withValue(testEmail),
            primaryPhone: PhoneNumber.withValue(testPhoneNumber),
            secondaryEmails: <EmailAddress>[EmailAddress.withValue(testEmail)],
            secondaryPhones: <PhoneNumber>[
              PhoneNumber.withValue(testPhoneNumber)
            ],
            contactUtils: ContactUtils(
              toggleLoadingIndicator: (
                  {BuildContext? context, String? flag, bool? show}) {},
              client: mockSILGraphQlClient,
              updateStateFunc: testUpdateState,
            ),
            wait: Wait(),
            checkWaitingFor: checkWaitingFor,
            child: Builder(builder: (BuildContext context) {
              return SILPrimaryButton(
                buttonKey: testButtonKey,
                onPressed: () {
                  addContactInfoBottomSheet(
                      context: context,
                      type: ContactInfoType.email,
                      onSave: () {},
                      primary: true);
                },
              );
            }),
          ),
        ),
      );

      await tester.pump();

      await tester.tap(find.byKey(testButtonKey));
      await tester.pumpAndSettle();
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
      await tester.enterText(find.byType(TextFormField), testEmail);
      await tester.pumpAndSettle();

      expect(find.byKey(saveButtonKey), findsOneWidget);
      await tester.tap(find.byKey(saveButtonKey));
      await tester.pumpAndSettle();
      expect(find.text(emailValidationMessage), findsNothing);
    });

    testWidgets('should render correctly for phone',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(builder: (BuildContext context) {
              return SILPrimaryButton(
                buttonKey: testButtonKey,
                onPressed: () {
                  addContactInfoBottomSheet(
                      context: context,
                      type: ContactInfoType.phone,
                      onSave: () {},
                      primary: true);
                },
              );
            }),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.byKey(testButtonKey));
      await tester.pumpAndSettle();
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(SILPhoneInput), findsOneWidget);

      await tester.tap(find.byType(SILPhoneInput));
      await tester.enterText(find.byType(SILPhoneInput), '07123456789');
      await tester.pumpAndSettle();
      expect(find.text('07123456789'), findsOneWidget);
    });

    testWidgets('should verify valid otp after saving email',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ContactProvider(
            primaryEmail: EmailAddress.withValue(testEmail),
            primaryPhone: PhoneNumber.withValue(testPhoneNumber),
            secondaryEmails: <EmailAddress>[EmailAddress.withValue(testEmail)],
            secondaryPhones: <PhoneNumber>[
              PhoneNumber.withValue(testPhoneNumber)
            ],
            contactUtils: ContactUtils(
              toggleLoadingIndicator: (
                  {BuildContext? context, String? flag, bool? show}) {},
              client: mockSILGraphQlClient,
              updateStateFunc: testUpdateState,
            ),
            wait: Wait(),
            checkWaitingFor: checkWaitingFor,
            child: Builder(builder: (BuildContext context) {
              return SILPrimaryButton(
                buttonKey: testButtonKey,
                onPressed: () {
                  addContactInfoBottomSheet(
                      context: context,
                      type: ContactInfoType.email,
                      onSave: () {},
                      primary: true);
                },
              );
            }),
          ),
        ),
      );

      await tester.pump();

      await tester.tap(find.byKey(testButtonKey));
      await tester.pumpAndSettle();
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
      await tester.enterText(find.byType(TextFormField), testEmail);
      await tester.pumpAndSettle();

      expect(find.byKey(saveButtonKey), findsOneWidget);
      await tester.tap(find.byKey(saveButtonKey));
      await tester.pumpAndSettle();
      expect(find.text(emailValidationMessage), findsNothing);

      expect(find.byType(SILPinCodeTextField), findsOneWidget);
      await tester.enterText(find.byType(SILPinCodeTextField), testOTP);
      await tester.pumpAndSettle();

      expect(addContactBehaviorSubject.invalidCode.valueWrapper!.value, false);
    });

    testWidgets('should show loader', (WidgetTester tester) async {
      final Wait wait = Wait();
      await tester.runAsync(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: ContactProvider(
              primaryEmail: EmailAddress.withValue(testEmail),
              primaryPhone: PhoneNumber.withValue(testPhoneNumber),
              secondaryEmails: <EmailAddress>[
                EmailAddress.withValue(testEmail)
              ],
              secondaryPhones: <PhoneNumber>[
                PhoneNumber.withValue(testPhoneNumber)
              ],
              contactUtils: ContactUtils(
                toggleLoadingIndicator: (
                    {BuildContext? context, String? flag, bool? show}) {},
                client: mockSILGraphQlClient,
                updateStateFunc: testUpdateState,
              ),
              wait: wait,
              checkWaitingFor: checkWaitingFor,
              child: Builder(builder: (BuildContext context) {
                return SILPrimaryButton(
                  buttonKey: testButtonKey,
                  onPressed: () {
                    addContactInfoBottomSheet(
                        context: context,
                        type: ContactInfoType.email,
                        onSave: () {},
                        primary: true);
                  },
                );
              }),
            ),
          ),
        );

        await tester.pump();

        await tester.tap(find.byKey(testButtonKey));
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        expect(find.byType(SingleChildScrollView), findsOneWidget);
        expect(find.byType(TextFormField), findsOneWidget);
        await tester.enterText(find.byType(TextFormField), testEmail);
        await tester.pumpAndSettle();

        expect(find.byType(SILPrimaryButton), findsOneWidget);
        await tester.tap(find.byType(SILPrimaryButton));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(cancelAddContact));
        expect(getLoader(show: true), isA<SILPlatformLoader>());
        expect(getLoader(show: false), isA<Widget>());
      });
    });

    testWidgets('should verify invalid otp after saving email',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ContactProvider(
            primaryEmail: EmailAddress.withValue(testEmail),
            primaryPhone: PhoneNumber.withValue(testPhoneNumber),
            secondaryEmails: <EmailAddress>[EmailAddress.withValue(testEmail)],
            secondaryPhones: <PhoneNumber>[
              PhoneNumber.withValue(testPhoneNumber)
            ],
            contactUtils: ContactUtils(
              toggleLoadingIndicator: (
                  {BuildContext? context, String? flag, bool? show}) {},
              client: mockSILGraphQlClient,
              updateStateFunc: testUpdateState,
            ),
            wait: Wait(),
            checkWaitingFor: checkWaitingFor,
            child: Builder(builder: (BuildContext context) {
              return SILPrimaryButton(
                buttonKey: testButtonKey,
                onPressed: () {
                  addContactInfoBottomSheet(
                      context: context,
                      type: ContactInfoType.email,
                      onSave: () {},
                      primary: true);
                },
              );
            }),
          ),
        ),
      );

      await tester.pump();

      await tester.tap(find.byKey(testButtonKey));
      await tester.pumpAndSettle();
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
      await tester.enterText(find.byType(TextFormField), testEmail);
      await tester.pumpAndSettle();

      expect(find.byKey(saveButtonKey), findsOneWidget);
      await tester.tap(find.byKey(saveButtonKey));
      await tester.pumpAndSettle();
      expect(find.text(emailValidationMessage), findsNothing);

      expect(find.byType(SILPinCodeTextField), findsOneWidget);
      await tester.enterText(find.byType(SILPinCodeTextField), testInvalidOTP);
      await tester.pumpAndSettle();

      expect(addContactBehaviorSubject.invalidCode.valueWrapper!.value, true);
      expect(find.text(incorrectCode), findsOneWidget);

      await tester.enterText(find.byType(SILPinCodeTextField), testInvalidOTP);
      await tester.pumpAndSettle();
    });
  });
}
