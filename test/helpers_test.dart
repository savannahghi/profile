import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_wrapper/app_wrapper.dart';
import 'package:shared_ui_components/buttons.dart';
import 'package:shared_ui_components/communications_settings.dart';
import 'package:user_profile/helpers.dart';

import 'mocks.dart';

void main() {
  group('communication settings', () {
    testWidgets('changeCommunicationSetting works correctly',
        (WidgetTester tester) async {
      final MockSILGraphQlClient mockSILGraphQlClient = MockSILGraphQlClient();
      final Map<String, bool> settings = settingsVariables;
      final Map<String, bool> _variables = <String, bool>{
        'allowEmail': settings['allowEmail']!,
        'allowWhatsApp': settings['allowWhatsApp']!,
        'allowTextSMS': settings['allowText']!,
        'allowPush': settings['allowPush']!,
      };
      dynamic commSettings({required Map<String, bool> communicationSettings}) {
        return _variables;
      }

      bool? response;
      await tester.pumpWidget(Builder(
        builder: (BuildContext context) {
          return MaterialApp(
            home: SILAppWrapperBase(
              appName: 'testAppName',
              appContexts: const <AppContext>[AppContext.BewellCONSUMER],
              graphQLClient: mockSILGraphQlClient,
              deviceCapabilities: MockDeviceCapabilities(),
              child: Scaffold(
                body: LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints box) {
                  return SILPrimaryButton(
                    onPressed: () async {
                      response = await changeCommunicationSetting(
                          context: context,
                          channel: CommunicationType.allowEmail,
                          isAllowed: true,
                          settings: settings,
                          communicationSettingsFunc: commSettings);
                    },
                    text: 'Add',
                  );
                }),
              ),
            ),
          );
        },
      ));

      await tester.pumpAndSettle();

      expect(find.byType(SILPrimaryButton), findsOneWidget);
      await tester.tap(find.byType(SILPrimaryButton));
      await tester.pumpAndSettle();

      expect(response, true);
    });
  });

  group('set up user experiment', () {
    testWidgets('should add user as experiment participant',
        (WidgetTester tester) async {
      final MockSILGraphQlClient mockSILGraphQlClient = MockSILGraphQlClient();
      bool response = false;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SILAppWrapperBase(
            appName: '',
            appContexts: const <AppContext>[AppContext.BewellCONSUMER],
            graphQLClient: mockSILGraphQlClient,
            deviceCapabilities: MockDeviceCapabilities(),
            child: Builder(builder: (BuildContext context) {
              return Center(
                child: SILPrimaryButton(
                  buttonKey: const Key('add_experiment_participant'),
                  onPressed: () async {
                    response = (await setupAsExperimentParticipant(
                        context: context, participate: true))!;
                  },
                ),
              );
            }),
          ),
        ),
      ));

      expect(find.byType(SILAppWrapperBase), findsOneWidget);
      expect(find.byType(SILPrimaryButton), findsOneWidget);

      expect(
          find.byKey(const Key('add_experiment_participant')), findsOneWidget);
      expect(response, false);

      // tap the button to show the toast
      await tester.tap(find.byKey(const Key('add_experiment_participant')));

      expect(response, true);
    });

    testWidgets('should remove user as experiment participant',
        (WidgetTester tester) async {
      final MockSILGraphQlClient mockSILGraphQlClient = MockSILGraphQlClient();
      bool response = false;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SILAppWrapperBase(
            appName: '',
            appContexts: const <AppContext>[AppContext.BewellCONSUMER],
            deviceCapabilities: MockDeviceCapabilities(),
            graphQLClient: mockSILGraphQlClient,
            child: Builder(builder: (BuildContext context) {
              return Center(
                child: SILPrimaryButton(
                  buttonKey: const Key('add_experiment_participant'),
                  onPressed: () async {
                    response = (await setupAsExperimentParticipant(
                      context: context,
                    ))!;
                  },
                ),
              );
            }),
          ),
        ),
      ));

      expect(find.byType(SILAppWrapperBase), findsOneWidget);
      expect(find.byType(SILPrimaryButton), findsOneWidget);

      expect(
          find.byKey(const Key('add_experiment_participant')), findsOneWidget);
      expect(response, false);

      // tap the button to show the toast
      await tester.tap(find.byKey(const Key('add_experiment_participant')));
      expect(response, true);
    });
  });

  test('should test other phone number', () {
    expect(formatPhoneNumber(phoneNumber: '1234567', countryCode: '+255'),
        '+2551234567');

    expect(
      formatPhoneNumber(countryCode: '254', phoneNumber: '790123456'),
      '+254790123456',
    );

    expect(
      formatPhoneNumber(countryCode: '254', phoneNumber: '0790123456'),
      '+254790123456',
    );

    expect(
      formatPhoneNumber(countryCode: '+1', phoneNumber: '100000'),
      '+1100000',
    );

    expect(formatPhoneNumber(countryCode: '+254', phoneNumber: '07100000'),
        '+2547100000');

    expect(formatPhoneNumber(countryCode: '+254', phoneNumber: '0775973716'),
        '+254775973716');
  });
}
