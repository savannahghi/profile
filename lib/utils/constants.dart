class ContactDetailsStrings {
  static String accountSection = 'Account settings';
  static String legalSection = 'legal information';
  static String notificationSettings = 'Notification settings';
  static String changePINSettings = 'Change PIN';
  static String languageSettings = 'Language settings';
  static String homeAndWorkSettings = 'Home and work address';
  static String termsOfServiceSettings = 'Terms of service';
  static const String contactInfo = 'Contact info';
  static const String enterPhone = 'Enter your phone number';
  static const String verify = 'Send verification code';
  static const String codeSent = 'A 6 digit verification code was sent to ';
  static const String editProf = 'Basic details';
  static const String editProfDesc = 'Tap to enable editing';
  static const String invalidOtp = 'Invalid verification code';
  static const String successEmail = 'Email verified successfully';
  static const String editProfileString = 'Edit Profile';

  static final String labelText = 'Phone number';
  static final String hintText = 'Enter your phone number';
  static final String requiredPhoneNumber = 'Phone number is required';
  static final String validPhoneNumber = 'Please enter a valid phone number';
  static final String allowComm = 'Please allow communication to proceed';
  static final String sendingPhoneOtp = 'Sending phone otp';
  static final String sendingCode = 'Sending Code...';
  static final String verifyPhone = 'Verify Phone';

  static const String verificationTitle = 'Verification';
  static const String verificationMessage =
      'Please enter your current PIN to \ncontinue and set a new one';
  static const String verificationCancel = 'Cancel';

  static const String changePinTitle = 'Change PIN';
  static const String changePinMessage =
      'Enter your new PIN below to secure your account';

  static const String primaryPhone = 'Primary phone number';
  static const String primaryEmail = 'Primary email address';
  static const String secondaryPhones = 'Secondary phone numbers';
  static const String secondaryEmails = 'Secondary email addresses';

  static const String phonesMessage =
      'Add another phone number that we can use to reach you and recover your account';
  static const String primaryEmailMessage =
      'Please add a primary email to your account to allow communications with you';
  static const String secondaryEmailsMessage =
      'Add another email to your account that we can use to reach you';

  static final String phone = 'Phone number';
  static final String email = 'Email address';
  static final String emailHint = 'Enter your email address';
  static final String emailValidationMessage = 'Valid email is required';
  static final String emailMessage =
      'Add an email address that we can use to \nreach you to your account';
  static final String phoneTitle = 'Primary phone number';
  static final String emailTitle = 'Primary email address';
  static final List<String> phoneChangeInstructions = <String>[
    'Your primary phone number is what you use to sign in with and your pin. To change primary phone number, follow the steps below:',
    '1. Go to secondary phone numbers section and tap on green plus button, add a phone number if you haven\'t already',
    '2. After adding a secondary phone number, tap on the up arrow next to it to set it as primary',
  ];
  static final List<String> emailChangeInstructions = <String>[
    'Your primary email address is what we use to primarily communicate with you. To change primary email address, follow the steps below:',
    '1. Go to secondary email addresses section and tap on green plus button, add an email address if you haven\'t already',
    '2. After adding a secondary email address, tap on the up arrow next to it to set it as primary',
  ];
  static final String verifyTitle = 'Verification code';
  static String verificationMsg(String value) =>
      'Enter the 6 digit code sent to $value';
  static final String incorrectCode = 'Incorrect code. Please try again';
  static String retireMsg(String value) =>
      'You are about to delete $value from your account';
  static String retireFeedback(String value, [bool hasError = false]) {
    if (hasError) {
      return 'Failed to delete $value';
    }
    return 'Successfully removed $value from your account';
  }

  static String setPrimaryFeedback(String value, [bool hasError = false]) {
    if (hasError) {
      return 'Failed to set $value as primary';
    }
    return 'Successfully set $value as primary';
  }

  static final String alertTitle = 'Hey, wait a minute';

  static String alertMessage(String value, [bool isPhone = true]) {
    if (isPhone) {
      return 'You are about to set $value as your primary phone number. Note that this is the number you will use to login with your PIN';
    }
    return 'You are about to set $value as your primary email address. Note that we will primarily communicate with you via this email';
  }

  static String sendOtpError(String value) => 'Error sending otp to $value';

  static String addContactFeedback(String value, [bool hasError = false]) {
    if (hasError) {
      return 'Failed to add $value to your account';
    }
    return 'Successfully added $value to your account';
  }

  //----
  static final String enterNo = 'Enter your phone number';

  static final String signUpPhoneNo = 'Please enter a phone number';
}

/// adds a secondary email address
final String addSecondaryEmailQuery = r'''
mutation AddSecondaryEmail($email: [String!]){
  addSecondaryEmailAddress(email: $email)
}
 ''';

/// adds a secondary phone number
final String addSecondaryPhoneQuery = r'''
mutation AddSecondaryPhoneNumber($phone: [String!]){
  addSecondaryPhoneNumber(phone: $phone)
}
 ''';

/// set primary email
final String setPrimaryEmailQuery = r'''
mutation SetPrimaryEmailAddress($email: String!, $otp: String!){
  setPrimaryEmailAddress(email: $email, otp: $otp)
}
 ''';

/// set primary email
final String setPrimaryPhoneQuery = r'''
mutation SetPrimaryPhoneNumber($phone: String!, $otp: String!){
  setPrimaryPhoneNumber(phone: $phone, otp: $otp)
}
 ''';

/// retires a secondary email
final String retireSecondaryEmailQuery = r'''
mutation RetireSecondaryEmailAddresses($emails: [String!]){
  retireSecondaryEmailAddresses(emails: $emails)
}
 ''';

/// retires a secondary phone
final String retireSecondaryPhoneQuery = r'''
mutation RetireSecondaryPhoneNumbers($phones: [String!]){
  retireSecondaryPhoneNumbers(phones: $phones)
}
 ''';

/// sends an OTP to an phone only
final String generateOTPQuery = r'''
query GenerateOTP($msisdn: String!) {
  generateOTP(msisdn: $msisdn)
}
 ''';

/// sends an OTP to the provided email only
final String generateEmailOTPQuery = r'''
query GenerateEmailVerificationOTP($email: String!){
  emailVerificationOTP(email: $email)
}
 ''';
