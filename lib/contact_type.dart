import 'package:sil_core_domain_objects/value_objects.dart';

class ContactType<T extends ValueObject<String>> {
  final T contactItemValueObject;
  final bool isSecondary;

  ContactType(this.contactItemValueObject, {this.isSecondary = false});

  String value() {
    return contactItemValueObject.getValue();
  }

  Type typeOf() {
    return T;
  }
}
