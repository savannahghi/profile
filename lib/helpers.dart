import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:app_wrapper/app_wrapper.dart';
import 'package:flutter_graphql_client/graph_client.dart';
import 'package:flutter_graphql_client/graph_event_bus.dart';
import 'package:shared_ui_components/communications_settings.dart';

import 'mutations.dart';

///[Change Communication Settings]
Future<bool> changeCommunicationSetting(
    {required CommunicationType channel,
    required bool isAllowed,
    required BuildContext context,
    required Map<String, bool>? settings,
    required Function communicationSettingsFunc}) async {
  final Map<String, bool> _variables = <String, bool>{
    'allowEmail': settings!['allowEmail']!,
    'allowWhatsApp': settings['allowWhatsApp']!,
    'allowTextSMS': settings['allowText']!,
    'allowPush': settings['allowPush']!,
  };
  final IGraphQlClient _client = AppWrapperBase.of(context)!.graphQLClient;

  _variables[channel.toShortString()] = isAllowed;

  /// fetch the data from the api
  final Response _result = await _client.query(
    setCommSettingsMutation,
    _variables,
  );

  final Map<String, dynamic> response = _client.toMap(_result);
  // /// check if the response has timeout metadata. If yes, return an error to
  // /// handled correctly
  if (_result.statusCode == 408) {
    return false;
  }

  // // check for errors in the data here
  if (_client.parseError(response) != null) {
    return false;
  }
  communicationSettingsFunc(communicationSettings: _variables);
  return true;
}

///[Set-up as an Experiment Participant]
///function for getting whether a user is set up as an experiment participant
Future<bool?> setupAsExperimentParticipant(
    {required BuildContext context, bool participate = false}) async {
  final IGraphQlClient _client = AppWrapperBase.of(context)!.graphQLClient;

  final Response result = await _client.query(setupUserAsExperimentParticipant,
      setupAsExperimentParticipantVariables());

  final Map<String, dynamic> response = _client.toMap(result);

  SaveTraceLog(
    client: AppWrapperBase.of(context)!.graphQLClient,
    query: setupUserAsExperimentParticipant,
    data: setupAsExperimentParticipantVariables(),
    response: response,
    title: 'Setup user as experiment participant',
    description: 'Setup user as experiment participant',
  ).saveLog();

  if (_client.parseError(response) != null) {
    return null;
  } else {
    final bool responseData =
        response['data']['setupAsExperimentParticipant'] as bool;

    return responseData;
  }
}

/// [formatPhoneNumber]
String formatPhoneNumber(
    {required String countryCode, required String phoneNumber}) {
  final String _countryCode =
      !countryCode.startsWith('+') ? '+$countryCode' : countryCode;

  if (_countryCode == '+1') {
    return '$countryCode$phoneNumber';
  }

  final String _phoneNumber =
      phoneNumber.startsWith('0') ? phoneNumber.substring(1) : phoneNumber;

  return '$_countryCode$_phoneNumber';
}
