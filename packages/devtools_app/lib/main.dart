// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'src/app.dart';
import 'src/config_specific/framework_initialize/framework_initialize.dart';

void main() async {
  await initializeFramework();

  // Now run the app.
  runApp(
    DevToolsApp(defaultScreens),
  );
}
