// lib/utils/go_router_refresh_stream.dart
import 'dart:async'; // For StreamSubscription
import 'package:flutter/foundation.dart'; // For ChangeNotifier

/// Converts a [Stream] into a [Listenable].
///
/// This is used by [GoRouter] to listen to changes in an authentication state
/// exposed as a [Stream] (e.g., from Riverpod's StateNotifier or Bloc's Stream).
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners(); // Notify listeners immediately on creation
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}