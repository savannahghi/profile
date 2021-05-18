import 'package:flutter/material.dart';

import 'package:async_redux/async_redux.dart';

import 'package:sil_core_domain_objects/value_objects.dart';
import 'package:sil_user_profile/add_contact.dart';
import 'package:sil_user_profile/contact_items_card.dart';
import 'package:sil_user_profile/contact_type.dart';
import 'package:sil_user_profile/contact_utils.dart';
import 'package:sil_user_profile/constants.dart';

/// Renders [ContactItemsCard] card and supplies the relevant [data] and [type]
class ContactDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ContactProvider provider = ContactProvider.of(context)!;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          ContactItemsCard(
            title: primaryPhone,
            type: ContactInfoType.phone,
            addMessage: '',
            data: <ContactType<ValueObject<String>>>[
              ContactType<ValueObject<String>>(provider.primaryPhone)
            ],
          ),
          ContactItemsCard(
            title: primaryEmail,
            data: <ContactType<ValueObject<String>>>[
              if (provider.primaryEmail != EmailAddress.withValue(UNKNOWNEMAIL))
                ContactType<ValueObject<String>>(provider.primaryEmail!)
            ],
            type: ContactInfoType.email,
            addMessage: primaryEmailMessage,
            onAddContactInfo: ([bool primary = false]) async {
              provider.contactUtils.showMessageFromModal(
                  context,
                  await addContactInfoBottomSheet(
                      context: context,
                      type: ContactInfoType.email,
                      onSave: provider.contactUtils.addPrimaryEmail,
                      primary: primary));
            },
          ),
        ],
      ),
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
  final EmailAddress? primaryEmail;
  final PhoneNumber primaryPhone;
  final List<EmailAddress>? secondaryEmails;
  final List<PhoneNumber>? secondaryPhones;

  final Wait wait;
  final Function checkWaitingFor;

  static ContactProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ContactProvider>();
  }

  @override
  bool updateShouldNotify(ContactProvider old) =>
      primaryEmail != old.primaryEmail ||
      primaryPhone != old.primaryPhone ||
      secondaryEmails?.length != old.secondaryEmails?.length ||
      secondaryPhones?.length != old.secondaryPhones?.length ||
      wait.hashCode != old.wait.hashCode;
}
