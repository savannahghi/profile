[![Release](https://img.shields.io/badge/PreRelease-^0.2.2-success.svg?style=for-the-badge)](https://shields.io/)
[![Maintained](https://img.shields.io/badge/Maintained-Actively-informational.svg?style=for-the-badge)](https://shields.io/)

# user_profile

`user_profile` is an open source project &mdash; it's one among many other shared libraries that make up the wider ecosystem of software made and open sourced by `Savannah Informatics Limited`.

It is a shared library between [BeWell-Consumer] and [SladeAdvantage] and is responsible for the user profile displayed on both apps and the associated actions that can be performed on Profile.

It is continuously maintained and updated by maintainers & reviewers

## Installation Instructions

Use this package as a library by depending on it

Run this command:

- With Flutter:

```dart
$ flutter pub add user_profile
```

This will add a line like this to your package's pubspec.yaml (and run an implicit dart pub get):

```dart
dependencies:
  user_profile: ^0.2.2-nullsafety
```

Alternatively, your editor might support flutter pub get. Check the docs for your editor to learn more.

Lastly:

Import it like so:

```dart
import 'package:user_profile/sil_contacts.dart';
```


## Usage

Check the [example](https://github.com/savannahghi/user_profile/blob/main/example/main.dart) provided for how to use this package.

## Dart & Flutter Version

- Dart 2: >= 2.14
- Flutter: >=2.0.0

## Developing & Contributing

First off, thanks for taking the time to contribute!

Be sure to check out detailed instructions on how to contribute to this project [here](https://github.com/savannahghi/user_profile/blob/main/CONTRIBUTING.md) and go through out [Code of Conduct](https://github.com/savannahghi/user_profile/blob/main/CONTRIBUTING.md).

GPG Signing: 
As a contributor, you need to sign your commits. For more details check [here](https://docs.github.com/en/github/authenticating-to-github/managing-commit-signature-verification/signing-commits)

## License

This library is distributed under the MIT license found in the [LICENSE](https://github.com/savannahghi/user_profile/blob/main/LICENSE) file.