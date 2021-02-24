import 'package:async_redux/async_redux.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sil_contacts/contact_items_card.dart';
import 'package:sil_contacts/contact_utils.dart';
import 'package:sil_contacts/sil_contacts.dart';

void main() {
  group('ContactDetails', () {
    testWidgets('renders 4 ContactItemsCard widgets if primaryEmail is defined',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ContactProvider(
              primaryEmail: 'someone@example.com',
              primaryPhone: '+254728101710',
              secondaryEmails: BuiltList<String>(<String>[]),
              secondaryPhones: BuiltList<String>(<String>[]),
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
    });
    testWidgets(
        'renders 3 ContactItemsCard widgets if primaryEmail is not defined',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ContactProvider(
              primaryEmail: 'UNKNOWN',
              primaryPhone: '+254728101710',
              secondaryEmails: BuiltList<String>(<String>[]),
              secondaryPhones: BuiltList<String>(<String>[]),
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
    });
  });
}
