import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sil_ui_components/sil_buttons.dart';
import 'package:sil_ui_components/sil_inputs.dart';
import 'package:sil_user_profile/add_contact.dart';
import 'package:sil_user_profile/contact_utils.dart';

import 'test_utils.dart';

void main() {
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
  });
}
