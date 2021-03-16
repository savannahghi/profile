import 'package:flutter_test/flutter_test.dart';
import 'package:sil_user_profile/utils/constants.dart';

void main() {
  test('should test ContactDetailsStrings', () {
    const String value = '+2547 xx xxx xx';
    expect(ContactDetailsStrings.verificationMsg(value),
        'Enter the 6 digit code sent to $value');
    expect(ContactDetailsStrings.retireFeedback(value),
        'Successfully removed $value from your account');
    expect(ContactDetailsStrings.retireFeedback(value, hasError: true),
        'Failed to delete $value');
    expect(ContactDetailsStrings.setPrimaryFeedback(value, hasError: true),
        'Failed to set $value as primary');
    expect(ContactDetailsStrings.setPrimaryFeedback(value),
        'Successfully set $value as primary');

    expect(ContactDetailsStrings.retireMsg(value),
        'You are about to delete $value from your account');

    expect(ContactDetailsStrings.sendOtpError(value),
        'Error sending otp to $value');
    expect(ContactDetailsStrings.alertMessage(value),
        'You are about to set $value as your primary phone number. Note that this is the number you will use to login with your PIN');
    expect(ContactDetailsStrings.alertMessage(value, isPhone: false),
        'You are about to set $value as your primary email address. Note that we will primarily communicate with you via this email');

    expect(ContactDetailsStrings.addContactFeedback(value),
        'Successfully added $value to your account');
    expect(ContactDetailsStrings.addContactFeedback(value, hasError: true),
        'Failed to add $value to your account');
  });
}
