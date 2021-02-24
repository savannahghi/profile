import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sil_contacts/contact_utils.dart';
import 'package:sil_contacts/sil_contacts.dart';
import 'package:sil_contacts/utils/constants.dart';
import 'package:sil_dumb_widgets/sil_buttons.dart';
import 'package:sil_dumb_widgets/sil_inputs.dart';
import 'package:sil_dumb_widgets/sil_loader.dart';
import 'package:sil_themes/spaces.dart';
import 'package:sil_themes/text_themes.dart';

/// shows bottom sheet to render [SetContactToPrimary]
/// takes contact type and a value which can be [phone] or [email]
Future<dynamic> upgradeToPrimaryBottomSheet(
    {BuildContext context, ContactInfoType type, String value}) async {
  ContactProvider provider = ContactProvider.of(context);
  return await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                // borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              constraints: BoxConstraints(
                maxWidth: 420,
              ),
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              // margin: EdgeInsets.all(5),
              child: SingleChildScrollView(
                child: SetContactToPrimary(
                  type: type,
                  value: value,
                  provider: provider,
                ),
              ),
            ),
          ),
        );
      });
}

/// takes contact type [ContactInfoType] and a value which can be [phone] or [email]
/// first sends an otp to the [phone] or [email]
/// verifies the otp
/// then uses the otp to set the [phone] or [email] as primary
class SetContactToPrimary extends StatefulWidget {
  final String value;
  final ContactInfoType type;
  final ContactProvider provider;

  const SetContactToPrimary({
    @required this.value,
    @required this.type,
    @required this.provider,
  });

  @override
  _SetContactToPrimaryState createState() => _SetContactToPrimaryState();
}

class _SetContactToPrimaryState extends State<SetContactToPrimary> {
  TextEditingController textEditingController = TextEditingController();
  String otp;
  bool invalidCode = false;
  bool isPhone;
  final String flag = 'set_to_primary';

  @override
  void initState() {
    isPhone = widget.type == ContactInfoType.phone;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (otp == null) ...<Widget>[
          if (isPhone) _buildPhoneAlert(context, widget.provider),
          if (!isPhone) _buildEmailAlert(context, widget.provider),
        ],
        if (otp != null) _buildVerifyWidget(context, widget.provider),
        if (widget.provider.checkWaitingFor(flag: flag)) ...<Widget>[
          size15VerticalSizedBox,
          SILLoader()
        ]
      ],
    );
  }

  Widget _buildVerifyWidget(BuildContext context, ContactProvider provider) {
    return Column(
      children: <Widget>[
        Text(
          ContactDetailsStrings.verifyTitle,
          style: TextThemes.heavySize18Text(Colors.black),
        ),
        mediumVerticalSizedBox,
        Text(
          ContactDetailsStrings.verificationMsg(widget.value),
          style: TextThemes.normalSize15Text(),
          textAlign: TextAlign.center,
        ),
        size40VerticalSizedBox,
        SILPinCodeTextField(
          controller: textEditingController,
          autoFocus: true,
          maxLength: 6,
          pinBoxWidth: 34,
          pinBoxHeight: 38,
          wrapAlignment: WrapAlignment.spaceAround,
          onTextChanged: (dynamic val) {
            if (invalidCode) {
              setState(() {
                invalidCode = false;
              });
            }
          },
          onDone: (dynamic val) async {
            if (val == otp) {
              await provider.contactUtils.verifyContact(
                context: context,
                isPhone: isPhone,
                flag: flag,
                value: widget.value,
                otp: otp,
              );
              return;
            }
            textEditingController.clear();
            await HapticFeedback.vibrate();
            setState(() {
              invalidCode = true;
            });
          },
        ),
        size15VerticalSizedBox,
        if (invalidCode)
          Text(
            ContactDetailsStrings.incorrectCode,
            style: TextThemes.normalSize14Text(Colors.red),
            textAlign: TextAlign.center,
          ),
      ],
    );
  }

  Widget _buildPhoneAlert(BuildContext context, ContactProvider provider) {
    return Column(
      children: <Widget>[
        Icon(
          MdiIcons.phoneAlertOutline,
          size: 70,
        ),
        mediumVerticalSizedBox,
        Text(
          ContactDetailsStrings.alertTitle,
          style: TextThemes.heavySize20Text(Colors.black),
        ),
        mediumVerticalSizedBox,
        Text(
          ContactDetailsStrings.alertMessage(widget.value),
          style: TextThemes.normalSize12Text().copyWith(height: 1.6),
          textAlign: TextAlign.center,
        ),
        mediumVerticalSizedBox,
        if (!provider.checkWaitingFor(flag: flag)) ...<Widget>[
          Container(
            width: double.infinity,
            height: 44,
            child: SILPrimaryButton(
              onPressed: () async {
                provider.contactUtils
                    .toggleLoadingIndicator(context: context, flag: flag);
                Map<String, dynamic> result = await provider.contactUtils
                    .sendPhoneOtp(
                        phone: widget.value, context: context, flag: flag);
                if (result['status'] == 'error') {
                  Navigator.pop(context, <String, String>{
                    'status': 'error',
                    'message': ContactDetailsStrings.sendOtpError(widget.value),
                  });
                  return;
                }
                setState(() {
                  otp = result['otp'];
                });
                return;
              },
              customRadius: 4,
              text: 'Ok, Continue',
            ),
          ),
          mediumVerticalSizedBox,
          Container(
            width: double.infinity,
            height: 44,
            child: SILSecondaryButton(
              onPressed: () {
                Navigator.pop(context);
              },
              text: 'Nop, Cancel',
              customRadius: 4,
              buttonColor: Colors.grey.withOpacity(0.1),
            ),
          )
        ],
      ],
    );
  }

  Widget _buildEmailAlert(BuildContext context, ContactProvider provider) {
    return Column(
      children: <Widget>[
        Icon(
          MdiIcons.emailAlertOutline,
          size: 70,
        ),
        mediumVerticalSizedBox,
        Text(
          ContactDetailsStrings.alertTitle,
          style: TextThemes.heavySize20Text(Colors.black),
        ),
        mediumVerticalSizedBox,
        Text(
          ContactDetailsStrings.alertMessage(widget.value, false),
          style: TextThemes.normalSize12Text().copyWith(height: 1.6),
          textAlign: TextAlign.center,
        ),
        mediumVerticalSizedBox,
        if (!provider.checkWaitingFor(flag: flag)) ...<Widget>[
          Container(
            width: double.infinity,
            height: 44,
            child: SILPrimaryButton(
              onPressed: () async {
                provider.contactUtils
                    .toggleLoadingIndicator(context: context, flag: flag);
                Map<String, dynamic> result = await provider.contactUtils
                    .sendEmailOtp(
                        email: widget.value, context: context, flag: flag);
                if (result['status'] == 'error') {
                  Navigator.pop(context, <String, String>{
                    'status': 'error',
                    'message': ContactDetailsStrings.sendOtpError(widget.value),
                  });
                  return;
                }
                setState(() {
                  otp = result['otp'];
                });
                return;
              },
              customRadius: 4,
              text: 'Ok, Continue',
            ),
          ),
          mediumVerticalSizedBox,
          Container(
            width: double.infinity,
            height: 44,
            child: SILSecondaryButton(
              onPressed: () {
                Navigator.pop(context);
              },
              text: 'Nop, Cancel',
              customRadius: 4,
              buttonColor: Colors.grey.withOpacity(0.1),
            ),
          )
        ],
      ],
    );
  }
}
