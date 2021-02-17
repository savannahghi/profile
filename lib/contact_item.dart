import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sil_contacts/contact_utils.dart';
import 'package:sil_contacts/set_to_primary.dart';
import 'package:sil_contacts/sil_contacts.dart';
import 'package:sil_contacts/utils/constants.dart';
import 'package:sil_dumb_widgets/sil_loader.dart';
import 'package:sil_themes/spaces.dart';
import 'package:sil_themes/text_themes.dart';

/// shows a contact and possible actions [info], [upgrade] or [delete]
/// [editable] flag determines whether a contact can be [deleted] or [upgraded]
///  which is not the case for a primary contact
class ContactItem extends StatelessWidget {
  final String value;
  final bool editable;
  final ContactInfoType type;

  const ContactItem({
    Key key,
    @required this.value,
    @required this.type,
    this.editable = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    ContactProvider provider = ContactProvider.of(context);
    return Container(
      padding:
          EdgeInsets.symmetric(vertical: editable ? 10 : 20, horizontal: 20),
      decoration: BoxDecoration(color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(value),
          if (editable)
            Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () async {
                    /// show the upgrade to primary bottomsheet
                    dynamic result = await upgradeToPrimaryBottomSheet(
                        context: context, type: type, value: value);
                    provider.contactUtils.showMessageFromModal(context, result);
                  },
                  child: Icon(
                    MdiIcons.keyboardCaps,
                    color: Colors.purple.withOpacity(0.6),
                    size: 20,
                  ),
                ),
                smallHorizontalSizedBox,
                GestureDetector(
                  onTap: () async {
                    /// show the retire contact bottomsheet
                    dynamic result = await deleteContactDialogue(
                      context: context,
                      value: value,
                      type: type,
                      provider: provider,
                    );
                    provider.contactUtils.showMessageFromModal(context, result);
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
              onTap: () {
                primaryContactInfo(
                    context: context,
                    isPhone: type == ContactInfoType.phone,
                    value: value);
              },
              child: Icon(
                MdiIcons.informationOutline,
                color: Colors.black.withOpacity(0.4),
                size: 18,
              ),
            ),
        ],
      ),
    );
  }
}

/// deletes a secondary contact from an account
Future<dynamic> deleteContactDialogue({
  @required BuildContext context,
  @required String value,
  @required ContactInfoType type,
  @required ContactProvider provider,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      String flag = 'retire_contact';
      return AlertDialog(
        backgroundColor: Theme.of(context).backgroundColor,
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                ContactDetailsStrings.retireMsg(value),
                style: TextThemes.normalSize14Text(),
              ),
            ],
          ),
        ),
        actions: provider.checkWaitingFor(flag: flag)
            ? <Widget>[
                SILLoader(),
              ]
            : <Widget>[
                TextButton(
                  child: Text(
                    'Confirm',
                    style: TextThemes.boldSize16Text(Colors.red),
                  ),
                  onPressed: () async {
                    provider.contactUtils
                        .toggleLoadingIndicator(context: context, flag: flag);
                    Map<String, dynamic> result = await provider.contactUtils
                        .retireSecondaryContact(
                            value: value,
                            isPhone: type == ContactInfoType.phone,
                            context: context,
                            flag: flag);
                    if (result['status'] == 'error') {
                      provider.contactUtils.toggleLoadingIndicator(
                          context: context, flag: flag, show: false);
                      Navigator.pop(context, <String, String>{
                        'status': 'error',
                        'message':
                            ContactDetailsStrings.retireFeedback(value, true),
                      });
                      return;
                    }
                    Navigator.pop(context, <String, String>{
                      'status': 'ok',
                      'message': ContactDetailsStrings.retireFeedback(value),
                    });
                  },
                ),
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
      );
    },
  );
}

/// opens a bottom sheet to show instructions on how to change a primary contact
void primaryContactInfo(
    {@required BuildContext context,
    @required bool isPhone,
    @required String value}) {
  showModalBottomSheet(
      context: context,
      barrierColor: Colors.black.withOpacity(0.2),
      elevation: 1,
      builder: (BuildContext context) {
        List<String> instructions = isPhone
            ? ContactDetailsStrings.phoneChangeInstructions
            : ContactDetailsStrings.emailChangeInstructions;
        return Container(
          height: 320,
          padding: EdgeInsets.all(20),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Text(
                        isPhone
                            ? ContactDetailsStrings.phoneTitle
                            : ContactDetailsStrings.emailTitle,
                        style: TextThemes.heavySize10Text(Color(0xFF1ba376))),
                    decoration: BoxDecoration(
                      color: Color(0xFF1ba376).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  Text(
                    value,
                    style: TextThemes.normalSize14Text(
                        Theme.of(context).accentColor),
                  ),
                ],
              ),
              mediumVerticalSizedBox,
              Text(
                instructions[0],
                style: TextThemes.normalSize13Text().copyWith(height: 1.6),
              ),
              mediumVerticalSizedBox,
              Text(
                instructions[1],
                style: TextThemes.normalSize12Text().copyWith(height: 1.6),
              ),
              size15VerticalSizedBox,
              Text(
                instructions[2],
                style: TextThemes.normalSize12Text().copyWith(height: 1.6),
              ),
              mediumVerticalSizedBox,
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Close',
                  style: TextThemes.heavySize14Text(Colors.red),
                ),
              ),
            ],
          ),
        );
      });
}
