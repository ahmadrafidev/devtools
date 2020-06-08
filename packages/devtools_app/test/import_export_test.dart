// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:devtools_app/src/config_specific/import_export/import_export.dart';
import 'package:test/test.dart';

import 'support/wrappers.dart';

void main() async {
  group('ImportControllerTest', () {
    ImportController importController;
    TestNotifications notifications;
    setUp(() {
      notifications = TestNotifications();
      importController = ImportController(notifications, (_) {});
    });

    test('importData pushes proper notifications', () async {
      expect(notifications.messages, isEmpty);
      importController.importData(nonDevToolsFileJson);
      expect(notifications.messages.length, equals(1));
      expect(notifications.messages, contains(nonDevToolsFileMessage));

      await Future.delayed(const Duration(
          milliseconds: ImportController.repeatImportTimeBufferMs));
      importController.importData(devToolsFileJson);
      expect(notifications.messages.length, equals(2));
      expect(
        notifications.messages,
        contains(attemptingToImportMessage('example')),
      );
    });
  });
}

final nonDevToolsFileJson = <String, dynamic>{};
final devToolsFileJson = <String, dynamic>{
  'devToolsSnapshot': true,
  'activeScreenId': 'example',
  'example': {'title': 'example custom tools'}
};
