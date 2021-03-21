import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:sil_user_profile/add_contact.dart';
import 'package:sil_user_profile/contact_items_card.dart';
import 'package:sil_user_profile/contact_utils.dart';
import 'package:sil_user_profile/utils/constants.dart';

/// renders [ContactItemsCard] card and supplies the relevant [data] and [type]
class ContactDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ContactProvider provider = ContactProvider.of(context)!;
    return Column(
      children: <Widget>[
        ContactItemsCard(
          title: ContactDetailsStrings.primaryPhone,
          type: ContactInfoType.phone,
          addMessage: '',
          data: provider.primaryPhone,
        ),
        ContactItemsCard(
          title: ContactDetailsStrings.primaryEmail,
          data: provider.primaryEmail,
          type: ContactInfoType.email,
          addMessage: ContactDetailsStrings.primaryEmailMessage,
          onAddContactInfo: ([bool primary = false]) async {
            final dynamic result = await addContactInfoBottomSheet(
                context: context,
                type: ContactInfoType.email,
                onSave: provider.contactUtils.addPrimaryEmail,
                primary: primary);
            provider.contactUtils.showMessageFromModal(context, result);
          },
        ),
        ContactItemsCard(
          title: ContactDetailsStrings.secondaryPhones,
          addMessage: ContactDetailsStrings.phonesMessage,
          type: ContactInfoType.phone,
          data: provider.secondaryPhones,
          onAddContactInfo: ([bool primary = false]) async {
            final dynamic result = await addContactInfoBottomSheet(
                context: context,
                type: ContactInfoType.phone,
                onSave: provider.contactUtils.addSecondaryPhone);
            provider.contactUtils.showMessageFromModal(context, result);
          },
        ),
        if (provider.primaryEmail != 'UNKNOWN')
          ContactItemsCard(
            title: ContactDetailsStrings.secondaryEmails,
            data: provider.secondaryEmails,
            type: ContactInfoType.email,
            addMessage: ContactDetailsStrings.secondaryEmailsMessage,
            onAddContactInfo: ([bool primary = false]) async {
              final dynamic result = await addContactInfoBottomSheet(
                  context: context,
                  type: ContactInfoType.email,
                  onSave: provider.contactUtils.addSecondaryEmail);
              provider.contactUtils.showMessageFromModal(context, result);
            },
          ),
      ],
    );
  }
}

class ContactProvider extends InheritedWidget {
  const ContactProvider({
    Key? key,
    required this.contactUtils,
    required this.primaryEmail,
    required this.primaryPhone,
    required this.secondaryEmails,
    required this.secondaryPhones,
    required this.wait,
    required this.checkWaitingFor,
    required Widget child,
  }) : super(key: key, child: child);

  final ContactUtils contactUtils;
  final String primaryEmail;
  final String primaryPhone;
  final List<String> secondaryEmails;
  final List<String> secondaryPhones;

  final Wait wait;
  final Function checkWaitingFor;

  static ContactProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ContactProvider>();
  }

  @override
  bool updateShouldNotify(ContactProvider old) =>
      primaryEmail != old.primaryEmail ||
      primaryPhone != old.primaryPhone ||
      secondaryEmails.length != old.secondaryEmails.length ||
      secondaryPhones.length != old.secondaryPhones.length ||
      wait.hashCode != old.wait.hashCode;
}
