import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sil_contacts/contact_utils.dart';
import 'package:sil_contacts/sil_contacts.dart';
import 'package:sil_contacts/utils/constants.dart';
import 'package:sil_ui_components/sil_buttons.dart';
import 'package:sil_ui_components/sil_inputs.dart';
import 'package:sil_ui_components/sil_loader.dart';
import 'package:sil_themes/spaces.dart';
import 'package:sil_themes/text_themes.dart';

/// shows a bottom sheet that renders [AddContactInfo]
/// takes contact type and a save function
Future<dynamic> addContactInfoBottomSheet(
    {required BuildContext context,
    required ContactInfoType type,
    required Function onSave,
    bool primary = false}) async {
  final bool isPhone = type == ContactInfoType.phone;
  final ContactProvider? provider = ContactProvider.of(context);
  return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            constraints: const BoxConstraints(
              maxWidth: 420,
            ),
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  mediumVerticalSizedBox,
                  Text(
                    isPhone
                        ? ContactDetailsStrings.phone
                        : ContactDetailsStrings.email,
                    style: TextThemes.heavySize20Text(Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  mediumVerticalSizedBox,
                  Text(
                    isPhone
                        ? ContactDetailsStrings.phonesMessage
                        : ContactDetailsStrings.emailMessage,
                    style: TextThemes.normalSize15Text(),
                    textAlign: TextAlign.center,
                  ),
                  size40VerticalSizedBox,
                  AddContactInfo(
                    type: type,
                    onSave: onSave,
                    primary: primary,
                    provider: provider,
                  ),
                ],
              ),
            ),
          ),
        );
      });
}

/// adds a contact to an account
/// optionally sends an otp first if [primary] flag is set to true in the case of a primary email
class AddContactInfo extends StatefulWidget {
  final ContactInfoType type;
  final Function onSave;
  final bool primary;
  final ContactProvider? provider;

  const AddContactInfo({
    required this.type,
    required this.onSave,
    required this.primary,
    required this.provider,
  });
  @override
  _AddContactInfoState createState() => _AddContactInfoState();
}

class _AddContactInfoState extends State<AddContactInfo> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Queue<int> phoneNumberInputController = Queue<int>();
  TextEditingController textEditingController = TextEditingController();

  String? value;
  String? otp;
  bool invalidCode = false;

  final String flag = 'add_contact_info';

  void setOtp(String val) {
    setState(() {
      otp = val;
    });
  }

  void toggleInvalidCodeMsg({bool? val}) {
    setState(() {
      invalidCode = val!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          if (otp == null) ...<Widget>[
            // phone number
            if (widget.type == ContactInfoType.phone)
              SILPhoneInput(
                inputController: phoneNumberInputController,
                enabled: true,
                labelText: ContactDetailsStrings.labelText,
                labelStyle: TextThemes.boldSize16Text(),
                onChanged: (dynamic val) {
                  this.phoneNumberInputController.add(1);
                  value = val.toString();
                },
              ),
            // email
            if (widget.type == ContactInfoType.email)
              SILFormTextField(
                key: const Key('add_email_field'),
                context: context,
                labelText: ContactDetailsStrings.email,
                hintText: ContactDetailsStrings.emailHint,
                keyboardType: TextInputType.emailAddress,
                borderColor: Colors.grey.withOpacity(0.5),
                prefixIcon: const Icon(MdiIcons.email),
                validator: (dynamic value) {
                  if (value.isEmpty as bool) {
                    return ContactDetailsStrings.emailValidationMessage;
                  }

                  if (!ContactUtils.validateEmail(value.toString())) {
                    return ContactDetailsStrings.emailValidationMessage;
                  }

                  return null;
                },
                onChanged: (dynamic val) {
                  value = val.toString();
                },
              ),
            size40VerticalSizedBox,
            // save button
            if (!(widget.provider!.checkWaitingFor(flag: flag) as bool))
              SizedBox(
                width: double.infinity,
                height: 48,
                child: SILPrimaryButton(
                  onPressed: () async {
                    if (value == null) {
                      return;
                    }
                    if (_formKey.currentState!.validate()) {
                      await widget.provider!.contactUtils.genericAddContact(
                          context: context,
                          value: value,
                          type: widget.type,
                          setOtp: setOtp,
                          flag: flag,
                          primary: widget.primary);
                    }
                  },
                  text: 'Save',
                ),
              ),
          ],
          if (otp != null) ...<Widget>[
            // verify otp input here
            SILPinCodeTextField(
              controller: textEditingController,
              autoFocus: true,
              maxLength: 6,
              pinBoxWidth: 34,
              pinBoxHeight: 38,
              wrapAlignment: WrapAlignment.spaceAround,
              onTextChanged: (dynamic val) {
                if (invalidCode) {
                  toggleInvalidCodeMsg(val: false);
                }
              },
              onDone: (String v) async {
                await widget.provider!.contactUtils.verifyAddPrimaryEmailOtp(
                  context: context,
                  otp: otp,
                  userInput: v,
                  email: value,
                  flag: flag,
                  toggleInvalidCodeMsg: toggleInvalidCodeMsg,
                  controller: textEditingController,
                );
              },
            ),

            /// show
            if (invalidCode) ...<Widget>[
              mediumVerticalSizedBox,
              Text(
                ContactDetailsStrings.incorrectCode,
                textAlign: TextAlign.center,
                style: TextThemes.normalSize15Text(Colors.red),
              )
            ],
            size40VerticalSizedBox,
          ],
          if (widget.provider!.checkWaitingFor(flag: flag) as bool)
            const Center(
              child: SILLoader(),
            )
        ],
      ),
    );
  }
}
