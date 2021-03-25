import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sil_core_domain_objects/value_objects.dart';
import 'package:sil_user_profile/contact_item.dart';
import 'package:sil_user_profile/contact_utils.dart';
import 'package:sil_user_profile/sil_contacts.dart';
import 'package:sil_user_profile/constants.dart';

void main() {
  group('ContactItem', () {
    testWidgets(
        'renders correctly when the item is type phone and  not editable',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ContactProvider(
              primaryEmail: EmailAddress.withValue('someone@example.com'),
              primaryPhone: PhoneNumber.withValue('+254728101710'),
              secondaryEmails: <EmailAddress>[
                EmailAddress.withValue('example@mail')
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
              child: const ContactItem(
                type: ContactInfoType.phone,
                value: '0712345678',
              ),
            ),
          ),
        ),
      );
      // expect to find the guesture detector when the number is not editable
      expect(find.byKey(const Key('not_editable_contact_key')), findsOneWidget);

      // expect that tapping the button calls the primaryContactInfo method
      await tester.tap(find.byKey(const Key('not_editable_contact_key')));
      await tester.pumpAndSettle();

      // expect to find widget in the bottom sheet
      expect(find.text(phoneTitle), findsOneWidget);
      expect(find.text('0712345678'), findsWidgets);
      expect(find.text(closeText), findsOneWidget);

      //expect to find the close button
      expect(find.byKey(const Key('close_key')), findsOneWidget);

      //expect tapping the close button closes the bottom sheet
      await tester.tap(find.byKey(const Key('close_key')));
      await tester.pumpAndSettle();

      expect(find.text(phoneTitle), findsNothing);
      expect(find.text('0712345678'), findsOneWidget);
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
              primaryPhone: PhoneNumber.withValue('+254728101710'),
              secondaryEmails: <EmailAddress>[
                EmailAddress.withValue('example@mail')
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
              child: const ContactItem(
                type: ContactInfoType.email,
                value: 'someone@example.com',
              ),
            ),
          ),
        ),
      );
      // expect to find the guesture detector when the number is not editable
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
      // await tester.runAsync(() async {
      bool setToTrue({required String flag}) {
        return true;
      }

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ContactProvider(
              primaryEmail: EmailAddress.withValue('someone@example.com'),
              primaryPhone: PhoneNumber.withValue('+254728101710'),
              secondaryEmails: <EmailAddress>[
                EmailAddress.withValue('example@mail')
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
              checkWaitingFor: setToTrue,
              child: const ContactItem(
                type: ContactInfoType.phone,
                value: '0712345678',
                editable: true,
              ),
            ),
          ),
        ),
      );

      // expect to find the guesture detectors when the number is  editable
      expect(find.byKey(const Key('editable_contact_key')), findsOneWidget);
      expect(find.byKey(const Key('delete_contact_key')), findsOneWidget);

      // expect that tapping the edit button calls the upgradeToPrimaryBottomSheet method

      // await tester.tap(find.byKey(const Key('editable_contact_key')));
      // await tester.pump();

      // expect to find widget in the bottom sheet
      // expect(find.byType(SingleChildScrollView), findsOneWidget);

      // expect(find.byType(SetContactToPrimary), findsOneWidget);
    });
    // });
  });
}
