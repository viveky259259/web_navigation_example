import 'dart:async';
import 'dart:html' as html;

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

class CustomUrlStrategy extends UrlStrategy {
  /// Creates an instance of [CustomUrlStrategy].
  ///
  /// The [PlatformLocation] parameter is useful for testing to mock out browser
  /// interactions.

  const CustomUrlStrategy(
      [this._platformLocation = const BrowserPlatformLocation()]);

  final PlatformLocation _platformLocation;

  @override
  html.VoidCallback addPopStateListener(EventListener fn) {
    print("addPopStateListener():Path ${_platformLocation.pathname}");
    _platformLocation.addPopStateListener(fn);
    return () => _platformLocation.removePopStateListener(fn);
  }

  @override
  String getPath() {
    // the hash value is always prefixed with a `#`
    // and if it is empty then it will stay empty
    print("getPath():Path ${_platformLocation.pathname}");

    final path = _platformLocation.hash;
    assert(path.isEmpty || path.startsWith('#'));

    // We don't want to return an empty string as a path. Instead we default to "/".
    if (path.isEmpty || path == '#') {
      return '/';
    }
    // At this point, we know [path] starts with "#" and isn't empty.
    return path.substring(1);
  }

  @override
  Object? getState() {
    print("getState():Path ${_platformLocation.pathname}");
    return _platformLocation.state;
  }

  @override
  String prepareExternalUrl(String internalUrl) {
    // It's convention that if the hash path is empty, we omit the `#`; however,
    // if the empty URL is pushed it won't replace any existing fragment. So
    // when the hash path is empty, we instead return the location's path and
    // query.
    print("prepareExternalUrl():Path ${_platformLocation.pathname}");
    print("prepareExternalUrl():Internal Url $internalUrl");
    return internalUrl.isEmpty
        ? '${_platformLocation.pathname}${_platformLocation.search}'
        : '$internalUrl';
  }

  @override
  void pushState(Object? state, String title, String url) {
    print("pushState():Path ${_platformLocation.pathname}");
    _platformLocation.pushState(state, title, prepareExternalUrl(url));
  }

  @override
  void replaceState(Object? state, String title, String url) {
    print("replaceState():Path ${_platformLocation.pathname}");
    _platformLocation.replaceState(state, title, prepareExternalUrl(url));
  }

  @override
  Future<void> go(int count) {
    print("go():Path ${_platformLocation.pathname}");
    _platformLocation.go(count);
    return _waitForPopState();
  }

  /// Waits until the next popstate event is fired.
  ///
  /// This is useful, for example, to wait until the browser has handled the
  /// `history.back` transition.
  Future<void> _waitForPopState() {
    print("_waitForPopState():Path ${_platformLocation.pathname}");
    final completer = Completer<void>();
    late html.VoidCallback unsubscribe;
    unsubscribe = addPopStateListener((_) {
      unsubscribe();
      completer.complete();
    });
    return completer.future;
  }
}