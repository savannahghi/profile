import 'package:flutter_test/flutter_test.dart';
import 'package:user_profile/contact_utils.dart';

import '../test_utils.dart';

void main() {
  group('validateEmail', () {
    test('should return true', () async {
      expect(ContactUtils.validateEmail(testEmail), true);
    });

    test('should return false', () async {
      expect(ContactUtils.validateEmail(testInvalidEmail), false);
    });
  });
}
