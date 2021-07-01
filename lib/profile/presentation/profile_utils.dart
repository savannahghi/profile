import 'package:app_wrapper/app_wrapper.dart';
import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:user_profile/profile/domain/core/value_objects/app_strings.dart';
import 'package:user_profile/profile/domain/core/value_objects/constants.dart';
import 'package:user_profile/profile/presentation/profile_page_items.dart';
import 'package:user_profile/router/routes.dart';

String returnCurrentYear() {
  final DateTime now = DateTime.now();
  return DateFormat('y').format(now).toString();
}

Future<void> logoutUser(BuildContext context,
    {String? customSignOutMsg}) async {
  /// Notify the user
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Text(customSignOutMsg ?? logoutMessage),
      duration: const Duration(seconds: kLongSnackBarDuration),
      action: dismissSnackBar('close', white, context),
    ));

  await StoreProvider.dispatchFuture<AppState>(
    context,
    LogoutAction(
      afterCallback: () async => triggerNavigationEvent(
          context: context,
          namedRoute: phoneLoginRoute,
          shouldRemoveUntil: true,
          event: logoutEvent),
    ),
  );
}

/// Triggers Navigation event by sending a log to firebase
/// Takes in params:
/// - String `namedRoute` (determines the route to push to after sending log)
/// - BuildContext `context`
/// - bool `shouldReplace` (is used as a flag for navigation events that replace previous routes)
/// - All routes are named.
Future<void> triggerNavigationEvent(
    {required BuildContext context,
    required String namedRoute,
    String? event,
    bool shouldReplace = false,
    Object? args,
    bool shouldRemoveUntil = false}) async {
  /// Event Payload
  final Map<String, dynamic> eventPayload = <String, dynamic>{
    'route': namedRoute,
    'timeTriggered': DateTime.now().toUtc().toIso8601String()
  };

  /// Send event log
  SILAppWrapperBase.of(context)!
      .eventBus
      .fire(TriggeredEvent(event ?? navigationEvent, eventPayload));

  /// Navigation Function
  if (shouldReplace) {
    await Navigator.of(context)
        .pushReplacementNamed(namedRoute, arguments: args);
  } else if (shouldRemoveUntil) {
    await Navigator.of(context).pushNamedAndRemoveUntil(
      namedRoute,
      ModalRoute.withName(namedRoute),
    );
  } else {
    await Navigator.of(context).pushNamed(namedRoute, arguments: args);
  }
}

/// [toggleWaitStateFlagIndicator] a generic function that call `WaitAction` to `add`
/// or `remove` a flag. When `show` is [true], the flag will be removed.
void toggleWaitStateFlagIndicator(
    {required BuildContext context, required String flag, bool show = true}) {
  show
      ? StoreProvider.dispatch<AppState>(
          context,
          WaitAction<AppState>.add(flag, ref: '${flag}_ref'),
        )
      : StoreProvider.dispatch<AppState>(
          context,
          WaitAction<AppState>.remove(flag, ref: '${flag}_ref'),
        );
}

/// [navigateToProfileItemPage] function is used to validate routes in user profile page,
/// If route is provided, it navigates to the specified page and if route is null it displays
/// A coming soon snack bar
Future<void> navigateToProfileItemPage({
  required BuildContext context,
  required ProfileItem profileItem,
}) async {
  if (profileItem.onTapRoute == pinVerificationRoute) {
    triggerNavigationEvent(
        context: context,
        namedRoute: profileItem.onTapRoute,
        args: PinVerificationType.pinChange);
  } else {
    await triggerNavigationEvent(
        context: context, namedRoute: profileItem.onTapRoute);
  }
}
