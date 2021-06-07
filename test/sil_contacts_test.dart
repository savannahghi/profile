import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:async_redux/async_redux.dart';

import 'package:sil_core_domain_objects/value_objects.dart';
import 'package:sil_ui_components/sil_buttons.dart';
import 'package:sil_ui_components/sil_inputs.dart';
import 'package:sil_user_profile/constants.dart';
import 'package:sil_user_profile/contact_items_card.dart';
import 'package:sil_user_profile/contact_utils.dart';
import 'package:sil_user_profile/shared/widget_keys.dart';
import 'package:sil_user_profile/sil_contacts.dart';

import 'mocks.dart';
import 'test_utils.dart';

void main() {
  group(
    'ContactDetails',
    () {
      void testUpdateState(
          {required BuildContext context,
          required StateContactType type,
          required String? value}) {}
      final MockSILGraphQlClient mockSILGraphQlClient = MockSILGraphQlClient();

      bool checkWaitingFor({required String flag}) {
        return false;
      }

      testWidgets(
        'renders 2 ContactItemsCard widgets if primaryEmail is defined',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: ContactProvider(
                  primaryEmail: EmailAddress.withValue('someone@example.com'),
                  primaryPhone: PhoneNumber.withValue(testPhoneNumber),
                  secondaryEmails: <EmailAddress>[
                    EmailAddress.withValue('example@mail.com')
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
                  child: const ContactDetails(),
                ),
              ),
            ),
          );

          expect(find.byType(ContactItemsCard), findsNWidgets(2));
          expect(find.byType(ContactDetails), findsOneWidget);
        },
      );
      testWidgets(
        'renders 3 ContactItemsCard widgets if primaryEmail is not defined',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: ContactProvider(
                  primaryEmail: EmailAddress.withValue(UNKNOWNEMAIL),
                  primaryPhone: PhoneNumber.withValue(testPhoneNumber),
                  secondaryEmails: <EmailAddress>[
                    EmailAddress.withValue('example@mail.com')
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
                  child: const ContactDetails(),
                ),
              ),
            ),
          );

          expect(find.byType(ContactItemsCard), findsNWidgets(2));
          expect(find.byType(ContactDetails), findsOneWidget);
        },
      );

      testWidgets(
        'should onAddContactInfo if primaryEmail is UNKNOWN',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: ContactProvider(
                  primaryEmail: EmailAddress.withValue(UNKNOWNEMAIL),
                  primaryPhone: PhoneNumber.withValue(testPhoneNumber),
                  secondaryEmails: <EmailAddress>[
                    EmailAddress.withValue('example@mail.com')
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
                  checkWaitingFor: checkWaitingFor,
                  child: const ContactDetails(),
                ),
              ),
            ),
          );
          expect(find.byType(ContactItemsCard), findsNWidgets(2));
          expect(find.byType(ContactDetails), findsOneWidget);

          expect(find.byKey(const Key(primaryEmail)).first, findsOneWidget);
          await tester.tap(find.byKey(const Key(primaryEmail)));
          await tester.pumpAndSettle();

          expect(find.byKey(addEmailAddressKey), findsOneWidget);

          await tester.enterText(find.byKey(addEmailAddressKey), ' ');
          await tester.pumpAndSettle();

          expect(find.byKey(saveButtonKey), findsOneWidget);
          await tester.tap(find.byKey(saveButtonKey));
          await tester.pumpAndSettle();
          expect(find.text(emailValidationMessage), findsOneWidget);
        },
      );

      testWidgets(
        'should onAddContactInfo if primaryEmail is not UNKNOWN',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: ContactProvider(
                  primaryEmail: EmailAddress.withValue(testEmail),
                  primaryPhone: PhoneNumber.withValue(testPhoneNumber),
                  secondaryEmails: <EmailAddress>[
                    EmailAddress.withValue(testEmail),
                    EmailAddress.withValue(testEmail)
                  ],
                  secondaryPhones: <PhoneNumber>[
                    PhoneNumber.withValue(testPhoneNumber),
                    PhoneNumber.withValue(testPhoneNumber)
                  ],
                  contactUtils: ContactUtils(
                    toggleLoadingIndicator: () {},
                    client: mockSILGraphQlClient,
                    updateStateFunc: testUpdateState,
                  ),
                  wait: Wait(),
                  checkWaitingFor: checkWaitingFor,
                  child: const ContactDetails(),
                ),
              ),
            ),
          );

          expect(find.byType(ContactItemsCard), findsNWidgets(2));
          expect(find.byType(ContactDetails), findsOneWidget);
        },
      );

      testWidgets('should test updateShouldNotify function',
          (WidgetTester tester) async {
        bool result = true;
        await tester.pumpWidget(MaterialApp(
          home: Builder(builder: (BuildContext context) {
            return Scaffold(
                body: Center(
                    child: MaterialButton(
                        onPressed: () {
                          result = ContactProvider(
                            primaryEmail: EmailAddress.withValue(testEmail),
                            primaryPhone:
                                PhoneNumber.withValue(testPhoneNumber),
                            secondaryEmails: <EmailAddress>[
                              EmailAddress.withValue(testEmail),
                              EmailAddress.withValue(testEmail)
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
                            child: const ContactDetails(),
                          ).updateShouldNotify(ContactProvider(
                            primaryEmail: EmailAddress.withValue(testEmail),
                            primaryPhone:
                                PhoneNumber.withValue(testPhoneNumber),
                            secondaryEmails: <EmailAddress>[
                              EmailAddress.withValue(testEmail),
                              EmailAddress.withValue('test@test.com')
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
                            child: const ContactDetails(),
                          ));
                        },
                        child: const Text('Launch'))));
          }),
        ));
        await tester.tap(find.byType(MaterialButton));
        await tester.pump();

        expect(result, false);
      });

      testWidgets(
        'refreshFunc is called',
        (WidgetTester tester) async {
          int counter = 0;
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: ContactProvider(
                  primaryEmail: EmailAddress.withValue(UNKNOWNEMAIL),
                  primaryPhone: PhoneNumber.withValue(testPhoneNumber),
                  secondaryEmails: <EmailAddress>[
                    EmailAddress.withValue('example@mail.com')
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
                  checkWaitingFor: checkWaitingFor,
                  child: ContactDetails(
                    onContactSaved: () {
                      counter = counter + 1;
                    },
                  ),
                ),
              ),
            ),
          );

          /// verify renders
          expect(find.byType(ContactItemsCard), findsNWidgets(2));
          expect(find.byType(ContactDetails), findsOneWidget);
          expect(counter, 0);

          /// tap add primary email btn
          expect(find.byKey(const Key(primaryEmail)).first, findsOneWidget);
          await tester.tap(find.byKey(const Key(primaryEmail)));
          await tester.pumpAndSettle();

          /// confirm email text input is present
          expect(find.byKey(addEmailAddressKey), findsOneWidget);

          /// add test email value
          await tester.enterText(find.byKey(addEmailAddressKey), testEmail);
          await tester.pumpAndSettle();

          /// confirm save btn is present & press
          expect(find.byKey(saveButtonKey), findsOneWidget);
          await tester.tap(find.byKey(saveButtonKey));
          await tester.pumpAndSettle();

          /// confirm otp pin code input is present
          expect(find.byType(SILPinCodeTextField), findsOneWidget);

          /// Pop navigation
          // Use didPopRoute() to simulate the system back button. Check that
          // didPopRoute() indicates that the notification was handled.
          final dynamic widgetsAppState = tester.state(find.byType(WidgetsApp));
          expect(await widgetsAppState.didPopRoute(), isTrue);
          await tester.pumpAndSettle();

          /// confirm otp input is out of view
          expect(find.byType(SILPinCodeTextField), findsNothing);
        },
      );

      testWidgets(
        'refreshFunc works',
        (WidgetTester tester) async {
          final Map<String, String> result = <String, String>{
            'message': 'refresh function called',
          };
          int counter = 0;
          await tester.pumpWidget(
            MaterialApp(
              home: Builder(builder: (BuildContext context) {
                return Scaffold(
                  body: SILPrimaryButton(
                    buttonKey: pressText,
                    onPressed: () {
                      ContactUtils(
                        toggleLoadingIndicator: (
                            {BuildContext? context,
                            String? flag,
                            bool? show}) {},
                        client: mockSILGraphQlClient,
                        updateStateFunc: testUpdateState,
                      ).showMessageFromModal(context, result,
                          afterCallback: () {
                        counter = counter + 1;
                      });
                    },
                    text: 'Press',
                  ),
                );
              }),
            ),
          );

          expect(counter, 0);
          await tester.tap(find.byKey(const Key('press')));
          await tester.pumpAndSettle();
          expect(counter, 1);
        },
      );
    },
  );
}
