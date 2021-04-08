import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sil_core_domain_objects/value_objects.dart';
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
  });
}
