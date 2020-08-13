import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:byebye_flutter_app/bloc/edit_account_bloc.dart';
import 'package:byebye_flutter_app/common_widgets/platform_alert_dialog.dart';
import 'package:byebye_flutter_app/constants/strings.dart';
import 'package:byebye_flutter_app/my_constants/design_system.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_pickers/country_picker_cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:image_picker/image_picker.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:url_launcher/url_launcher.dart';

import '../my_constants/design_system.dart';
import 'account_story.dart';

class MyAccountPreferences extends StatefulWidget {
  @override
  _MyAccountPreferencesState createState() => _MyAccountPreferencesState();
}

class _MyAccountPreferencesState extends State<MyAccountPreferences>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  bool imageUploaded = false;
  TabController _tabController;
  TextEditingController userName = TextEditingController();
  TextEditingController userEmail = TextEditingController();
  TextEditingController userGender = TextEditingController();
  TextEditingController userAge = TextEditingController();
  TextEditingController userLocation = TextEditingController();
  TextEditingController userWorking = TextEditingController();
  dynamic selectedGender = ' ';
  dynamic updateButton;
  String selectedButtonOption;
  final Country _selectedCupertinoCountry =
      CountryPickerUtils.getCountryByIsoCode('tr');
  static RegExp usernameRegEx = RegExp(r'^[a-zA-Z0-9]{3,35}$');
  static RegExp validEmailRegEx = RegExp(
      r'^[a-zA-Z0-9.!#$%&‘+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)$');
  final imagePicker = ImagePicker();
  double screenHeight;

  dynamic chooseSourceOfPhoto(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 60,
            color: myBackgroundColor,
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      _cameraPicker();
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.photo_camera),
                    color: myAccentColor,
                    iconSize: 32.0,
                  ),
                  IconButton(
                    onPressed: () {
                      _galleryPicker();
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.photo_library),
                    color: myAccentColor,
                    iconSize: 32.0,
                  )
                ],
              ),
            ),
          );
        });
  }

  dynamic _cameraPicker() async {
    final captureFile = await imagePicker.getImage(
        source: ImageSource.camera, imageQuality: 50);

    final File cameraImage = File(captureFile.path);
    if (cameraImage != null) {
      final compressedImage = await editAccountBloc.compressImage(
          cameraImage, screenHeight.toInt());
      final uploadImageSizeInMb = compressedImage.lengthSync() / 1000000;
      if (uploadImageSizeInMb > 2.0) {
        PlatformAlertDialog(
          title: Strings.fileSize,
          content: Strings.fileSizeError,
          defaultActionText: Strings.cancel,
        ).show(context);
      } else {
        Loader().showLoader(context);
        setState(() {
          imageUploaded = true;
        });
        uploadProfileImage(compressedImage);
      }
    }
  }

  dynamic _galleryPicker() async {
    final pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
    final File galleryImage = File(pickedFile.path);
    if (galleryImage != null) {
      final compressedImage = await editAccountBloc.compressImage(
          galleryImage, screenHeight.toInt());
      final uploadImageSizeInMb = compressedImage.lengthSync() / 1000000;
      if (uploadImageSizeInMb > 2.0) {
        PlatformAlertDialog(
          title: Strings.fileSize,
          content: Strings.fileSizeError,
          defaultActionText: Strings.cancel,
        ).show(context);
      } else {
        Loader().showLoader(context);
        setState(() {
          imageUploaded = true;
        });
        uploadProfileImage(compressedImage);
      }
    }
  }

  dynamic uploadProfileImage(image) async {
    final random = Random();
    final int randomNo = random.nextInt(1000);
    final String imageName = 'ProfileImage' + randomNo.toString();
    final StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('userDetails')
        .child('profileImages')
        .child(imageName);
    final StorageUploadTask storageUploadTask = storageReference.putFile(image);
    final downloadUrl =
        await (await storageUploadTask.onComplete).ref.getDownloadURL();
    final StorageTaskSnapshot storageTaskSnapshot =
        await storageUploadTask.onComplete;

    setState(() {
      if (storageTaskSnapshot.error == null) {
        Firestore.instance
            .collection('users')
            .document(prefsObject.getString('uid'))
            .updateData({'photoUrl': downloadUrl.toString()}).then((value) {
          setState(() {
            imageUploaded = false;
            prefsObject.setString('photoUrl', downloadUrl.toString());
            Loader().hideLoader(context);
          });
        });
      }
    });
  }

  dynamic validateUsername(String username) {
    bool valid = false;
    bool match = false;
    if (allUserName.contains(username)) {
      match = true;
    } else if (!usernameRegEx.hasMatch(username)) {
      valid = true;
    }
    return [match, valid];
  }

  dynamic checkEmail(String email) {
    bool valid = false;
    if (!validEmailRegEx.hasMatch(email)) {
      valid = true;
    }
    return valid;
  }

  Future<dynamic> updateUserProfile() async {
    bool result = false;

    if (userName.text.isEmpty) {
      PlatformAlertDialog(
        title: Strings.usernameEmpty,
        content: Strings.usernameEmptyWarning,
        defaultActionText: Strings.cancel,
      ).show(context);
    } else {
      final dynamic checkValidName = validateUsername(userName.text);
      final dynamic checkValidEmail = checkEmail(userEmail.text);
      if (checkValidEmail) {
        PlatformAlertDialog(
          title: Strings.validEmail,
          content: Strings.validEmailWarning,
          defaultActionText: Strings.cancel,
        ).show(context);
        return result;
      }
      if (checkValidName[0]) {
        PlatformAlertDialog(
          title: Strings.dupUserName,
          content: Strings.dupUserNameWarning,
          defaultActionText: Strings.cancel,
        ).show(context);
        return result;
      } else if (checkValidName[1]) {
        PlatformAlertDialog(
          title: Strings.usernameValidation,
          content: Strings.usernameValidationWarning,
          defaultActionText: Strings.cancel,
        ).show(context);
        return result;
      } else {
        final Map<String, dynamic> values = {};
        values['name'] = userName.text.isNotEmpty ? userName.text : '';
        values['emailId'] = userEmail.text.isNotEmpty ? userEmail.text : '';
        values['gender'] = selectedGender.isNotEmpty ? selectedGender : '';
        values['age'] = userAge.text.isNotEmpty ? userAge.text : '';
        values['location'] =
            userLocation.text.isNotEmpty ? userLocation.text : '';
        values['workingIn'] =
            userWorking.text.isNotEmpty ? userWorking.text : '';
        await Firestore.instance
            .collection('users')
            .document(prefsObject.getString('uid'))
            .updateData(values)
            .then((value) {
          prefsObject.setString('name', userName.text);
          prefsObject.setString('emailId', userEmail.text);
          prefsObject.setString('gender', selectedGender);
          prefsObject.setString('age', userAge.text);
          prefsObject.setString('location', userLocation.text);
          prefsObject.setString('workingIn', userWorking.text);
          result = true;
        });
        return result;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getUserDetails();
    getUsername();
  }

  dynamic getUserDetails() {
    userName.text = prefsObject.getString('name');
    userEmail.text = prefsObject.get('emailId');
    editAccountBloc.updateSelectedGender(prefsObject.getString('gender'));
    selectedGender = prefsObject.getString('gender');
    userAge.text = prefsObject.getString('age');
    userLocation.text = prefsObject.getString('location');
    userWorking.text = prefsObject.getString('workingIn');
  }

  dynamic allUserName = [];

  dynamic getUsername() async {
    dynamic userData;
    allUserName = [];
    final Query query = Firestore.instance.collection('users');
    final QuerySnapshot querySnapshot = await query.getDocuments();
    if (querySnapshot.documents.isNotEmpty) {
      userData = querySnapshot.documents;

      for (dynamic user in userData) {
        allUserName.add(user.data['name']);
      }
      allUserName.sort();
      final int myUsername = allUserName.indexOf(prefsObject.getString('name'));
      allUserName.removeAt(myUsername);
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        key: _key,
        appBar: myAccountPreferencesAppBar(),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: mySurfaceColor,
                  /*border: Border(
                    bottom: BorderSide(width: 1, color: myPrimaryColor),
                  ),*/
                ),
                height: 56,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    TabBar(
                      controller: _tabController,
                      indicator: UnderlineTabIndicator(
                          borderSide: BorderSide(
                            width: 4,
                            color: myPrimaryColor,
                          ),
                          insets: EdgeInsets.only(
                              left: 0, right: 0, bottom: 0, top: 0)),
                      isScrollable: true,
                      labelPadding: EdgeInsets.only(
                          left: 16, top: 10, right: 12, bottom: 4),
                      tabs: [
                        Tab(
                          child: Text(Strings.accountPreferencesTab1,
                              style: Theme.of(context).textTheme.subtitle2),
                        ),
                        Tab(
                          child: Text(Strings.accountPreferencesTab2,
                              style: Theme.of(context).textTheme.subtitle2),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  child: TabBarView(
                    children: [
                      /* first tab*/
                      ListView(
                        children: [
                          /* first element */
                          Container(
                            padding: EdgeInsets.only(
                                left: 24, top: 32, bottom: 32, right: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    chooseSourceOfPhoto(context);
                                  },
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image:
                                            prefsObject.getString('photoUrl') ==
                                                        null ||
                                                    prefsObject.getString(
                                                            'photoUrl') ==
                                                        ''
                                                ? AssetImage('assets/user.png')
                                                : NetworkImage(
                                                    prefsObject
                                                        .getString('photoUrl'),
                                                  ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(36, 32, 0, 8),
                                  child: GestureDetector(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          Strings.accountPreferencesStoryButton,
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption
                                              .copyWith(
                                                  color: myOnBackgroundColor),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8, bottom: 8),
                                          child: Icon(Icons.movie_filter,
                                              color: myOnBackgroundColor,
                                              size: 40),
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              MyAccountStory(),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          /* second item - start*/

                          /* second item - end*/

                          MyAccountTile(Strings.accountPreferencesUsername,
                              userName, null, false, 1),
                          MyAccountTile(Strings.accountPreferencesEmail,
                              userEmail, null, false, 1),
                          genderDropDown(),
                          MyAccountTile(Strings.accountPreferencesAge, userAge,
                              null, false, 2),
                          MyAccountTile(Strings.accountPreferencesCountry,
                              userLocation, countryPicker, true, 1),
                          MyAccountTile(Strings.accountPreferencesWorkingIn,
                              userWorking, null, false, 1),
                        ],
                      ),
                      /* second tab*/
                      Container(
                        padding: EdgeInsets.fromLTRB(24, 16, 24, 0),
                        child: LegalList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        resizeToAvoidBottomPadding: true,
      ),
    );
  }

  Widget myAccountPreferencesAppBar() {
    /*const String _myAccountPreferencesAppBarText = 'ACCOUNT PREFERENCES';*/
    return AppBar(
      elevation: 0,
      centerTitle: false,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: myOnPrimaryColor),
        onPressed: () async {
          if (prefsObject.getString('name') != userName.text ||
              prefsObject.getString('emailId') != userEmail.text ||
              prefsObject.getString('gender') != selectedGender ||
              prefsObject.getString('age') != userAge.text ||
              prefsObject.getString('location') != userLocation.text ||
              prefsObject.getString('workingIn') != userWorking.text) {
            selectedButtonOption = await AlertBoxDialog().showCustomAlertDialog(
                context,
                Strings.updateInfo,
                Strings.updateInfoWarning,
                [Strings.ok, Strings.cancel]);
            if (selectedButtonOption == Strings.ok) {
              await updateUserProfile().then((result) {
                if (result) {
                  Navigator.pop(context);
                }
              });
            } else {
              Navigator.of(context).pop();
            }
          } else {
            Navigator.of(context).pop();
          }
        },
      ),
      titleSpacing: 0.0,
      title: Text(
        Strings.accountPreferencesAppBar,
        style: Theme.of(context)
            .textTheme
            .subtitle2
            .copyWith(color: myOnPrimaryColor),
      ),
    );
  }

  Widget genderDropDown() {
    return Container(
      height: 95,
      padding: EdgeInsets.only(left: 16, top: 0, right: 16, bottom: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 16, top: 16, bottom: 0, right: 16),
                    child: Text(
                      Strings.accountPreferencesGender,
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          .copyWith(color: myOnBackgroundColor),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding:
                      EdgeInsets.only(left: 16, top: 16, bottom: 0, right: 16),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    items: <String>[
                      Strings.accountPreferencesMale,
                      Strings.accountPreferencesFemale,
                      Strings.accountPreferencesOther
                    ].map((String value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(
                          value.toUpperCase(),
                          style: Theme.of(context)
                              .textTheme
                              .button
                              .copyWith(color: myPrimaryColor),
                        ),
                      );
                    }).toList(),
                    hint: StreamBuilder<String>(
                        initialData: '',
                        stream: editAccountBloc.genderStream,
                        builder: (context, snapshot) {
                          selectedGender = snapshot.data;
                          return Text(
                            selectedGender == ''
                                ? Strings.accountPreferencesSelectGender
                                : selectedGender,
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                .copyWith(color: myOnBackgroundColor),
                          );
                        }),
                    onChanged: (value) {
                      FocusScope.of(context).requestFocus(FocusNode());
                      editAccountBloc.updateSelectedGender(value);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  dynamic countryPicker() {
    // TODO(Marius): Build Platform specific country picker.
    if (Platform.isIOS) {
      return showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) {
            return CountryPickerCupertino(
              textStyle: TextStyle(color: Colors.black),
              backgroundColor: myBackgroundColor,
              itemBuilder: _buildCupertinoItem,
              pickerItemHeight: 50.0,
              pickerSheetHeight: 300.0,
              initialCountry: _selectedCupertinoCountry,
              onValuePicked: (Country country) {
                setState(() => userLocation.text = country.name);
              },
            );
          });
    } else {
      return showDialog(
        context: context,
        builder: (context) {
          return CountryPickerDialog(
              titlePadding: EdgeInsets.all(8.0),
              title: Text(
                Strings.accountPreferencesSelectCountry,
                style: Theme.of(context)
                    .textTheme
                    .subtitle2
                    .copyWith(color: myOnBackgroundColor),
              ),
              onValuePicked: (Country country) =>
                  setState(() => userLocation.text = country.name),
              itemBuilder: _buildDialogItem);
        },
      );
    }
  }

  Widget _buildCupertinoItem(Country country) {
    return DefaultTextStyle(
      style: const TextStyle(
        color: CupertinoColors.white,
        fontSize: 16.0,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 40,
          child: Row(
            children: <Widget>[
              SizedBox(width: 8.0),
              CountryPickerUtils.getDefaultFlagImage(country),
              SizedBox(width: 8.0),
              Flexible(
                child: Text(
                  country.name,
                  style: Theme.of(context).textTheme.headline3.copyWith(
                      color: myOnBackgroundColor, fontWeight: FontWeight.w600),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDialogItem(Country country) => Container(
        height: 40,
        child: Row(
          children: <Widget>[
            CountryPickerUtils.getDefaultFlagImage(country),
            SizedBox(width: 8.0),
            Flexible(
              child: Text(
                country.name.toUpperCase(),
                style: Theme.of(context).textTheme.headline3.copyWith(
                    color: myOnBackgroundColor, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      );
}

class MySharingOptionsTile extends StatelessWidget {
  const MySharingOptionsTile({this.mySharingOptionsTileField});

  final String mySharingOptionsTileField;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 95,
      margin: EdgeInsets.only(left: 32, right: 32),
      padding: EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1, color: mySurfaceColor),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          MySwitch(),
          Text(
            '$mySharingOptionsTileField',
            style: Theme.of(context)
                .textTheme
                .bodyText2
                .copyWith(color: myOnBackgroundColor),
          ),
        ],
      ),
    );
  }
}

class MyAccountTile extends StatelessWidget {
  const MyAccountTile(this.myAccountTileField, this.controller, this.onTap,
      this.readOnly, this.type);

  final String myAccountTileField;
  final dynamic controller;

//  dynamic enableValue;
  final VoidCallback onTap;
  final bool readOnly;
  final dynamic type;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 95,
      padding: EdgeInsets.only(left: 16, top: 0, right: 16, bottom: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 16, top: 16, bottom: 0, right: 16),
                    child: Text(
                      '$myAccountTileField',
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          .copyWith(color: myOnBackgroundColor),
                    ),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.only(left: 16, top: 16, bottom: 0, right: 16),
                  child: TextFormField(
                    controller: controller,
                    onTap: onTap,
                    readOnly: readOnly,
                    autofocus: false,
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: type == 2
                        ? TextInputType.numberWithOptions(decimal: false)
                        : TextInputType.text,
                    inputFormatters: type == 2
                        ? [WhitelistingTextInputFormatter.digitsOnly]
                        : null,
                    cursorColor: myPrimaryColor,
                    onChanged: (value) {},
                    decoration: InputDecoration(
                      hintText: Strings.accountPreferencesUpdateRequired,
                      hintStyle: Theme.of(context).textTheme.button.copyWith(
                            color: myAccentColor,
                            fontWeight: FontWeight.w700,
                          ),
                      contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 4),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(width: 1, color: mySurfaceColor),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(width: 1.5, color: myOnBackgroundColor),
                      ),
                    ),
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        .copyWith(color: myOnBackgroundColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MySwitch extends StatefulWidget {
  @override
  MySwitchState createState() {
    return MySwitchState();
  }
}

class MySwitchState extends State<MySwitch> {
  bool _isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Switch(
      activeColor: myPrimaryColor,
      inactiveThumbColor: myBackgroundColor,
      activeTrackColor: mySurfaceColor,
      inactiveTrackColor: mySurfaceColor,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      onChanged: (val) => setState(() => _isSwitched = val),
      value: _isSwitched,
    );
  }
}

//legal-stuff-like-privacy-policy-version-what'snew-etc

class LegalList extends StatelessWidget {
  final String _myLinkURL = 'https://byebye.io/privacy-policy';

  dynamic _launchURL(_myLinkURL) async {
    if (await canLaunch(_myLinkURL)) {
      await launch(_myLinkURL);
    } else {
      throw Strings.chatScreenCouldNotLaunch + ' $_myLinkURL';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: ListView(
        children: <Widget>[
          //version
          ExpansionTile(
            title: Text(Strings.legalVersionTile,
                style: Theme.of(context).textTheme.bodyText2),
            children: [
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Text(
                          Platform.isAndroid
                              ? Strings.legalAndroidVersionText
                              : Strings.legalIOSVersionText,
                          style: Theme.of(context).textTheme.headline3),
                    ),
                  ),
                ],
              ),
            ],
          ),
          //licenses
          ExpansionTile(
            title: Text(Strings.legalLicensesTile,
                style: Theme.of(context).textTheme.bodyText2),
            children: [
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Text(Strings.legalLicensesText,
                          style: Theme.of(context).textTheme.headline3),
                    ),
                  ),
                ],
              ),
            ],
          ),
          //privacy policy
          ExpansionTile(
            title: Text(Strings.legalPrivacyTile,
                style: Theme.of(context).textTheme.bodyText2),
            children: [
              Row(
                children: <Widget>[
                  //

                  GestureDetector(
                    onTap: () => _launchURL(_myLinkURL),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Text(Strings.legalPrivacyPolicyText,
                          style: Theme.of(context).textTheme.headline3),
                    ),
                  ),

                  //

                  /*Expanded(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: TextFromAsset(),
                    ),
                  ),*/
                ],
              ),
            ],
          ),
          //copyright
          ExpansionTile(
            title: Text(Strings.legalCopyrightTile,
                style: Theme.of(context).textTheme.bodyText2),
            children: [
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Text(Strings.legalCopyrightText,
                          style: Theme.of(context).textTheme.headline3),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//text-from-assets/txt/

class TextFromAsset extends StatefulWidget {
  @override
  _TextFromAssetState createState() {
    return _TextFromAssetState();
  }
}

class _TextFromAssetState extends State<TextFromAsset> {
  _TextFromAssetState() {
    getTextFromFile().then(
      (val) => setState(
        () {
          _textFromFile = val;
        },
      ),
    );
  }

  String _textFromFile = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        _textFromFile,
        style: Theme.of(context).textTheme.headline3,
        textAlign: TextAlign.left,
      ),
    );
  }

  Future<String> getTextFromFile() async {
    return await rootBundle.loadString('assets/txt/privacy.txt');
  }
}
