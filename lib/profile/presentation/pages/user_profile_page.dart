import 'package:flutter/material.dart';
import 'package:misc_utilities/enums.dart';
import 'package:misc_utilities/number_constants.dart';
import 'package:misc_utilities/responsive_widget.dart';
import 'package:user_profile/profile/domain/core/entities/common_behaviour_objects.dart';
import 'package:user_profile/profile/domain/core/value_objects/app_widget_keys.dart';
import 'package:user_profile/profile/presentation/widgets/profile_detail.dart';
import 'package:user_profile/profile/presentation/widgets/profile_master_detail.dart';

class UserProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ProfileSubject profileSubject = ProfileSubject();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            if (SILResponsiveWidget.deviceType(context) !=
                DeviceScreensType.Mobile) ...<Widget>{
              /// [Tablet] Widgets
              IntrinsicHeight(
                child: Row(
                  key: AppWidgetKeys.profileMasterDetailRowKey,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    /// [Main] Content
                    SizedBox(
                      width: !SILResponsiveWidget.isLandscape(context: context)
                          ? number300
                          : number400,
                      child: ProfileMasterDetail(
                        selection: profileSubject.selection.value,
                      ),
                    ),
                    const VerticalDivider(
                      width: 0,
                      color: Colors.grey,
                    ),

                    /// [Detail] Content
                    ProfileDetail(selection: profileSubject.selection.value)
                  ],
                ),
              ),
            } else ...<Widget>{
              /// [Mobile] Widgets
              ProfileMasterDetail(selection: profileSubject.selection.value),
            }
          ],
        ),
      ),
    );
  }
}
