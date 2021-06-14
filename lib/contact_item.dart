import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sil_ui_components/sil_platform_loader.dart';
import 'package:user_profile/contact_utils.dart';
import 'package:user_profile/set_to_primary.dart';
import 'package:user_profile/shared/widget_keys.dart';
import 'package:user_profile/sil_contacts.dart';
import 'package:user_profile/constants.dart';
import 'package:sil_themes/spaces.dart';
import 'package:sil_themes/text_themes.dart';

/// Shows a contact and possible actions [info], [upgrade] or [delete]
/// [editable] flag determines whether a contact can be [deleted] or [upgraded]
/// Which is not the case for a primary contact
class ContactItem extends StatelessWidget {
  const ContactItem({
    Key? key,
    required this.value,
    required this.type,
    this.editable = false,
  }) : super(key: key);

  final String value;
  final bool editable;
  final ContactInfoType type;
  @override
  Widget build(BuildContext context) {
    final ContactProvider? provider = ContactProvider.of(context);
    return Container(
      padding:
          EdgeInsets.symmetric(vertical: editable ? 10 : 20, horizontal: 20),
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(value),
          if (editable)
            Row(
              children: <Widget>[
                GestureDetector(
                  key: const Key('editable_contact_key'),
                  onTap: () async {
                    /// show the upgrade to primary bottom sheet
                    final dynamic result = await upgradeToPrimaryBottomSheet(
                        context: context, type: type, value: value);
                    provider!.contactUtils
                        .showMessageFromModal(context, result);
                  },
                  child: Icon(
                    MdiIcons.keyboardCaps,
                    color: Colors.purple.withOpacity(0.6),
                    size: 20,
                  ),
                ),
                smallHorizontalSizedBox,
                GestureDetector(
                  key: const Key('delete_contact_key'),
                  onTap: () async {
                    /// show the retire contact bottom sheet
                    final dynamic result = await deleteContactDialogue(
                      context: context,
                      value: value,
                      type: type,
                      provider: provider,
                    );
                    provider!.contactUtils
                        .showMessageFromModal(context, result);
                  },
                  child: Icon(
                    MdiIcons.trashCanOutline,
                    color: Colors.red.withOpacity(0.6),
                    size: 17,
                  ),
                ),
              ],
            ),
          if (!editable)
            GestureDetector(
              key: const Key('not_editable_contact_key'),
              onTap: () {
                primaryContactInfo(
                    context: context,
                    isPhone: type == ContactInfoType.phone,
                    contactType: type,
                    value: value);
              },
              child: Icon(
                MdiIcons.informationOutline,
                color: Colors.black.withOpacity(0.4),
                size: 28,
              ),
            ),
        ],
      ),
    );
  }
}

/// deletes a secondary contact from an account
Future<dynamic> deleteContactDialogue({
  required BuildContext context,
  required String value,
  required ContactInfoType type,
  required ContactProvider? provider,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      const String flag = 'retire_contact';
      return AlertDialog(
        backgroundColor: Theme.of(context).backgroundColor,
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                retireMsg(value),
                style: TextThemes.normalSize14Text(),
              ),
            ],
          ),
        ),
        actions: provider!.checkWaitingFor(flag: flag) as bool
            ? <Widget>[
                const SILPlatformLoader(),
              ]
            : <Widget>[
                TextButton(
                  key: confirmButtonKey,
                  onPressed: () async {
                    provider.contactUtils
                        .toggleLoadingIndicator(context: context, flag: flag);

                    final Map<String, dynamic> result =
                        await provider.contactUtils.retireSecondaryContact(
                            value: value,
                            isPhone: type == ContactInfoType.phone,
                            context: context,
                            flag: flag);
                    if (result['status'] == 'error') {
                      provider.contactUtils.toggleLoadingIndicator(
                          context: context, flag: flag, show: false);
                      Navigator.pop(context, <String, String>{
                        'status': 'error',
                        'message': retireFeedback(value, hasError: true),
                      });
                      return;
                    }
                    Navigator.pop(context, <String, String>{
                      'status': 'ok',
                      'message': retireFeedback(value),
                    });
                  },
                  child: Text(
                    'Confirm',
                    style: TextThemes.boldSize16Text(Colors.red),
                  ),
                ),
                TextButton(
                  key: cancelButtonKey,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
              ],
      );
    },
  );
}

/// opens a bottom sheet to show instructions on how to change a primary contact
void primaryContactInfo(
    {required BuildContext context,
    required bool isPhone,
    required ContactInfoType contactType,
    required String value}) {
  showModalBottomSheet(
      context: context,
      barrierColor: Colors.black.withOpacity(0.2),
      elevation: 1,
      builder: (BuildContext context) {
        final String instructions =
            isPhone ? phoneChangeInstructions : emailChangeInstructions;
        return SingleChildScrollView(
          child: Container(
            height: 260,
            padding: const EdgeInsets.all(20),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1ba376).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Text(
                      (contactType == ContactInfoType.phone)
                          ? phoneTitle
                          : emailTitle,
                      style:
                          TextThemes.heavySize10Text(const Color(0xFF1ba376))),
                ),
                smallVerticalSizedBox,
                Text(
                  value,
                  style: TextThemes.normalSize14Text(
                      Theme.of(context).accentColor),
                ),
                mediumVerticalSizedBox,
                Text(
                  instructions,
                  style: TextThemes.normalSize12Text().copyWith(height: 1.6),
                ),
                largeVerticalSizedBox,
                GestureDetector(
                  key: const Key('close_key'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    closeText,
                    style: TextThemes.heavySize14Text(Colors.red),
                  ),
                ),
              ],
            ),
          ),
        );
      });
}
