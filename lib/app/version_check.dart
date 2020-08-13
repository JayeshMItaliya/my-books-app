//Prompt users to update app if there is a new version available
//Uses url_launcher package

import 'dart:io';

import 'package:byebye_flutter_app/constants/strings.dart';
import 'package:byebye_flutter_app/my_constants/design_system.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

const APP_STORE_URL =
    'https://apps.apple.com/in/app/byebye-declutter/id1502924762';
const PLAY_STORE_URL =
    'https://play.google.com/store/apps/details?id=io.byebye.inventory&hl=en-GB';

String selectedUpdateAppActionButton;

dynamic versionCheck(context) async {
  //Get Current installed version of app
  final PackageInfo info = await PackageInfo.fromPlatform();
  final double currentVersion =
      double.parse(info.version.trim().replaceAll('.', ''));

  //Get Latest version info from firebase config
  final RemoteConfig remoteConfig = await RemoteConfig.instance;

  try {
    // Using default duration to force fetching from remote server.
    if (Platform.isIOS) {
      await remoteConfig.fetch(expiration: const Duration(seconds: 0));
      await remoteConfig.activateFetched();
      remoteConfig.getString('force_update_current_ios_version');
      final double newVersion = double.parse(remoteConfig
          .getString('force_update_current_ios_version')
          .trim()
          .replaceAll('.', ''));
      if (newVersion > currentVersion) {
        _showVersionDialog(context);
      }
    } else if (Platform.isAndroid) {
      await remoteConfig.fetch(expiration: const Duration(seconds: 0));
      await remoteConfig.activateFetched();
      remoteConfig.getString('force_update_current_android_version');
      final double newVersion = double.parse(remoteConfig
          .getString('force_update_current_android_version')
          .trim()
          .replaceAll('.', ''));
      if (newVersion > currentVersion) {
        _showVersionDialog(context);
      }
    }
  } on FetchThrottledException catch (exception) {
    // Fetch throttled.
    print(exception);
  } catch (exception) {
    print('Unable to fetch remote config. Cached or default values will be '
        'used');
  }
}

//Show Dialog to force user to update
dynamic _showVersionDialog(context) async {
  selectedUpdateAppActionButton = await AlertBoxDialog().showCustomAlertDialog(
    context,
    Strings.updateAvailTitle,
    Strings.updateAvailMessage,
    [Strings.btnCancel, Strings.btnUpdateNow],
  );
  if (selectedUpdateAppActionButton == Strings.btnUpdateNow && Platform.isIOS) {
    _launchURL(APP_STORE_URL);
  } else if (selectedUpdateAppActionButton == Strings.btnUpdateNow &&
      Platform.isAndroid) {
    _launchURL(PLAY_STORE_URL);
  }
}

dynamic _launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
