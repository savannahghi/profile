import 'package:built_collection/built_collection.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sil_contacts/contact_item.dart';
import 'package:sil_contacts/contact_utils.dart';
import 'package:sil_themes/text_themes.dart';

/// renders [ContactItem]s based on data supplied [primary] or [secondary] contacts
/// the data supplied is either a [string] or an [list] of contacts
/// [onAddContactInfo] opens an add contact bottom sheet
class ContactItemsCard extends StatelessWidget {
  final String title;
  final String addMessage;
  final dynamic data;
  final Function onAddContactInfo;
  final ContactInfoType type;

  Widget _buildMsgWidget([bool primary = false]) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      decoration: BoxDecoration(color: Colors.white),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              addMessage,
              style: TextThemes.normalSize14Text(),
            ),
          ),
          GestureDetector(
            key: Key('add_contact_key'),
            onTap: () {
              onAddContactInfo(primary);
            },
            child: Icon(
              MdiIcons.plusCircle,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  dynamic _buildContactItem(dynamic data) {
    if (data == 'UNKNOWN') {
      /// there is no data, so show a message
      return _buildMsgWidget(true);
    }

    if (data.runtimeType == String) {
      /// data is a string and contains a [primary] contact
      return ContactItem(
        value: data,
        type: type,
      );
    }

    if (data is BuiltList) {
      /// data is a list and contains [secondary] contacts
      BuiltList<String> items = data as BuiltList<String>;
      return Column(
        children: <Widget>[
          for (String item in items)
            ContactItem(
              value: item,
              type: type,
              editable: true,
            ),
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
          _buildMsgWidget(),
        ],
      );
    }
  }

  const ContactItemsCard({
    Key key,
    @required this.title,
    @required this.data,
    @required this.type,
    this.addMessage,
    this.onAddContactInfo,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // title
        Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).accentColor.withOpacity(0.06),
          ),
          child: Row(
            children: <Widget>[
              Text(
                title,
                style: TextThemes.heavySize16Text(),
              ),
            ],
          ),
        ),

        /// take data which can be [string] or [list] and return contact item(s)
        _buildContactItem(data)
      ],
    );
  }
}
