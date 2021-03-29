import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:sil_core_domain_objects/value_objects.dart';
import 'package:sil_user_profile/add_contact.dart';
import 'package:sil_user_profile/contact_items_card.dart';
import 'package:sil_user_profile/contact_type.dart';
import 'package:sil_user_profile/contact_utils.dart';
import 'package:sil_user_profile/constants.dart';

/// renders [ContactItemsCard] card and supplies the relevant [data] and [type]
class ContactDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ContactProvider provider = ContactProvider.of(context)!;
    return Column(
      children: <Widget>[
        ContactItemsCard(
          title: primaryPhone,
          type: ContactInfoType.phone,
          addMessage: '',
          data: <ContactType<ValueObject<String>>>[
            ContactType<ValueObject<String>>(provider.primaryPhone)
          ],
        ),
        if (provider.primaryEmail != null &&
            provider.primaryEmail != EmailAddress.withValue(UNKNOWN))
          ContactItemsCard(
            title: primaryEmail,
            data: <ContactType<ValueObject<String>>>[
              ContactType<ValueObject<String>>(provider.primaryEmail!)
            ],
            type: ContactInfoType.email,
            addMessage: primaryEmailMessage,
            onAddContactInfo: ([bool primary = false]) async {
              final dynamic result = await addContactInfoBottomSheet(
                  context: context,
                  type: ContactInfoType.email,
                  onSave: provider.contactUtils.addPrimaryEmail,
                  primary: primary);
              provider.contactUtils.showMessageFromModal(context, result);
            },
          ),
        if (provider.secondaryPhones !=
            <PhoneNumber>[PhoneNumber.withValue(UNKNOWN)])
          ContactItemsCard(
            title: secondaryPhones,
            addMessage: phonesMessage,
            type: ContactInfoType.phone,
            data: <ContactType<ValueObject<String>>>[
              for (PhoneNumber phoneNumber in provider.secondaryPhones)
                ContactType<ValueObject<String>>(
                  phoneNumber,
                  isSecondary: true,
                )
            ],
            onAddContactInfo: ([bool primary = false]) async {
              final dynamic result = await addContactInfoBottomSheet(
                  context: context,
                  type: ContactInfoType.phone,
                  onSave: provider.contactUtils.addSecondaryPhone);
              provider.contactUtils.showMessageFromModal(context, result);
            },
          ),
        if (provider.primaryEmail != null &&
            provider.secondaryEmails !=
                <EmailAddress>[EmailAddress.withValue(UNKNOWN)])
          ContactItemsCard(
            title: secondaryEmails,
            data: <ContactType<ValueObject<String>>>[
              for (EmailAddress emailAddress in provider.secondaryEmails)
                ContactType<ValueObject<String>>(
                  emailAddress,
                  isSecondary: true,
                )
            ],
            type: ContactInfoType.email,
            addMessage: secondaryEmailsMessage,
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
  final EmailAddress? primaryEmail;
  final PhoneNumber primaryPhone;
  final List<EmailAddress> secondaryEmails;
  final List<PhoneNumber> secondaryPhones;

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
