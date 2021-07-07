import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app_wrapper/app_wrapper.dart';
import 'package:domain_objects/value_objects.dart';
import 'package:misc_utilities/enums.dart';
import 'package:misc_utilities/number_constants.dart';
import 'package:misc_utilities/responsive_widget.dart';
import 'package:shared_themes/spaces.dart';
import 'package:shared_ui_components/profile_banner.dart';
import 'package:user_profile/profile/domain/core/value_objects/app_strings.dart';
import 'package:user_profile/router/routes.dart';
import 'package:user_profile/user_profile_base/sil_contacts.dart';

final GlobalKey<ScaffoldState> _contactDetailsKey = GlobalKey<ScaffoldState>();

class ProfileContactDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserProfile? userProfile =
        StoreProvider.state<AppState>(context)!.userState!.userProfile;

    final BioData bioData = userProfile!.userBioData!;
    return Scaffold(
      key: _contactDetailsKey,
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: <Widget>[
            Hero(
              tag: 'profile_banner',
              child: Material(
                child: SILProfileBanner(
                  editable: true,
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
            largeVerticalSizedBox,
            BuildContactProvider(),
          ],
        ),
      ),
    );
  }
}

class BuildContactProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // UserFeedStore().refreshFeed.add(true);
    return StoreConnector<AppState, ContactViewModel>(
      converter: (Store<AppState> store) => ContactViewModel.fromStore(store),
      builder: (BuildContext context, ContactViewModel vm) {
        bool checkWaitingFor({required String flag}) {
          return StoreProvider.state<AppState>(
                  _contactDetailsKey.currentContext!)!
              .wait!
              .isWaitingFor(flag);
        }

        return ContactProvider(
          primaryEmail: vm.primaryEmail,
          primaryPhone: vm.primaryPhone,
          secondaryEmails: vm.secondaryEmails,
          secondaryPhones: vm.secondaryPhones,
          wait: StoreProvider.state<AppState>(context)!.wait!,
          checkWaitingFor: checkWaitingFor,
          contactUtils: ContactUtils(
            toggleLoadingIndicator: toggleWaitStateFlagIndicator,
            client: SILAppWrapperBase.of(context)!.graphQLClient,
            updateStateFunc: updateStateContacts,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SILResponsiveWidget.deviceType(context) !=
                      DeviceScreensType.Mobile
                  ? number30
                  : number0,
            ),
            child: const ContactDetails(),
          ),
        );
      },
    );
  }
}
