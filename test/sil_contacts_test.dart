import 'package:async_redux/async_redux.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sil_core_domain_objects/value_objects.dart';
import 'package:sil_user_profile/contact_items_card.dart';
import 'package:sil_user_profile/contact_utils.dart';
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
      testWidgets(
        'renders 4 ContactItemsCard widgets if primaryEmail is defined',
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
                  child: ContactDetails(),
                ),
              ),
            ),
          );

          expect(find.byType(ContactItemsCard), findsNWidgets(4));
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
                  primaryEmail: EmailAddress.withValue(UNKNOWN),
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
                  child: ContactDetails(),
                ),
              ),
            ),
          );

          expect(find.byType(ContactItemsCard), findsNWidgets(3));
          expect(find.byType(ContactDetails), findsOneWidget);
        },
      );
    },
  );
}
