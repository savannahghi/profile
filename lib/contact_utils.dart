import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sil_contacts/sil_contacts.dart';
import 'package:sil_contacts/utils/constants.dart';
import 'package:sil_dumb_widgets/sil_snackbar.dart';

import 'package:http/http.dart' as http;
import 'package:sil_themes/constants.dart';

enum StateContactType {
  primaryEmail,
  primaryPhone,
  secondaryEmails,
  secondaryPhones,
  setPrimaryEmail,
  setPrimaryPhone,
  retireSecondaryEmail,
  retireSecondaryPhone,
}

enum ContactInfoType {
  phone,
  email,
}

typedef UpdateStateFunc = void Function(
    {@required BuildContext context,
    @required StateContactType type,
    @required String value});

class ContactUtils {
  final Function toggleLoadingIndicator;
  final dynamic client;
  final UpdateStateFunc updateStateFunc;

  ContactUtils({
    @required this.toggleLoadingIndicator,
    @required this.client,
    @required this.updateStateFunc,
  });

  static bool validateEmail(String email) {
    return emailValidator.hasMatch(email);
  }

  /// adds a primary email to an account
  Future<Map<String, dynamic>> addPrimaryEmail(
      {@required BuildContext context,
      @required String email,
      @required String otp}) async {
    try {
      final http.Response result =
          await client.query(setPrimaryEmailQuery, <String, dynamic>{
        'email': email,
        'otp': otp,
      });
      final Map<String, dynamic> body = client.toMap(result);
      if (client.parseError(body) != null) {
        return <String, dynamic>{
          'status': 'error',
        };
      }

      /// update user profile with the primary email
      updateStateFunc(
          context: context, type: StateContactType.primaryEmail, value: email);

      return <String, dynamic>{
        'status': 'ok',
        'value': json.decode(result.body)['data']['addPrimaryEmailAddress'],
      };
    } catch (e) {
      return <String, dynamic>{
        'status': 'error',
      };
    }
  }

  Future<Map<String, dynamic>> addSecondaryPhone(
      {@required BuildContext context, @required String phoneNumber}) async {
    try {
      final http.Response result =
          await client.query(addSecondaryPhoneQuery, <String, dynamic>{
        'phone': <String>[phoneNumber],
      });
      final Map<String, dynamic> body = client.toMap(result);
      if (client.parseError(body) != null) {
        return <String, dynamic>{
          'status': 'error',
        };
      }

      /// update user profile with the secondary phone number
      updateStateFunc(
          context: context,
          type: StateContactType.secondaryPhones,
          value: phoneNumber);

      return <String, dynamic>{
        'status': 'ok',
        'value': json.decode(result.body)['data']['addSecondaryPhoneNumber'],
      };
    } catch (e) {
      return <String, dynamic>{
        'status': 'error',
      };
    }
  }

  Future<Map<String, dynamic>> addSecondaryEmail(
      {@required BuildContext context, @required String email}) async {
    try {
      final http.Response result =
          await client.query(addSecondaryEmailQuery, <String, dynamic>{
        'email': <String>[email],
      });
      final Map<String, dynamic> body = client.toMap(result);
      if (client.parseError(body) != null) {
        return <String, dynamic>{
          'status': 'error',
        };
      }

      /// update user profile with the secondary email
      updateStateFunc(
          context: context,
          type: StateContactType.secondaryEmails,
          value: email);
      return <String, dynamic>{
        'status': 'ok',
        'value': json.decode(result.body)['data']['addSecondaryEmailAddress'],
      };
    } catch (e) {
      return <String, dynamic>{
        'status': 'error',
      };
    }
  }

  Future<void> genericAddContact({
    @required BuildContext context,
    @required String value,
    @required ContactInfoType type,
    @required Function setOtp,
    @required String flag,
    @required bool primary,
  }) async {
    toggleLoadingIndicator(context: context, flag: flag);
    // add primary contact info
    if (primary) {
      Map<String, dynamic> result =
          await sendEmailOtp(email: value, context: context);
      if (result['status'] == 'error') {
        Navigator.pop(context, <String, String>{
          'status': 'error',
          'message': ContactDetailsStrings.sendOtpError(value),
        });
        return;
      }
      setOtp(result['otp']);
      return;
    }

    // add secondary contact info
    Map<String, dynamic> result;
    if (type == ContactInfoType.phone) {
      result = await addSecondaryPhone(context: context, phoneNumber: value);
    }

    if (type == ContactInfoType.email) {
      result = await addSecondaryEmail(context: context, email: value);
    }
    if (result['status'] == 'error') {
      toggleLoadingIndicator(context: context, flag: flag, show: false);
      Navigator.pop(context, <String, String>{
        'status': 'error',
        'message': ContactDetailsStrings.addContactFeedback(value, true)
      });
      return;
    }
    toggleLoadingIndicator(context: context, flag: flag, show: false);
    Navigator.pop(context, <String, String>{
      'status': 'ok',
      'message': ContactDetailsStrings.addContactFeedback(value)
    });
  }

  Future<Map<String, dynamic>> setPrimaryEmail(
      {@required BuildContext context,
      @required String email,
      @required String otp}) async {
    try {
      final http.Response result =
          await client.query(setPrimaryEmailQuery, <String, dynamic>{
        'email': email,
        'otp': otp,
      });
      final Map<String, dynamic> body = client.toMap(result);
      if (client.parseError(body) != null) {
        return <String, dynamic>{
          'status': 'error',
        };
      }

      /// update user profile with the secondary email as primary
      updateStateFunc(
          context: context,
          type: StateContactType.setPrimaryEmail,
          value: email);
      return <String, dynamic>{
        'status': 'ok',
        'value': json.decode(result.body)['data']['setPrimaryEmailAddress'],
      };
    } catch (e) {
      return <String, dynamic>{
        'status': 'error',
      };
    }
  }

  Future<Map<String, dynamic>> setPrimaryPhone(
      {@required BuildContext context,
      @required String phoneNumber,
      @required String otp}) async {
    try {
      final http.Response result =
          await client.query(setPrimaryPhoneQuery, <String, dynamic>{
        'phone': phoneNumber,
        'otp': otp,
      });
      final Map<String, dynamic> body = client.toMap(result);
      if (client.parseError(body) != null) {
        return <String, dynamic>{
          'status': 'error',
        };
      }

      /// update user profile with the secondary phone number as primary
      updateStateFunc(
          context: context,
          type: StateContactType.setPrimaryPhone,
          value: phoneNumber);
      return <String, dynamic>{
        'status': 'ok',
        'value': json.decode(result.body)['data']['setPrimaryPhoneNumber'],
      };
    } catch (e) {
      return <String, dynamic>{
        'status': 'error',
      };
    }
  }

  Future<Map<String, dynamic>> sendEmailOtp(
      {@required String email,
      @required BuildContext context,
      String flag = 'add_contact_info'}) async {
    try {
      final http.Response result =
          await client.query(generateEmailOTPQuery, <String, dynamic>{
        'email': email,
      });
      toggleLoadingIndicator(context: context, flag: flag, show: false);
      final Map<String, dynamic> body = client.toMap(result);
      if (client.parseError(body) != null) {
        return <String, dynamic>{
          'status': 'error',
        };
      }
      return <String, dynamic>{
        'status': 'ok',
        'otp': json.decode(result.body)['data']['emailVerificationOTP'],
      };
    } catch (e) {
      return <String, dynamic>{
        'status': 'error',
      };
    }
  }

  Future<Map<String, dynamic>> sendPhoneOtp(
      {@required String phone,
      @required BuildContext context,
      String flag = 'add_contact_info'}) async {
    try {
      final http.Response result =
          await client.query(generateOTPQuery, <String, dynamic>{
        'msisdn': phone,
      });
      toggleLoadingIndicator(context: context, flag: flag, show: false);
      final Map<String, dynamic> body = client.toMap(result);
      if (client.parseError(body) != null) {
        return <String, dynamic>{
          'status': 'error',
        };
      }
      return <String, dynamic>{
        'status': 'ok',
        'otp': json.decode(result.body)['data']['generateOTP'],
      };
    } catch (e) {
      return <String, dynamic>{
        'status': 'error',
      };
    }
  }

  Future<Map<String, dynamic>> retireSecondaryContact(
      {@required String value,
      @required bool isPhone,
      @required BuildContext context,
      @required String flag}) async {
    Map<String, dynamic> variables;
    if (isPhone) {
      variables = <String, dynamic>{
        'phones': <String>[value],
      };
    } else {
      variables = <String, dynamic>{
        'emails': <String>[value],
      };
    }
    try {
      final http.Response result = await client.query(
          isPhone ? retireSecondaryPhoneQuery : retireSecondaryEmailQuery,
          variables);
      toggleLoadingIndicator(context: context, flag: flag, show: false);
      final Map<String, dynamic> body = client.toMap(result);
      if (client.parseError(body) != null) {
        return <String, dynamic>{
          'status': 'error',
        };
      }

      if (isPhone) {
        /// remove the retired phone number from state
        updateStateFunc(
            context: context,
            type: StateContactType.retireSecondaryPhone,
            value: value);
      } else {
        /// remove the retired email from state
        updateStateFunc(
            context: context,
            type: StateContactType.retireSecondaryEmail,
            value: value);
      }

      return <String, dynamic>{
        'status': 'ok',
        'value': json.decode(result.body)['data'][isPhone
            ? 'retireSecondaryPhoneNumbers'
            : 'retireSecondaryEmailAddresses'],
      };
    } catch (e) {
      return <String, dynamic>{
        'status': 'error',
      };
    }
  }

  void showMessageFromModal(BuildContext context, dynamic result) {
    if (result == null) {
      ContactProvider provider = ContactProvider.of(context);
      // flags used to show loading indicator
      List<String> flags = <String>['set_to_primary', 'add_contact_info'];

      void clearFlag(String flag) {
        if (provider.checkWaitingFor(flag: flag)) {
          toggleLoadingIndicator(context: context, flag: flag, show: false);
          return;
        }
      }

      flags.forEach((String element) {
        clearFlag(element);
      });

      return;
    }
    // show message to user
    showAlertSnackBar(
      context: context,
      message: result['message'],
      type: result['status'] == 'error'
          ? SnackBarType.danger
          : SnackBarType.success,
    );
  }

  Future<void> verifyAddPrimaryEmailOtp({
    @required BuildContext context,
    @required String otp,
    @required String userInput,
    @required String email,
    @required String flag,
    @required Function toggleInvalidCodeMsg,
    @required TextEditingController controller,
  }) async {
    /// check if otps match
    if (userInput == otp) {
      toggleLoadingIndicator(context: context, flag: flag);
      Map<String, dynamic> result =
          await addPrimaryEmail(context: context, email: email, otp: otp);
      if (result['status'] == 'error') {
        toggleLoadingIndicator(context: context, flag: flag, show: false);
        Navigator.pop(context, <String, String>{
          'status': 'error',
          'message': ContactDetailsStrings.addContactFeedback(email, true)
        });
        return;
      }
      toggleLoadingIndicator(context: context, flag: flag, show: false);
      Navigator.pop(context, <String, String>{
        'status': 'ok',
        'message': ContactDetailsStrings.addContactFeedback(email)
      });
      return;
    }
    toggleInvalidCodeMsg(true);
    controller.clear();
    await HapticFeedback.vibrate();
  }

  Future<void> verifyContact({
    BuildContext context,
    bool isPhone,
    String flag,
    String value,
    String otp,
  }) async {
    toggleLoadingIndicator(context: context, flag: flag);
    Map<String, dynamic> result;
    if (isPhone) {
      result =
          await setPrimaryPhone(context: context, phoneNumber: value, otp: otp);
    }
    if (!isPhone) {
      result = await setPrimaryEmail(context: context, email: value, otp: otp);
    }
    if (result['status'] == 'error') {
      toggleLoadingIndicator(context: context, flag: flag, show: false);
      Navigator.pop(context, <String, dynamic>{
        'status': 'error',
        'message': ContactDetailsStrings.setPrimaryFeedback(value, true)
      });
    }
    toggleLoadingIndicator(context: context, flag: flag, show: false);
    Navigator.pop(context, <String, dynamic>{
      'status': 'ok',
      'message': ContactDetailsStrings.setPrimaryFeedback(value)
    });
  }
}
