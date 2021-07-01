import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:domain_objects/entities.dart';
import 'package:shared_ui_components/try_new_features_widget.dart';
import 'package:user_profile/user_profile_base/helpers.dart';

class TryNewFeaturesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: BuildTryNewFeatures(),
        ),
      ),
    );
  }
}

class BuildTryNewFeatures extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SILTryNewFeaturesWidget(
      settingsFunc: ({bool? value}) async {
        // call api
        await setupAsExperimentParticipant(
          context: context,
          participate: value!,
        );

        StoreProvider.dispatch<AppState>(
          context,
          BatchUpdateUserStateAction(
            auth: AuthCredentialResponse(canExperiment: value),
          ),
        );
      },
      canExperiment: StoreProvider.state<AppState>(context)!
          .userState!
          .auth!
          .canExperiment,
    );
  }
}
