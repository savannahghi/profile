import 'package:user_profile/profile/presentation/profile_utils.dart';

// This is the version of the currently running app.
// it has to be defined as a const otherwise the compiler will return the default
const String APPVERSION =
    String.fromEnvironment('APPVERSION', defaultValue: 'dev-build');
const String appVersionString = 'Current Version:';

const String doctorIcon = 'assets/images/doctor-2.jpg';
const String communicationSettingsText = 'Communication settings';
const String profileComingSoonText = 'Coming soon';
const String changePINText = 'Change PIN';
const String tryNewFeaturesText = 'Try new features';
const String termsOfServiceText = 'Terms of service';
const String logoutText = 'Logout';
final String copyrightString = 'Copyright ©️ ${returnCurrentYear()} Be.Well';
const String logoutMessage = 'Hold on ... you\'ll be logged out in a moment';

