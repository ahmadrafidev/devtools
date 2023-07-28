// Copyright 2023 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';

import 'package:devtools_shared/devtools_extensions.dart';
import 'package:devtools_shared/src/extensions/extension_activation.dart';
import 'package:test/test.dart';

void main() {
  group('$DevToolsOptions', () {
    late DevToolsOptions options;
    late Directory tmpDir;
    late Uri tmpUri;

    setUp(() {
      options = DevToolsOptions();
      tmpDir = Directory.current.createTempSync();
      tmpUri = Uri.parse(tmpDir.path);
    });

    tearDown(() {
      options = DevToolsOptions();
      tmpDir.deleteSync(recursive: true);
    });

    File _optionsFileFromTmp() {
      final tmpFiles = tmpDir.listSync();
      expect(tmpFiles, isNotEmpty);
      final optionsFile =
          File('${tmpDir.path}/${DevToolsOptions.optionsFileName}');
      expect(optionsFile.existsSync(), isTrue);
      return optionsFile;
    }

    test('extensionActivatedState creates options file when none exists', () {
      expect(tmpDir.listSync(), isEmpty);
      options.lookupExtensionActivationState(
        rootUri: tmpUri,
        extensionName: 'foo',
      );
      final file = _optionsFileFromTmp();
      expect(
        file.readAsStringSync(),
        '''
extensions:
''',
      );
    });

    test('can write to options file', () {
      options.setExtensionActivationState(
        rootUri: tmpUri,
        extensionName: 'foo',
        activate: true,
      );
      final file = _optionsFileFromTmp();
      expect(
        file.readAsStringSync(),
        '''
extensions:
  - foo: true''',
      );
    });

    test('can read from options file', () {
      options.setExtensionActivationState(
        rootUri: tmpUri,
        extensionName: 'foo',
        activate: true,
      );
      options.setExtensionActivationState(
        rootUri: tmpUri,
        extensionName: 'bar',
        activate: false,
      );
      final file = _optionsFileFromTmp();
      expect(
        file.readAsStringSync(),
        '''
extensions:
  - foo: true
  - bar: false''',
      );

      expect(
        options.lookupExtensionActivationState(
          rootUri: tmpUri,
          extensionName: 'foo',
        ),
        ExtensionActivationState.enabled,
      );
      expect(
        options.lookupExtensionActivationState(
          rootUri: tmpUri,
          extensionName: 'bar',
        ),
        ExtensionActivationState.disabled,
      );
      expect(
        options.lookupExtensionActivationState(
          rootUri: tmpUri,
          extensionName: 'baz',
        ),
        ExtensionActivationState.none,
      );
    });
  });
}
