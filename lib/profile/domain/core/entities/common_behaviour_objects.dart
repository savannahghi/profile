import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:user_profile/profile/presentation/profile_page_items.dart';
import 'package:user_profile/router/routes.dart';
import 'package:user_profile/user_profile_base/constants.dart';

class ProfileSubject {
  factory ProfileSubject() {
    return _singleton;
  }

  ProfileSubject._internal();

  BehaviorSubject<Color> color =
      BehaviorSubject<Color>.seeded(Colors.purple[100]!);

  BehaviorSubject<String> selectedTile =
      BehaviorSubject<String>.seeded(contactInfo);

  BehaviorSubject<ValueNotifier<ProfileItem>> selection =
      BehaviorSubject<ValueNotifier<ProfileItem>>.seeded(
    ValueNotifier<ProfileItem>(
      const ProfileItem(
        text: contactInfo,
        section: ProfileItemType.account,
        onTapRoute: profileContactDetailsRoute,
      ),
    ),
  );

  static final ProfileSubject _singleton = ProfileSubject._internal();
}
