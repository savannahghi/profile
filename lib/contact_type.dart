import 'package:sil_core_domain_objects/value_objects.dart';

class ContactType<T extends ValueObject<String>> {
  ContactType(this.contactItemValueObject, {this.isSecondary = false});

  final T contactItemValueObject;
  final bool isSecondary;

  String value() {
    return contactItemValueObject.getValue();
  }

  Type typeOf() {
    return T;
  }
}
