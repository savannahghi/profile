import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:async_redux/async_redux.dart';
import 'package:http/http.dart' as http;

import 'package:sil_core_domain_objects/value_objects.dart';
import 'package:sil_ui_components/sil_platform_loader.dart';
import 'package:sil_user_profile/constants.dart';
import 'package:sil_user_profile/contact_item.dart';
import 'package:sil_user_profile/contact_utils.dart';
import 'package:sil_user_profile/set_to_primary.dart';
import 'package:sil_user_profile/shared/widget_keys.dart';
import 'package:sil_user_profile/sil_contacts.dart';

import 'mocks.dart';
import 'test_utils.dart';

void main() {
  group('ContactItem', () {
    void testUpdateState(
        {required BuildContext context,
        required StateContactType type,
        required String? value}) {}
    final MockSILGraphQlClient mockSILGraphQlClient = MockSILGraphQlClient();

    testWidgets(
        'renders correctly when the item is type phone and not editable',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ContactProvider(
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
              checkWaitingFor: () {},
              child: const ContactItem(
                type: ContactInfoType.phone,
                value: testPhoneNumber,
              ),
            ),
          ),
        ),
      );
      // expect to find the gesture detector when the number is not editable
      expect(find.byKey(const Key('not_editable_contact_key')), findsOneWidget);

      // expect that tapping the button calls the primaryContactInfo method
      await tester.tap(find.byKey(const Key('not_editable_contact_key')));
      await tester.pumpAndSettle();

      // expect to find widget in the bottom sheet
      expect(find.text(phoneTitle), findsOneWidget);
      expect(find.text(testPhoneNumber), findsWidgets);
      expect(find.text(closeText), findsOneWidget);

      //expect to find the close button
      expect(find.byKey(const Key('close_key')), findsOneWidget);

      //expect tapping the close button closes the bottom sheet
      await tester.tap(find.byKey(const Key('close_key')));
      await tester.pumpAndSettle();

      expect(find.text(phoneTitle), findsNothing);
      expect(find.text(testPhoneNumber), findsOneWidget);
      expect(find.text(closeText), findsNothing);
    });

    testWidgets(
        'renders correctly when the item is email phone and  not editable',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ContactProvider(
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
              checkWaitingFor: () {},
              child: const ContactItem(
                type: ContactInfoType.email,
                value: 'someone@example.com',
              ),
            ),
          ),
        ),
      );
      // expect to find the gesture detector when the number is not editable
      expect(find.byKey(const Key('not_editable_contact_key')), findsOneWidget);

      // expect that tapping the button calls the primaryContactInfo method
      await tester.tap(find.byKey(const Key('not_editable_contact_key')));
      await tester.pumpAndSettle();

      // expect to find widget in the bottom sheet
      expect(find.text(emailTitle), findsOneWidget);
      expect(find.text('someone@example.com'), findsWidgets);
      expect(find.text(closeText), findsOneWidget);

      //expect to find the close button
      expect(find.byKey(const Key('close_key')), findsOneWidget);

      //expect tapping the close button closes the bottom sheet
      await tester.tap(find.byKey(const Key('close_key')));
      await tester.pumpAndSettle();

      expect(find.text(emailTitle), findsNothing);
      expect(find.text('someone@example.com'), findsOneWidget);
      expect(find.text(closeText), findsNothing);
    });

    testWidgets('renders correctly when the item is editable',
        (WidgetTester tester) async {
      await tester.runAsync(() async {
        bool setToTrue({required String flag}) {
          return false;
        }

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ContactProvider(
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
                checkWaitingFor: setToTrue,
                child: const ContactItem(
                  type: ContactInfoType.phone,
                  value: testPhoneNumber,
                  editable: true,
                ),
              ),
            ),
          ),
        );

        // expect to find the gesture detectors when the number is  editable
        expect(find.byKey(const Key('editable_contact_key')), findsOneWidget);
        expect(find.byKey(const Key('delete_contact_key')), findsOneWidget);

        // expect that tapping the edit button calls the upgradeToPrimaryBottomSheet method
        await tester.tap(find.byKey(const Key('editable_contact_key')));
        await tester.pump();

        // expect to find widget in the bottom sheet
        expect(find.byType(SingleChildScrollView), findsOneWidget);
        expect(find.byType(SetContactToPrimary), findsOneWidget);

        await tester.tap(find.byKey(const Key('delete_contact_key')));
        await tester.pump();
        expect(find.byKey(const Key('editable_contact_key')), findsOneWidget);
      });
    });

    testWidgets(
        'renders correctly when the item is editable and toggleloading indicator',
        (WidgetTester tester) async {
      await tester.runAsync(() async {
        bool setToTrue({required String flag}) {
          return true;
        }

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ContactProvider(
                primaryEmail: EmailAddress.withValue('someone@example.com'),
                primaryPhone: PhoneNumber.withValue(testPhoneNumber),
                secondaryEmails: <EmailAddress>[
                  EmailAddress.withValue('example@mail')
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
                wait: Wait(),
                checkWaitingFor: setToTrue,
                child: const ContactItem(
                  type: ContactInfoType.phone,
                  value: testPhoneNumber,
                  editable: true,
                ),
              ),
            ),
          ),
        );

        // expect to find the gesture detectors when the number is  editable
        expect(find.byKey(const Key('editable_contact_key')), findsOneWidget);
        expect(find.byKey(const Key('delete_contact_key')), findsOneWidget);

        // expect that tapping the edit button calls the upgradeToPrimaryBottomSheet method
        await tester.tap(find.byKey(const Key('editable_contact_key')));
        await tester.pump();

        // expect to find widget in the bottom sheet
        expect(find.byType(SingleChildScrollView), findsOneWidget);
        expect(find.byType(SetContactToPrimary), findsOneWidget);

        await tester.tap(find.byKey(const Key('delete_contact_key')));
        await tester.pump();
        expect(find.byKey(const Key('editable_contact_key')), findsOneWidget);
      });
    });

    testWidgets('should render deleteContactDialogue correctly',
        (WidgetTester tester) async {
      await tester.runAsync(() async {
        bool setToTrue({required String flag}) {
          return false;
        }

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ContactProvider(
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
                checkWaitingFor: setToTrue,
                child: const ContactItem(
                  type: ContactInfoType.phone,
                  value: testPhoneNumber,
                  editable: true,
                ),
              ),
            ),
          ),
        );

        // expect to find the gesture detectors when the number is  editable
        expect(find.byKey(const Key('editable_contact_key')), findsOneWidget);
        expect(find.byKey(const Key('delete_contact_key')), findsOneWidget);

        // expect that tapping the edit button calls the upgradeToPrimaryBottomSheet method

        await tester.tap(find.byKey(const Key('delete_contact_key')));
        await tester.pump();

        // expect to find widget in the bottom sheet
        expect(find.byType(AlertDialog), findsOneWidget);

        await tester.tap(find.byKey(cancelButtonKey));
        await tester.pump();
      });
    });

    testWidgets('should render loader', (WidgetTester tester) async {
      await tester.runAsync(() async {
        bool setToTrue({required String flag}) {
          return true;
        }

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ContactProvider(
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
                checkWaitingFor: setToTrue,
                child: const ContactItem(
                  type: ContactInfoType.phone,
                  value: testPhoneNumber,
                  editable: true,
                ),
              ),
            ),
          ),
        );

        // expect to find the gesture detectors when the number is  editable
        expect(find.byKey(const Key('editable_contact_key')), findsOneWidget);
        expect(find.byKey(const Key('delete_contact_key')), findsOneWidget);

        // expect that tapping the edit button calls the upgradeToPrimaryBottomSheet method

        await tester.tap(find.byKey(const Key('delete_contact_key')));
        await tester.pump();

        expect(find.byType(SILPlatformLoader), findsOneWidget);
      });
    });

    testWidgets('should confirm deleting contact and navigate successfully',
        (WidgetTester tester) async {
      await tester.runAsync(() async {
        bool setToTrue({required String flag}) {
          return false;
        }

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ContactProvider(
                primaryEmail: EmailAddress.withValue('someone@example.com'),
                primaryPhone: PhoneNumber.withValue(testPhoneNumber),
                secondaryEmails: <EmailAddress>[
                  EmailAddress.withValue('example@mail')
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
                wait: Wait(),
                checkWaitingFor: setToTrue,
                child: const ContactItem(
                  type: ContactInfoType.phone,
                  value: testPhoneNumber,
                  editable: true,
                ),
              ),
            ),
          ),
        );

        // expect to find the gesture detectors when the number is  editable
        expect(find.byKey(const Key('editable_contact_key')), findsOneWidget);
        expect(find.byKey(const Key('delete_contact_key')), findsOneWidget);

        // expect that tapping the edit button calls the upgradeToPrimaryBottomSheet method

        await tester.tap(find.byKey(const Key('delete_contact_key')));
        await tester.pump();

        // expect to find widget in the bottom sheet
        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.byKey(confirmButtonKey), findsOneWidget);

        await tester.tap(find.byKey(confirmButtonKey));
      });
    });

    testWidgets('should confirm deleting contact and navigate with error',
        (WidgetTester tester) async {
      await tester.runAsync(() async {
        bool setToTrue({required String flag}) {
          return false;
        }

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
              body: ContactProvider(
                primaryEmail: EmailAddress.withValue('someone@example.com'),
                primaryPhone: PhoneNumber.withValue(testPhoneNumber),
                secondaryEmails: <EmailAddress>[
                  EmailAddress.withValue('example@mail')
                ],
                secondaryPhones: <PhoneNumber>[
                  PhoneNumber.withValue(testPhoneNumber)
                ],
                contactUtils: ContactUtils(
                  toggleLoadingIndicator: (
                      {BuildContext? context, String? flag, bool? show}) {},
                  client: mockShortSILGraphQlClient,
                  updateStateFunc: testUpdateState,
                ),
                wait: Wait(),
                checkWaitingFor: setToTrue,
                child: const ContactItem(
                  type: ContactInfoType.phone,
                  value: testPhoneNumber,
                  editable: true,
                ),
              ),
            ),
          ),
        );

        // expect to find the gesture detectors when the number is  editable
        expect(find.byKey(const Key('editable_contact_key')), findsOneWidget);
        expect(find.byKey(const Key('delete_contact_key')), findsOneWidget);

        // expect that tapping the edit button calls the upgradeToPrimaryBottomSheet method

        await tester.tap(find.byKey(const Key('delete_contact_key')));
        await tester.pump();

        // expect to find widget in the bottom sheet
        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.byKey(confirmButtonKey), findsOneWidget);

        await tester.tap(find.byKey(confirmButtonKey));
      });
    });
  });
}
