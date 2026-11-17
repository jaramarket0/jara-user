import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

/// First-run feature tour. Each screen owns one scope and shows its steps
/// the first time the user lands there; finishing or skipping a scope marks
/// it seen so it never shows again (until local data is cleared on logout,
/// same as the welcome dialog).
class AppTour {
  AppTour._();

  static const home = 'tour_home';
  static const foodDetail = 'tour_food_detail';
  static const profile = 'tour_profile';

  static const _brand = Color(0xFFFFAA00);

  static Future<bool> isSeen(String scope) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(scope) ?? false;
  }

  static Future<void> _markSeen(String scope) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(scope, true);
  }

  /// Call from the screen's initState; pair with [unregister] in dispose.
  static void register(String scope) {
    ShowcaseView.register(
      scope: scope,
      onFinish: () => _markSeen(scope),
      onDismiss: (_) => _markSeen(scope),
      globalTooltipActionConfig: const TooltipActionConfig(
        alignment: MainAxisAlignment.spaceBetween,
        position: TooltipActionPosition.inside,
      ),
      globalTooltipActions: const [
        TooltipActionButton(
          type: TooltipDefaultActionType.skip,
          textStyle: TextStyle(color: Colors.grey, fontSize: 13),
          backgroundColor: Colors.transparent,
        ),
        TooltipActionButton(
          type: TooltipDefaultActionType.next,
          backgroundColor: _brand,
          textStyle: TextStyle(
              color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  static void unregister(String scope) {
    try {
      ShowcaseView.getNamed(scope).unregister();
    } catch (_) {}
  }

  /// Starts [scope]'s steps once, as soon as the screen is on top (no dialog
  /// or pushed page over it) and its targets are built. Gives up quietly
  /// after [timeout] without marking the tour seen, so it is tried again the
  /// next time the screen opens.
  static Future<void> startIfUnseen(
    State state,
    String scope,
    List<GlobalKey> keys, {
    Duration timeout = const Duration(minutes: 2),
  }) async {
    if (await isSeen(scope)) return;
    final deadline = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(deadline)) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (!state.mounted) return;
      final ShowcaseView view;
      try {
        view = ShowcaseView.getNamed(scope);
      } catch (_) {
        return;
      }
      if (view.isShowcaseRunning) return;
      final onTop = ModalRoute.of(state.context)?.isCurrent ?? true;
      final ready = keys.where(view.isTargetRendered).toList();
      if (onTop && ready.isNotEmpty) {
        view.startShowCase(ready, delay: const Duration(milliseconds: 300));
        return;
      }
    }
  }

  /// Wraps [child] as one tour step.
  static Widget step({
    required GlobalKey key,
    required String scope,
    required String title,
    required String description,
    required Widget child,
    BorderRadius? radius,
  }) {
    return Showcase(
      key: key,
      scope: scope,
      title: title,
      description: description,
      targetBorderRadius: radius ?? BorderRadius.circular(12),
      titleTextStyle: const TextStyle(
          fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xff1F2937)),
      descTextStyle: const TextStyle(
          fontSize: 13, height: 1.4, color: Color(0xff4B5563)),
      tooltipPadding: const EdgeInsets.all(14),
      child: child,
    );
  }
}
