import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HelperFunctions {
  static void navigateToScreen(
    BuildContext context,
    String location, {
    Object? extra,
  }) {
    context.push(location, extra: extra);
  }
  // TODO: do some work on this later

  static String timeAgo(DateTime date, {DateTime? now}) {
    final DateTime current = now ?? DateTime.now();
    Duration diff = current.difference(date);

    // If the date is in the future (clock skew / scheduled), treat it as now.
    if (diff.isNegative) diff = Duration.zero;

    if (diff.inSeconds < 45) return 'just now';
    if (diff.inMinutes < 2) return '1 minute ago';
    if (diff.inMinutes < 60) return '${diff.inMinutes} minutes ago';

    if (diff.inHours < 2) return '1 hour ago';
    if (diff.inHours < 24) return '${diff.inHours} hours ago';

    if (diff.inDays < 2) return '1 day ago';
    if (diff.inDays < 7) return '${diff.inDays} days ago';

    final int weeks = diff.inDays ~/ 7;
    if (weeks < 2) return '1 week ago';
    if (weeks < 5) return '$weeks weeks ago';

    final int months = diff.inDays ~/ 30;
    if (months < 2) return '1 month ago';
    if (months < 12) return '$months months ago';

    final int years = diff.inDays ~/ 365;
    if (years < 2) return '1 year ago';
    return '$years years ago';
  }

  static bool isDarkMode(BuildContext context) {
    return MediaQuery.of(context).platformBrightness == Brightness.dark;
  }

  static Size getScreenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static Size getWidgetSize(GlobalKey key) {
    final RenderBox? renderBox =
        key.currentContext?.findRenderObject() as RenderBox?;
    return renderBox?.size ?? Size.zero;
  }

  static EdgeInsets getSafeAreaPadding(BuildContext context) {
    return MediaQuery.of(context).padding;
  }
}
