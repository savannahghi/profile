import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:sil_core_domain_objects/value_objects.dart';
import 'package:sil_user_profile/contact_item.dart';
import 'package:sil_user_profile/contact_utils.dart';
import 'package:sil_user_profile/sil_contacts.dart';

const String testPhoneNumber = '+254712345678';

const Key testButtonKey = Key('button_Key');

ContactProvider testContactProvider(
        dynamic mockSILGraphQlClient, UpdateStateFunc testUpdateState) =>
    ContactProvider(
      primaryEmail: EmailAddress.withValue('someone@example.com'),
      primaryPhone: PhoneNumber.withValue(testPhoneNumber),
      secondaryEmails: <EmailAddress>[EmailAddress.withValue('example@mail')],
      secondaryPhones: <PhoneNumber>[PhoneNumber.withValue(testPhoneNumber)],
      contactUtils: ContactUtils(
        toggleLoadingIndicator: () {},
        client: mockSILGraphQlClient,
        updateStateFunc: testUpdateState,
      ),
      wait: Wait(),
      checkWaitingFor: () {
        return false;
      },
      child: const ContactItem(
        type: ContactInfoType.phone,
        value: testPhoneNumber,
        editable: true,
      ),
    );
