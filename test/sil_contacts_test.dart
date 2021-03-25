import 'package:async_redux/async_redux.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sil_core_domain_objects/value_objects.dart';
import 'package:sil_user_profile/contact_items_card.dart';
import 'package:sil_user_profile/contact_utils.dart';
import 'package:sil_user_profile/sil_contacts.dart';

void main() {
  group(
    'ContactDetails',
    () {
      testWidgets(
        'renders 4 ContactItemsCard widgets if primaryEmail is defined',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: ContactProvider(
                  primaryEmail: EmailAddress.withValue('someone@example.com'),
                  primaryPhone: PhoneNumber.withValue('+254728101710'),
                  secondaryEmails: <EmailAddress>[
                    EmailAddress.withValue('example@mail.com')
                  ],
                  secondaryPhones: <PhoneNumber>[
                    PhoneNumber.withValue('+254189123456')
                  ],
                  contactUtils: ContactUtils(
                    toggleLoadingIndicator: null,
                    client: null,
                    updateStateFunc: null,
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
        'renders 2 ContactItemsCard widgets if primaryEmail is not defined',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: ContactProvider(
                  primaryEmail: null,
                  primaryPhone: PhoneNumber.withValue('+254728101710'),
                  secondaryEmails: <EmailAddress>[
                    EmailAddress.withValue('example@mail.com')
                  ],
                  secondaryPhones: <PhoneNumber>[
                    PhoneNumber.withValue('+254189123456')
                  ],
                  contactUtils: ContactUtils(
                    toggleLoadingIndicator: null,
                    client: null,
                    updateStateFunc: null,
                  ),
                  wait: Wait(),
                  checkWaitingFor: () {},
                  child: ContactDetails(),
                ),
              ),
            ),
          );

          expect(find.byType(ContactItemsCard), findsNWidgets(2));
          expect(find.byType(ContactDetails), findsOneWidget);
        },
      );
    },
  );
}
