// ignore: subtype_of_sealed_class
import 'dart:convert';

import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:sil_app_wrapper/sil_app_wrapper.dart';
import 'package:sil_graphql_client/graph_client.dart';

class MockDeviceCapabilities extends IDeviceCapabilities {}

class MockSILGraphQlClient extends Mock implements ISILGraphQlClient {
  String setupUserAsExperimentorVariables =
      json.encode(<String, bool>{'participate': true});
  String removeUserAsExperimentorVariables =
      json.encode(<String, bool>{'participate': false});

  @override
  Future<Response> query(String queryString, Map<String, dynamic> variables,
      [ContentType contentType = ContentType.json]) {
    if (json.encode(variables) == setupUserAsExperimentorVariables) {
      return Future<Response>.value(
        Response(
            json.encode(<String, dynamic>{
              'data': <String, dynamic>{'setupAsExperimentParticipant': true}
            }),
            200),
      );
    }

    if (json.encode(variables) == removeUserAsExperimentorVariables) {
      return Future<Response>.value(
        Response(
            json.encode(<String, dynamic>{
              'data': <String, dynamic>{'setupAsExperimentParticipant': true}
            }),
            200),
      );
    }
    if (queryString.contains('setUserCommunicationsSettings')) {
      return Future<Response>.value(
        Response(
            json.encode(<String, dynamic>{
              'data': <String, dynamic>{
                'setUserCommunicationsSettings': <String, dynamic>{
                  'allowWhatsApp': true,
                  'allowPush': false,
                  'allowEmail': true,
                  'allowTextSMS': true
                }
              }
            }),
            201),
      );
    }
    if (queryString.contains('Trace')) {
      /// return fake data here
      return Future<Response>.value(
        Response(
            json.encode(
              <String, dynamic>{
                'data': <String, dynamic>{'logDebugInfo': true}
              },
            ),
            201),
      );
    }
    if (queryString.contains('upload')) {
      return Future<Response>.value(
        Response(
            json.encode(<String, dynamic>{
              'data': <String, dynamic>{
                'upload': <String, dynamic>{
                  'id': 'uploadID',
                },
              }
            }),
            201),
      );
    }

    if (queryString.contains('UpdateUserProfile')) {
      return Future<Response>.value(
        Response(json.encode(<String, dynamic>{'error': 'error'}), 201),
      );
    }
    return Future<Response>.value();
  }

  @override
  Map<String, dynamic> toMap(Response? response) {
    if (response == null) return <String, dynamic>{};
    final dynamic _res = json.decode(response.body);
    if (_res is List<dynamic>) return _res[0] as Map<String, dynamic>;
    return _res as Map<String, dynamic>;
  }
}

final Map<String, bool> settingsVariables = <String, bool>{
  'allowEmail': true,
  'allowText': true,
  'allowWhatsApp': true,
  'allowPush': true,
};
