import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sil_ui_components/sil_platform_loader.dart';
import 'package:sil_user_profile/contact_utils.dart';
import 'package:sil_user_profile/helpers.dart';
import 'package:sil_user_profile/shared/widget_keys.dart';
import 'package:sil_user_profile/sil_contacts.dart';
import 'package:sil_user_profile/constants.dart';
import 'package:sil_ui_components/sil_buttons.dart';
import 'package:sil_ui_components/sil_inputs.dart';
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

  return Navigator.push(
    context,
    MaterialPageRoute<dynamic>(
      builder: (BuildContext context) => AddContactWrapper(
        isPhone: isPhone,
        provider: provider,
        primary: primary,
        type: type,
        onSave: onSave,
      ),
    ),
  );
}

class AddContactWrapper extends StatelessWidget {
  const AddContactWrapper({
    Key? key,
    required this.isPhone,
    required this.provider,
    required this.onSave,
    required this.type,
    required this.primary,
  }) : super(key: key);

  final bool isPhone;
  final ContactProvider? provider;
  final bool primary;
  final Function onSave;
  final ContactInfoType type;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                mediumVerticalSizedBox,
                Text(
                  isPhone ? phone : email,
                  style: TextThemes.heavySize20Text(Colors.black),
                  textAlign: TextAlign.center,
                ),
                mediumVerticalSizedBox,
                Text(
                  isPhone ? phonesMessage : emailMessage,
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
                mediumVerticalSizedBox,
                GestureDetector(
                  key: cancelAddContact,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextThemes.boldSize15Text(Colors.red[400]),
                  ),
                ),
                mediumVerticalSizedBox
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// adds a contact to an account
/// optionally sends an otp first if [primary] flag is set to true in the case of a primary email
class AddContactInfo extends StatefulWidget {
  const AddContactInfo({
    required this.type,
    required this.onSave,
    required this.primary,
    required this.provider,
  });

  final ContactInfoType type;
  final Function onSave;
  final bool primary;
  final ContactProvider? provider;
  @override
  _AddContactInfoState createState() => _AddContactInfoState();
}

class _AddContactInfoState extends State<AddContactInfo> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController phoneNumberInputController = TextEditingController();
  TextEditingController textEditingController = TextEditingController();
  AddContactBehaviorSubject addContactBehaviorSubject =
      AddContactBehaviorSubject();

  String? value;
  String? otp;

  final String flag = 'add_contact_info';

  void setOtp(String val) {
    setState(() {
      otp = val;
    });
  }

  void toggleInvalidCodeMsg({required bool val}) {
    addContactBehaviorSubject.invalidCode.add(val);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final bool invalidCode =
        addContactBehaviorSubject.invalidCode.valueWrapper!.value;
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
                labelText: labelText,
                labelStyle: TextThemes.boldSize16Text(),
                onChanged: (String? val) {
                  value = val;
                },
                phoneNumberFormatter: formatPhoneNumber,
              ),
            // email
            if (widget.type == ContactInfoType.email)
              SILFormTextField(
                key: addEmailAddressKey,
                labelText: email,
                hintText: emailHint,
                keyboardType: TextInputType.emailAddress,
                borderColor: Colors.grey.withOpacity(0.5),
                prefixIcon: const Icon(MdiIcons.email),
                validator: (dynamic value) {
                  if (value.isEmpty as bool) {
                    return emailValidationMessage;
                  }

                  if (!ContactUtils.validateEmail(value.toString())) {
                    return emailValidationMessage;
                  }

                  return null;
                },
                onChanged: (dynamic val) {
                  value = val.toString();
                },
              ),
            size40VerticalSizedBox,
            // save button
            if (widget.provider != null)
              if (!(widget.provider?.checkWaitingFor(flag: flag) as bool))
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: SILPrimaryButton(
                    buttonKey: saveButtonKey,
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
            /// Verify otp input here
            SILPinCodeTextField(
              controller: textEditingController,
              autoFocus: true,
              maxLength: 6,
              pinBoxWidth: 34,
              pinBoxHeight: 38,
              wrapAlignment: WrapAlignment.spaceAround,
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
                incorrectCode,
                textAlign: TextAlign.center,
                style: TextThemes.normalSize15Text(Colors.red),
              )
            ],
            size40VerticalSizedBox,
          ],
          if (widget.provider != null)
            Center(
              child: getLoader(
                  show: widget.provider?.checkWaitingFor(flag: flag) as bool),
            )
        ],
      ),
    );
  }
}

Widget getLoader({required bool show}) {
  return show ? const SILPlatformLoader() : const SizedBox();
}

class AddContactBehaviorSubject {
  factory AddContactBehaviorSubject() {
    return _singleton;
  }
  AddContactBehaviorSubject._internal();
  static final AddContactBehaviorSubject _singleton =
      AddContactBehaviorSubject._internal();

  BehaviorSubject<bool> invalidCode = BehaviorSubject<bool>.seeded(false);
}
