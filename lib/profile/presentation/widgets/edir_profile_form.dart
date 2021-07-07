import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:app_wrapper/app_wrapper.dart';
import 'package:domain_objects/entities.dart';
import 'package:domain_objects/value_objects.dart';
import 'package:flutter_graphql_client/graph_client.dart';
import 'package:misc_utilities/event_bus.dart';
import 'package:misc_utilities/misc.dart';
import 'package:misc_utilities/responsive_widget.dart';
import 'package:shared_themes/colors.dart';
import 'package:shared_themes/constants.dart';
import 'package:shared_themes/spaces.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_ui_components/buttons.dart';
import 'package:shared_ui_components/inputs.dart';
import 'package:shared_ui_components/platform_loader.dart';
import 'package:user_profile/profile/presentation/profile_utils.dart';

class EditProfileForm extends StatefulWidget {
  @override
  _EditProfileFormState createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  @override
  void didChangeDependencies() {
    final AppState state = StoreProvider.state<AppState>(context)!;
    displayName =
        state.userState!.userProfile!.userBioData!.firstName!.getValue();

    firstName =
        state.userState!.userProfile!.userBioData!.firstName!.getValue();
    lastName = state.userState!.userProfile!.userBioData!.lastName!.getValue();

    firstNameController.text = firstName;
    lastNameController.text = lastName;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  Future<void> saveDetails({
    required Map<String, dynamic> variables,
    required String displayName,
  }) async {
    toggleWaitStateFlagIndicator(context: context, flag: editProfileFlag);

    final ISILGraphQlClient _client =
        SILAppWrapperBase.of(context)!.graphQLClient;
    final http.Response result = await _client.query(
        updateUserProfileMutation, <String, dynamic>{'input': variables});
    final Map<String, dynamic> body = _client.toMap(result);
    toggleWaitStateFlagIndicator(
        context: context, flag: editProfileFlag, show: false);

    //check first for errors
    if (_client.parseError(body) != null) {
      showErrorSnackbar(context);
      return;
    }

    if (body['data'] != null) {
      await StoreProvider.dispatchFuture<AppState>(
        context,
        BatchUpdateUserStateAction(
          userProfile: UserProfile(
            userBioData: BioData(
              firstName: Name.withValue(variables['firstName'].toString()),
              lastName: Name.withValue(variables['lastName'].toString()),
            ),
          ),
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: const Text(updateSuccessful),
          duration: const Duration(seconds: kShortSnackBarDuration),
          action: dismissSnackBar('close', white, context),
        ));
      await Future<void>.delayed(
          const Duration(seconds: kShortSnackBarDuration));

      final Map<String, dynamic> eventPayload = <String, dynamic>{
        'route': userProfileRoute
      };
      await SILAppWrapperBase.of(context)!
          .eventBus
          .fire(TriggeredEvent(navigationEvent, eventPayload));
      await triggerNavigationEvent(
          context: context, namedRoute: userProfileRoute, shouldReplace: true);
      return;
    }
    showErrorSnackbar(context);
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController firstNameController = TextEditingController();
  late TextEditingController lastNameController = TextEditingController();

  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();

  late String displayName;

  late String firstName;
  late String lastName;

  bool loading = false;
  Map<String, dynamic> variables = <String, dynamic>{};

  Future<void> saveUserNames() async {
    if (_formKey.currentState!.validate()) {
      displayName = '${variables['firstName']} ${variables['lastName']}';
      await saveDetails(
        variables: variables,
        displayName: displayName,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppStateViewModel>(
      converter: (Store<AppState> store) => AppStateViewModel.fromStore(store),
      builder: (BuildContext context, AppStateViewModel vm) {
        return Padding(
          padding: EdgeInsets.symmetric(
              horizontal:
                  SILResponsiveWidget.preferredPaddingOnStretchedScreens(
                      context: context)),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                largeVerticalSizedBox,
                const Text(
                  updateProfile,
                  style: TextStyle(color: titleBlack, fontSize: 15),
                ),
                largeVerticalSizedBox,
                // first name
                const TextFieldLabel(label: updateFirstName),
                smallVerticalSizedBox,
                SILFormTextField(
                  borderColor: subtitleColor,
                  key: AppWidgetKeys.firstName,
                  controller: firstNameController,
                  focusNode: _firstNameFocusNode,
                  validator: (dynamic value) {
                    if (value.toString().isEmpty) {
                      return updateFirstNameReq;
                    }
                    return null;
                  },
                  onChanged: (dynamic value) {
                    variables['firstName'] = value;
                  },
                ),
                largeVerticalSizedBox,

                // last name
                const TextFieldLabel(label: updateLastName),
                smallVerticalSizedBox,
                SILFormTextField(
                  textFieldBackgroundColor: Colors.cyan,
                  borderColor: subtitleColor,
                  controller: lastNameController,
                  key: AppWidgetKeys.lastName,
                  validator: (dynamic value) {
                    if (value.toString().isEmpty) {
                      return updateLastNameReq;
                    }
                    return null;
                  },
                  onChanged: (dynamic value) {
                    variables['lastName'] = value;
                  },
                  focusNode: _lastNameFocusNode,
                ),
                largeVerticalSizedBox,
                if (vm.state.wait!.isWaitingFor(editProfileFlag)) ...<Widget>[
                  const Center(child: SILPlatformLoader())
                ],
                if (!vm.state.wait!.isWaitingFor(editProfileFlag)) ...<Widget>[
                  SizedBox(
                    width: double.infinity,
                    height: number48,
                    child: SILPrimaryButton(
                      buttonKey: AppWidgetKeys.editProfileDetailsButton,
                      onPressed: () => saveUserNames(),
                      buttonColor: Theme.of(context).accentColor,
                      text: saveAndContinueButtonText,
                    ),
                  )
                ],
                mediumVerticalSizedBox
              ],
            ),
          ),
        );
      },
    );
  }
}
