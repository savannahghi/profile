import 'package:flutter/material.dart';
import 'package:user_profile/profile/presentation/communication_settings.dart';
import 'package:user_profile/profile/presentation/pages/edit_profile_page.dart';
import 'package:user_profile/profile/presentation/pages/try_new_features_page.dart';
import 'package:user_profile/profile/presentation/profile_contact_details.dart';
import 'package:user_profile/router/routes.dart';
import 'package:user_profile/user_profile_base/term_and_conditions.dart';

class RouteGenerator {
  static Route<dynamic>? generateRoute(RouteSettings? settings) {
    final dynamic args = settings?.arguments;

    switch (settings?.name) {
      case profileContactDetailsRoute:
        return MaterialPageRoute<ProfileContactDetails>(
          builder: (_) => ProfileContactDetails(),
        );

      case editUserProfileRoute:
        return MaterialPageRoute<EditProfilePage>(
          builder: (_) => EditProfilePage(),
        );

      case commSettingsRoute:
        return MaterialPageRoute<CommunicationSettingsPage>(
          builder: (_) => CommunicationSettingsPage(),
        );

      case pinVerificationRoute:
        return MaterialPageRoute<PinVerificationPage>(
          builder: (_) => PinVerificationPage(
            pinVerificationType: args != null
                ? args as PinVerificationType
                : PinVerificationType.resumeWithPin,
          ),
        );

      case tryNewFeatureSettingsRoute:
        return MaterialPageRoute<TryNewFeaturesPage>(
          builder: (_) => TryNewFeaturesPage(),
        );

      case webViewRoute:
        return MaterialPageRoute<TermsAndConditionsPage>(
            builder: (_) => TermsAndConditionsPage());
    }
  }
}
