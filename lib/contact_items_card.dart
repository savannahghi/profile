import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:domain_objects/value_objects.dart';
import 'package:sil_themes/app_theme.dart';
import 'package:sil_themes/spaces.dart';
import 'package:sil_ui_components/sil_buttons.dart';
import 'package:sil_user_profile/contact_item.dart';
import 'package:sil_user_profile/contact_type.dart';
import 'package:sil_user_profile/contact_utils.dart';
import 'package:sil_themes/text_themes.dart';

/// renders [ContactItem]s based on data supplied [primary] or [secondary] contacts
/// the data supplied is either a [string] or an [list] of contacts
/// [onAddContactInfo] opens an add contact bottom sheet
class ContactItemsCard extends StatelessWidget {
  const ContactItemsCard({
    Key? key,
    required this.title,
    required this.data,
    required this.type,
    this.addMessage,
    this.onAddContactInfo,
  }) : super(key: key);

  final String title;
  final String? addMessage;
  final List<ContactType<ValueObject<String>>>? data;
  final Function? onAddContactInfo;
  final ContactInfoType type;

  Widget _buildMsgWidget([bool primary = false]) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              addMessage!,
              style: TextThemes.normalSize13Text(),
            ),
          ),
          mediumHorizontalSizedBox,
          GestureDetector(
            key: Key(title),
            child: SILPrimaryButton(
              buttonColor: AppColors.consumerColors['primaryColor'],
              customRadius: 12,
              onPressed: () => onAddContactInfo!(primary),
              customChild: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Add',
                    style: TextThemes.boldSize14Text(Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required List<ContactType<ValueObject<String>>> data,
  }) {
    if (data.isEmpty) {
      /// there is no data, so show a message
      return _buildMsgWidget(true);
    }

    final List<ContactItem> widgets = <ContactItem>[];
    for (final ContactType<ValueObject<String>> item in data) {
      widgets.add(
        ContactItem(
          value: item.value(),
          type: checkContactType(item),
          editable: item.isSecondary,
        ),
      );
    }

    return Column(
      children: <Widget>[
        ...widgets,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: DottedBorder(
            color: Colors.grey.withOpacity(0.2),
            child: Container(
              width: double.infinity,
            ),
          ),
        ),

        /// at this point the data supplied is a [list of secondary contacts]
        /// so communicate to the user that they can add more
        if (data.length > 1) _buildMsgWidget(),
      ],
    );
  }

  ContactInfoType checkContactType(ContactType<ValueObject<String>> item) {
    if (item.contactItemValueObject is PhoneNumber) {
      return ContactInfoType.phone;
    } else {
      return ContactInfoType.email;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (data != null) {
      /// takes data which can be [string] or [list] and return contact item(s)
      final dynamic contactItem = _buildContactItem(
        data: data!,
      );
      return Column(
        children: <Widget>[
          // title
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor.withOpacity(0.06),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    title,
                    style: TextThemes.heavySize16Text(),
                  ),
                ),
              ],
            ),
          ),

          if (contactItem != null) contactItem as Widget
        ],
      );
    }

    return const SizedBox();
  }
}
