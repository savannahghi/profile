import 'package:flutter/material.dart';
import 'package:shared_themes/spaces.dart';
import 'package:shared_themes/text_themes.dart';
import 'package:user_profile/profile/presentation/profile_utils.dart';
import 'package:user_profile/profile/presentation/widgets/onboarding_scaffold.dart';

class ProfileChangePin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // P2
      body: OnboardingScaffold(
        dimension: 20,
        icon: Icons.edit_attributes_sharp,
        title: changePinTitle,
        msg: changePinMessage,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SetAndConfirmPinWidget(
                  flag: changePinFlag,
                  setPinStatus: SetPinStatus.IsChangingPin,
                ),
                largeVerticalSizedBox,
                GestureDetector(
                  onTap: () async => triggerNavigationEvent(
                      context: context, namedRoute: userProfileRoute),
                  child: SizedBox(
                    height: 48,
                    child: Text(
                      verificationCancel,
                      textAlign: TextAlign.center,
                      style: TextThemes.boldSize16Text(Colors.red),
                    ),
                  ),
                ),
                mediumVerticalSizedBox,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
