import 'package:flutter/material.dart';

abstract class PlatformWidget extends StatelessWidget {
//  Widget buildCupertinoWidget(BuildContext context);
  Widget buildMaterialWidget(BuildContext context);

  @override
  Widget build(BuildContext context) {
    // TODO(Marius): Build Platform Specific Dialogs.
//    if (Platform.isIOS) {
//      return buildCupertinoWidget(context);
//    }
    return buildMaterialWidget(context);
  }
}
