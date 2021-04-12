import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:sil_app_wrapper/sil_app_wrapper.dart';
import 'package:sil_ui_components/sil_buttons.dart';
import 'package:sil_user_profile/contact_utils.dart';

import 'mocks.dart';
import 'test_utils.dart';

void main() {
  void testUpdateState(
      {required BuildContext context,
      required StateContactType type,
      required String? value}) {}
  final MockSILGraphQlClient mockSILGraphQlClient = MockSILGraphQlClient();
  late Map<String, dynamic> result;
  late final Map<String, dynamic> resultOK = <String, dynamic>{
    'status': 'ok',
    'value': true,
  };

  testWidgets('should sendPhoneOtp sucessfully', (WidgetTester tester) async {
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
                  buttonKey: testButtonKey,
                  onPressed: () {
                    testContactProvider(mockSILGraphQlClient, testUpdateState)
                        .contactUtils
                        .sendPhoneOtp(
                            phone: testPhoneNumber,
                            context: context,
                            flag: 'flag');
                  },
                );
              }),
            ),
          ),
        );
      },
    ));

    await tester.tap(find.byKey(testButtonKey));
  });

  testWidgets('should retireSecondaryContact sucessfully',
      (WidgetTester tester) async {
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
                  buttonKey: testButtonKey,
                  onPressed: () {
                    testContactProvider(mockSILGraphQlClient, testUpdateState)
                        .contactUtils
                        .retireSecondaryContact(
                            value: 'value',
                            isPhone: true,
                            context: context,
                            flag: 'flag');
                  },
                );
              }),
            ),
          ),
        );
      },
    ));

    await tester.tap(find.byKey(testButtonKey));
  });

  testWidgets('should verifyAddPrimaryEmailOtp sucessfully',
      (WidgetTester tester) async {
    final TextEditingController controller = TextEditingController();
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
                  buttonKey: testButtonKey,
                  onPressed: () {
                    testContactProvider(mockSILGraphQlClient, testUpdateState)
                        .contactUtils
                        .verifyAddPrimaryEmailOtp(
                            context: context,
                            flag: 'flag',
                            controller: controller,
                            email: '',
                            otp: '1234',
                            toggleInvalidCodeMsg: () {},
                            userInput: '1234');
                  },
                );
              }),
            ),
          ),
        );
      },
    ));

    await tester.tap(find.byKey(testButtonKey));
    expect(find.byType(HapticFeedback), findsNothing);
  });

  testWidgets('should show error when verifyAddPrimaryEmailOtp',
      (WidgetTester tester) async {
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

    final TextEditingController controller = TextEditingController();
    await tester.pumpWidget(Builder(
      builder: (BuildContext context) {
        return MaterialApp(
          home: SILAppWrapperBase(
            appName: 'testAppName',
            appContexts: const <AppContext>[AppContext.BewellCONSUMER],
            graphQLClient: mockShortSILGraphQlClient,
            deviceCapabilities: MockDeviceCapabilities(),
            child: Scaffold(
              body: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints box) {
                return SILPrimaryButton(
                  buttonKey: testButtonKey,
                  onPressed: () {
                    testContactProvider(
                            mockShortSILGraphQlClient, testUpdateState)
                        .contactUtils
                        .verifyAddPrimaryEmailOtp(
                            context: context,
                            flag: 'flag',
                            controller: controller,
                            email: '',
                            otp: '1234',
                            toggleInvalidCodeMsg: (_) {},
                            userInput: '1234');
                  },
                );
              }),
            ),
          ),
        );
      },
    ));

    await tester.tap(find.byKey(testButtonKey));
    expect(find.byType(HapticFeedback), findsNothing);
  });

  testWidgets('should not verifyAddPrimaryEmailOtp when otp does not match',
      (WidgetTester tester) async {
    final TextEditingController controller = TextEditingController();
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
                  buttonKey: testButtonKey,
                  onPressed: () {
                    testContactProvider(mockSILGraphQlClient, testUpdateState)
                        .contactUtils
                        .verifyAddPrimaryEmailOtp(
                            context: context,
                            flag: 'flag',
                            controller: controller,
                            email: '',
                            otp: '1234',
                            toggleInvalidCodeMsg: (_) {},
                            userInput: '4321');
                  },
                );
              }),
            ),
          ),
        );
      },
    ));

    await tester.tap(find.byKey(testButtonKey));
    await tester.pumpAndSettle();
    expect(controller.value.text, '');
  });

  testWidgets('should addSecondaryPhone sucessfully',
      (WidgetTester tester) async {
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
                  buttonKey: testButtonKey,
                  onPressed: () async {
                    result = await testContactProvider(
                            mockSILGraphQlClient, testUpdateState)
                        .contactUtils
                        .addSecondaryPhone(
                            context: context, phoneNumber: testPhoneNumber);
                  },
                );
              }),
            ),
          ),
        );
      },
    ));

    await tester.tap(find.byKey(testButtonKey));
    expect(result, resultOK);
  });

  testWidgets('should addSecondaryEmail sucessfully',
      (WidgetTester tester) async {
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
                  buttonKey: testButtonKey,
                  onPressed: () async {
                    result = await testContactProvider(
                            mockSILGraphQlClient, testUpdateState)
                        .contactUtils
                        .addSecondaryEmail(context: context, email: testEmail);
                  },
                );
              }),
            ),
          ),
        );
      },
    ));

    await tester.tap(find.byKey(testButtonKey));
    expect(result, resultOK);
  });

  testWidgets('should setPrimaryEmail sucessfully',
      (WidgetTester tester) async {
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
                  buttonKey: testButtonKey,
                  onPressed: () async {
                    result = await testContactProvider(
                            mockSILGraphQlClient, testUpdateState)
                        .contactUtils
                        .setPrimaryEmail(
                          context: context,
                          email: testEmail,
                          otp: testOTP,
                        );
                  },
                );
              }),
            ),
          ),
        );
      },
    ));

    await tester.tap(find.byKey(testButtonKey));
    await tester.pumpAndSettle();
    expect(result, resultOK);
  });

  testWidgets('should render genericAddContact when primary is true',
      (WidgetTester tester) async {
    String? otp;
    void setOtp(String val) {
      otp = val;
    }

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
                  buttonKey: testButtonKey,
                  onPressed: () {
                    testContactProvider(mockSILGraphQlClient, testUpdateState)
                        .contactUtils
                        .genericAddContact(
                          context: context,
                          flag: 'add_contact_info',
                          primary: true,
                          setOtp: setOtp,
                          type: ContactInfoType.phone,
                          value: testPhoneNumber,
                        );
                  },
                );
              }),
            ),
          ),
        );
      },
    ));

    await tester.tap(find.byKey(testButtonKey));
    await tester.pumpAndSettle();
    expect(otp, testOTP);
  });

  testWidgets(
      'should render genericAddContact when primary is false and ContactInfoType is phone',
      (WidgetTester tester) async {
    final MockShortSILGraphQlClient mockShortSILGraphQlClient =
        MockShortSILGraphQlClient.withResponse(
      'idToken',
      'endpoint',
      http.Response(
          json.encode(
            <String, dynamic>{
              'data': <String, dynamic>{'addSecondaryPhoneNumber': true}
            },
          ),
          201),
    );

    await tester.pumpWidget(Builder(
      builder: (BuildContext context) {
        return MaterialApp(
          home: SILAppWrapperBase(
            appName: 'testAppName',
            appContexts: const <AppContext>[AppContext.BewellCONSUMER],
            graphQLClient: mockShortSILGraphQlClient,
            deviceCapabilities: MockDeviceCapabilities(),
            child: Scaffold(
              body: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints box) {
                return SILPrimaryButton(
                  buttonKey: testButtonKey,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<dynamic>(
                          builder: (BuildContext context) =>
                              BuildGenericAddContactTest(
                                mockShortSILGraphQlClient:
                                    mockShortSILGraphQlClient,
                                type: ContactInfoType.phone,
                                primary: false,
                              )),
                    );
                  },
                );
              }),
            ),
          ),
        );
      },
    ));

    await tester.tap(find.byKey(testButtonKey));
    await tester.pumpAndSettle();

    expect(find.byKey(testGenericButtonKey), findsOneWidget);
    await tester.tap(find.byKey(testGenericButtonKey));
    await tester.pumpAndSettle();
  });

  testWidgets(
      'should render genericAddContact when primary is false and ContactInfoType is email',
      (WidgetTester tester) async {
    final MockShortSILGraphQlClient mockShortSILGraphQlClient =
        MockShortSILGraphQlClient.withResponse(
      'idToken',
      'endpoint',
      http.Response(
          json.encode(
            <String, dynamic>{
              'data': <String, dynamic>{'emailVerificationOTP': testOTP}
            },
          ),
          200),
    );
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
                  buttonKey: testButtonKey,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<dynamic>(
                          builder: (BuildContext context) =>
                              BuildGenericAddContactTest(
                                mockShortSILGraphQlClient:
                                    mockShortSILGraphQlClient,
                                type: ContactInfoType.email,
                                primary: true,
                              )),
                    );
                  },
                );
              }),
            ),
          ),
        );
      },
    ));

    await tester.tap(find.byKey(testButtonKey));
    await tester.pumpAndSettle();

    expect(find.byKey(testGenericButtonKey), findsOneWidget);
    await tester.tap(find.byKey(testGenericButtonKey));
    await tester.pumpAndSettle();
  });

  testWidgets(
      'should render genericAddContact and navigate with error when primary is true',
      (WidgetTester tester) async {
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

    await tester.pumpWidget(Builder(
      builder: (BuildContext context) {
        return MaterialApp(
          home: Scaffold(
            body: Builder(builder: (BuildContext context) {
              return SILPrimaryButton(
                buttonKey: testButtonKey,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<dynamic>(
                        builder: (BuildContext context) =>
                            BuildGenericAddContactTest(
                              mockShortSILGraphQlClient:
                                  mockShortSILGraphQlClient,
                              type: ContactInfoType.phone,
                              primary: true,
                            )),
                  );
                },
              );
            }),
          ),
        );
      },
    ));

    await tester.tap(find.byKey(testButtonKey));
    await tester.pumpAndSettle();

    expect(find.byKey(testGenericButtonKey), findsOneWidget);
    await tester.tap(find.byKey(testGenericButtonKey));
    await tester.pumpAndSettle();

    expect(find.byKey(testGenericButtonKey), findsNothing);
  });

  testWidgets(
      'should render genericAddContact and navigate with error when primary is false',
      (WidgetTester tester) async {
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

    await tester.pumpWidget(Builder(
      builder: (BuildContext context) {
        return MaterialApp(
          home: Scaffold(
            body: Builder(builder: (BuildContext context) {
              return SILPrimaryButton(
                buttonKey: testButtonKey,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<dynamic>(
                        builder: (BuildContext context) =>
                            BuildGenericAddContactTest(
                              mockShortSILGraphQlClient:
                                  mockShortSILGraphQlClient,
                              type: ContactInfoType.phone,
                              primary: false,
                            )),
                  );
                },
              );
            }),
          ),
        );
      },
    ));

    await tester.tap(find.byKey(testButtonKey));
    await tester.pumpAndSettle();

    expect(find.byKey(testGenericButtonKey), findsOneWidget);
    await tester.tap(find.byKey(testGenericButtonKey));
    await tester.pumpAndSettle();

    expect(find.byKey(testGenericButtonKey), findsNothing);
  });
}

class BuildGenericAddContactTest extends StatelessWidget {
  const BuildGenericAddContactTest({
    Key? key,
    required this.mockShortSILGraphQlClient,
    required this.type,
    required this.primary,
  }) : super(key: key);

  final MockShortSILGraphQlClient mockShortSILGraphQlClient;
  final ContactInfoType type;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    void testUpdateState(
        {required BuildContext context,
        required StateContactType type,
        required String? value}) {}
    return SILAppWrapperBase(
      appName: 'testAppName',
      appContexts: const <AppContext>[AppContext.BewellCONSUMER],
      graphQLClient: mockShortSILGraphQlClient,
      deviceCapabilities: MockDeviceCapabilities(),
      child: Scaffold(
        body:
            LayoutBuilder(builder: (BuildContext context, BoxConstraints box) {
          return SILPrimaryButton(
            buttonKey: testGenericButtonKey,
            onPressed: () {
              testContactProvider(mockShortSILGraphQlClient, testUpdateState)
                  .contactUtils
                  .genericAddContact(
                    context: context,
                    flag: 'add_contact_info',
                    primary: primary,
                    setOtp: (String val) {},
                    type: type,
                    value: testPhoneNumber,
                  );
            },
          );
        }),
      ),
    );
  }
}
