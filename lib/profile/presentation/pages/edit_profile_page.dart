import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:domain_objects/value_objects.dart';
import 'package:shared_themes/spaces.dart';
import 'package:shared_ui_components/profile_banner.dart';
import 'package:user_profile/profile/domain/core/value_objects/app_strings.dart';
import 'package:user_profile/profile/presentation/widgets/edir_profile_form.dart';
import 'package:user_profile/router/routes.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  @override
  Widget build(BuildContext context) {
    // final UserProfile userProfile =
    //     StoreProvider.state<AppState>(context)!.userState!.userProfile!;

    // final BioData bioData = userProfile.userBioData!;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Hero(
              tag: 'profile_banner',
              child: Material(
                child: SILProfileBanner(
                  backgroundImagePath: doctorIcon,
                  userPhotoUrl: (userProfile.photoUploadID != null)
                      ? userProfile.photoUploadID!
                      : UNKNOWN,
                  userName:
                      '${toBeginningOfSentenceCase(bioData.firstName?.getValue())} ${toBeginningOfSentenceCase(bioData.lastName?.getValue())}',
                  primaryPhone: userProfile.primaryPhoneNumber!.getValue(),
                  profileRoute: editUserProfileRoute,
                ),
              ),
            ),
            veryLargeVerticalSizedBox,
            EditProfileForm(),
          ],
        ),
      ),
    );
  }
}
