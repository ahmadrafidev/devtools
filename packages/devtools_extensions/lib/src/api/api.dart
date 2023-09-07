// Copyright 2023 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'model.dart';

/// Supported events that can be sent and received over 'postMessage' between
/// DevTools and a DevTools extension running in an embedded iFrame.
enum DevToolsExtensionEventType {
  /// An event DevTools will send to an extension to verify that the extension
  /// is ready for use.
  ping(ExtensionEventDirection.toExtension),

  /// An event that an extension will send back to DevTools after receiving a
  /// [ping] event.
  pong(ExtensionEventDirection.toDevTools),

  /// An event that DevTools will send to an extension to notify of the
  /// connected vm service uri.
  vmServiceConnection(ExtensionEventDirection.bidirectional),

  /// An event that an extension will send to DevTools asking DevTools to post
  /// a notification to the DevTools global [notificationService].
  showNotification(ExtensionEventDirection.toDevTools),

  /// An event that an extension will send to DevTools asking DevTools to post
  /// a banner message to the extension's screen using the global
  /// [bannerMessages].
  showBannerMessage(ExtensionEventDirection.toDevTools),

  /// Any unrecognized event that is not one of the above supported event types.
  unknown(ExtensionEventDirection.bidirectional);

  const DevToolsExtensionEventType(this._direction);

  final ExtensionEventDirection _direction;

  static DevToolsExtensionEventType from(String name) {
    for (final event in DevToolsExtensionEventType.values) {
      if (event.name == name) {
        return event;
      }
    }
    return unknown;
  }

  bool supportedForDirection(ExtensionEventDirection direction) {
    return _direction == direction ||
        _direction == ExtensionEventDirection.bidirectional;
  }
}

/// Describes the flow direction for a [DevToolsExtensionEventType].
///
/// Some events are unidirecitonal and some are bidirectional.
enum ExtensionEventDirection {
  /// Describes events that can be sent both from DevTools to extensions and
  /// from extensions to DevTools.
  bidirectional,

  /// Describes events that can be sent from extensions to DevTools, but not
  /// from DevTools to extensions.
  toDevTools,

  /// Describes events that can be sent from DevTools to extensions, but not
  /// from extensions to DevTools.
  toExtension,
}

/// Interface that a DevTools extension host should implement.
///
/// This interface is implemented by DevTools itself as well as by a simulated
/// DevTools environment for simplifying extension development.
abstract interface class DevToolsExtensionHostInterface {
  /// This method should send a [DevToolsExtensionEventType.ping] event to the
  /// DevTools extension to check that it is ready.
  void ping();

  /// This method should send a [DevToolsExtensionEventType.vmServiceConnection]
  /// event to the extension to notify it of the vm service uri it should
  /// establish a connection to.
  void vmServiceConnectionChanged({required String? uri});

  /// Handles events sent by the extension.
  ///
  /// If an unknown event is received, this handler should call [onUnknownEvent]
  /// if non-null.
  void onEventReceived(
    DevToolsExtensionEvent event, {
    void Function()? onUnknownEvent,
  });
}
