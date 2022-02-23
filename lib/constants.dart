const String accountSection = 'Account settings';
const String legalSection = 'legal information';
const String notificationSettings = 'Notification settings';
const String changePINSettings = 'Change PIN';
const String languageSettings = 'Language settings';
const String homeAndWorkSettings = 'Home and work address';
const String termsOfServiceSettings = 'Terms of service';
const String contactInfo = 'Contact info';
const String enterPhone = 'Enter your phone number';
const String verify = 'Send verification code';
const String codeSent = 'A 6 digit verification code was sent to ';
const String editProf = 'Basic details';
const String editProfDesc = 'Tap to enable editing';
const String invalidOtp = 'Invalid verification code';
const String successEmail = 'Email verified successfully';
const String editProfileString = 'Edit Profile';

const String labelText = 'Phone number';
const String hintText = 'Enter your phone number';
const String requiredPhoneNumber = 'Phone number is required';
const String validPhoneNumber = 'Please enter a valid phone number';
const String allowComm = 'Please allow communication to proceed';
const String sendingPhoneOtp = 'Sending phone otp';
const String sendingCode = 'Sending Code...';
const String verifyPhone = 'Verify Phone';
const String closeText = 'Close';
const String cancelText = 'Nope, Cancel';
const String okayText = 'Ok, Continue';
const String verificationTitle = 'Verification';
const String verificationMessage =
    'Please enter your current PIN to \ncontinue and set a new one';
const String verificationCancel = 'Cancel';

const String changePinTitle = 'Change PIN';
const String changePinMessage =
    'Enter your new PIN below to secure your account';

const String primaryPhone = 'Primary phone number';
const String primaryEmail = 'Primary email address';
const String secondaryPhones = 'Secondary phone numbers';
const String secondaryEmails = 'Secondary email addresses';

const String phonesMessage =
    'Add another phone number that we can use to reach you and recover your account';
const String primaryEmailMessage =
    'Please add a primary email to your account to allow communications with you';
const String secondaryEmailsMessage =
    'Add another email to your account that we can use to reach you';

const String phone = 'Phone number';
const String email = 'Email address';
const String emailHint = 'Enter your email address';
const String emailValidationMessage = 'Valid email is required';
const String emailMessage = 'Please check your email for a \nverification code';
const String phoneTitle = 'Primary phone number';
const String emailTitle = 'Primary email address';
const String phoneChangeInstructions =
    'Your primary phone number is what you use to sign in with and your pin, and we will use it for communications.';
const String emailChangeInstructions =
    'Your primary email address is what we use to communicate with you.';
const String verifyTitle = 'Verification code';
String verificationMsg(String? value) =>
    'Enter the 6 digit code sent to $value';
const String incorrectCode = 'Incorrect code. Please try again';
String retireMsg(String value) =>
    'You are about to delete $value from your account';
String retireFeedback(String value, {bool hasError = false}) {
  if (hasError) {
    return 'Failed to delete $value';
  }
  return 'Successfully removed $value from your account';
}

String setPrimaryFeedback(String? value, {bool hasError = false}) {
  if (hasError) {
    return 'Failed to set $value as primary';
  }
  return 'Successfully set $value as primary';
}

const String alertTitle = 'Hey, wait a minute';

String alertMessage(String? value, {bool isPhone = true}) {
  if (isPhone) {
    return 'You are about to set $value as your primary phone number. Note that this is the phone number you will use to login with your PIN';
  } else {
    return 'You are about to set $value as your primary email address. Note that we will communicate with you via this email address';
  }
}

String sendOtpError(String? value) => 'Error sending otp to $value';

String addContactFeedback(String? value, {bool hasError = false}) {
  if (hasError) {
    return 'Failed to add $value to your account';
  }
  return 'Successfully added $value to your account';
}

//----
const String enterNo = 'Enter your phone number';

const String signUpPhoneNo = 'Please enter a phone number';

/// adds a secondary email address
const String addSecondaryEmailQuery = r'''
mutation AddSecondaryEmail($email: [String!]){
  addSecondaryEmailAddress(email: $email)
}
 ''';

/// adds a secondary phone number
const String addSecondaryPhoneQuery = r'''
mutation AddSecondaryPhoneNumber($phone: [String!]){
  addSecondaryPhoneNumber(phone: $phone)
}
 ''';

/// set primary email
const String setPrimaryEmailQuery = r'''
mutation SetPrimaryEmailAddress($email: String!, $otp: String!){
  setPrimaryEmailAddress(email: $email, otp: $otp)
}
 ''';

/// set primary email
const String setPrimaryPhoneQuery = r'''
mutation SetPrimaryPhoneNumber($phone: String!, $otp: String!){
  setPrimaryPhoneNumber(phone: $phone, otp: $otp)
}
 ''';

/// retires a secondary email
const String retireSecondaryEmailQuery = r'''
mutation RetireSecondaryEmailAddresses($emails: [String!]){
  retireSecondaryEmailAddresses(emails: $emails)
}
 ''';

/// retires a secondary phone
const String retireSecondaryPhoneQuery = r'''
mutation RetireSecondaryPhoneNumbers($phones: [String!]){
  retireSecondaryPhoneNumbers(phones: $phones)
}
 ''';

/// sends an OTP to an phone only
const String generateOTPQuery = r'''
query GenerateOTP($msisdn: String!) {
  generateOTP(msisdn: $msisdn)
}
 ''';

/// sends an OTP to the provided email only
const String generateEmailOTPQuery = r'''
query GenerateEmailVerificationOTP($email: String!){
  emailVerificationOTP(email: $email)
}
 ''';

// terms and conditions
const String termsTitle = 'Terms and Conditions';

const String bewellTermsAndConditionsUrl =
    'https://a.bewell.co.ke/privacy.html';

// terms and conditions state
const String termsAndConditionsState = 'termsAndConditionsPageState';
