import 'package:async_redux/async_redux.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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
                  primaryEmail: 'someone@example.com',
                  primaryPhone: '+254728101710',
                  contactUtils: ContactUtils(
                    toggleLoadingIndicator: null,
                    client: null,
                    updateStateFunc: null,
                  ),
                  wait: Wait(),
                  checkWaitingFor: () {},
                  secondaryEmails: const <String>['example@mail'],
                  secondaryPhones: const <String>['+254189123456'],
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
                  primaryEmail: 'UNKNOWN',
                  primaryPhone: '+254728101710',
                  secondaryEmails: const <String>['example@mail'],
                  secondaryPhones: const <String>['+254189123456'],
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

          expect(find.byType(ContactItemsCard), findsNWidgets(3));
          expect(find.byType(ContactDetails), findsOneWidget);
        },
      );
    },
  );
}
