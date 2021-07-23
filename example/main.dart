import 'package:flutter/material.dart';
import 'package:user_profile/contacts.dart';

/// This class renders [ContactDetails] which is the root page for this package
/// 
/// It renders [ContactItemsCard]s with details including:
/// - User's Contact Info (Primary Phone Number, Primary Email Address, Secondary Contact Details (phone Number and email))
class UserProfileExample extends StatelessWidget {
  const UserProfileExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ContactDetails();
  }
}
