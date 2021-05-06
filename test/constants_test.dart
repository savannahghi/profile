import 'package:flutter_test/flutter_test.dart';
import 'package:sil_user_profile/constants.dart';

void main() {
  test('should test ContactDetailsStrings', () {
    const String value = '+2547 xx xxx xx';
    expect(verificationMsg(value), 'Enter the 6 digit code sent to $value');
    expect(
        retireFeedback(value), 'Successfully removed $value from your account');
    expect(retireFeedback(value, hasError: true), 'Failed to delete $value');
    expect(setPrimaryFeedback(value, hasError: true),
        'Failed to set $value as primary');
    expect(setPrimaryFeedback(value), 'Successfully set $value as primary');

    expect(
        retireMsg(value), 'You are about to delete $value from your account');

    expect(sendOtpError(value), 'Error sending otp to $value');
    expect(alertMessage(value),
        'You are about to set $value as your primary phone number. Note that this is the phone number you will use to login with your PIN');
    expect(alertMessage(value, isPhone: false),
        'You are about to set $value as your primary email address. Note that we will communicate with you via this email address');

    expect(
        addContactFeedback(value), 'Successfully added $value to your account');
    expect(addContactFeedback(value, hasError: true),
        'Failed to add $value to your account');
  });
}
