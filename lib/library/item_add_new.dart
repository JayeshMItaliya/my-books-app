import 'dart:io';

import 'package:byebye_flutter_app/bloc/add_book_bloc.dart';
import 'package:byebye_flutter_app/bloc/book_bloc.dart';
import 'package:byebye_flutter_app/bloc/genre_bloc.dart';
import 'package:byebye_flutter_app/common_widgets/platform_alert_dialog.dart';
import 'package:byebye_flutter_app/constants/constants.dart';
import 'package:byebye_flutter_app/constants/strings.dart';
import 'package:byebye_flutter_app/library/category_add_new.dart';
import 'package:byebye_flutter_app/library/item_story.dart';
import 'package:byebye_flutter_app/my_constants/design_system.dart';
import 'package:byebye_flutter_app/network_helper/create_book_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../my_constants/design_system.dart';

class MyNewItem extends StatefulWidget {
  const MyNewItem(
      {Key key, this.itemType, this.editType, this.bookDetails, this.genreName})
      : super(key: key);
  final dynamic itemType;
  final dynamic editType;
  final dynamic bookDetails;
  final dynamic genreName;

  @override
  _MyNewItemState createState() => _MyNewItemState();
}

class _MyNewItemState extends State<MyNewItem> {
  double screenWidth;
  double screenHeight;
  List<String> genreItems = [];
  dynamic selectedGenre = '';
  bool _volumeSwitch = false;
  bool _purchaseSwitch = false;
  bool _bookPhotoSwitch = false;
  bool _sellerLinkSwitch = false;
  bool _descriptionSwitch = false;
  bool imageSelected = false;
  bool isImageEdited = false;
  dynamic compressedImage = '';
  final newBookName = TextEditingController();
  final genreOfBook = TextEditingController();
  final priceOfBook = TextEditingController();
  final volumesOfBook = TextEditingController();
  final purchaseDateOfBook = TextEditingController();
  final sellerLinkOfBook = TextEditingController();
  final descriptionOfBook = TextEditingController();
  String bookStory = '';
  DateTime date = DateTime.now();
  var formatDate = DateFormat('yyyy-MM-dd');
  final _key = GlobalKey<ScaffoldState>();
  final imagePicker = ImagePicker();
  CreateBookHelper createBookHelper = CreateBookHelper();

  @override
  void initState() {
    super.initState();
    getGenreCategory();
    if (widget.genreName == Strings.inventoryCategoryAll) {
      addBookBloc.updateSelectedGenre('');
    } else {
      addBookBloc.updateSelectedGenre(widget.genreName);
    }
    if (widget.itemType == BookCreateType.editBook) {
      if (formatDate
              .format(widget.bookDetails.bookPurchaseDate)
              .compareTo(formatDate.format(date)) ==
          0) {
        _purchaseSwitch = true;
        purchaseDateOfBook.text =
            formatDate.format(widget.bookDetails.bookPurchaseDate);
      } else {
        _purchaseSwitch = true;
        purchaseDateOfBook.text =
            formatDate.format(widget.bookDetails.bookPurchaseDate);
      }
      newBookName.text = widget.bookDetails.bookName;
      priceOfBook.text = widget.bookDetails.bookPrice;
      addBookBloc.updateSelectedGenre(widget.bookDetails.bookGenre);
      volumesOfBook.text = widget.bookDetails.bookVolumes != '1'
          ? widget.bookDetails.bookVolumes
          : '';
      _volumeSwitch = widget.bookDetails.bookVolumes == '1' ? false : true;
      _bookPhotoSwitch = widget.bookDetails.bookPhoto != '' ? true : false;
      imageSelected = widget.bookDetails.bookPhoto != '' ? true : false;
      compressedImage = widget.bookDetails.bookPhoto != ''
          ? widget.bookDetails.bookPhoto
          : '';
      _sellerLinkSwitch = widget.bookDetails.sellerLink != '' ? true : false;
      sellerLinkOfBook.text = widget.bookDetails.sellerLink != ''
          ? widget.bookDetails.sellerLink
          : '';
      _descriptionSwitch =
          widget.bookDetails.descriptionOfBook != '' ? true : false;
      descriptionOfBook.text = widget.bookDetails.descriptionOfBook != ''
          ? widget.bookDetails.descriptionOfBook
          : '';
      bookStory = widget.bookDetails.descriptionOfBook != ''
          ? widget.bookDetails.descriptionOfBook
          : '';
    }
  }

  dynamic getGenreCategory() {
    genreItems = [];
    genreBloc.genreStream.listen((genres) {
      if (genres != null) {
        for (dynamic genre in genres) {
          genreItems.add(genre.genreName);
        }
        genreItems.removeAt(0);
        genreItems.add(Strings.inventoryDropDownAddNewCategory);
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height + 200;
    print(screenHeight);
    MyFirstTheme().theme;

    return Scaffold(
      key: _key,
      appBar: myNewItemAppBar(),
      body: GestureDetector(
        onTap: () {
          final FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        onPanDown: (_) {
          final FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: ListView(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyNewItemTile(Strings.inventoryNewItem, newBookName, 1),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  flex: 7,
                  child: myGenreDropdown(),
                ),
                Flexible(
                  flex: 4,
                  child:
                      MyNewItemTile(Strings.inventoryItemPrice, priceOfBook, 2),
                ),
              ],
            ),

            // SWITCHES

            volumeSwitch(),
            releaseDateSwitch(),
            bookPhotoSwitch(),
            sellerLinkSwitch(),
            descriptionSwitch(),
            SizedBox(height: 24),

            Container(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: finishAddingBookButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget myNewItemAppBar() {
    return AppBar(
      elevation: 0,
      centerTitle: false,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: myOnPrimaryColor),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      titleSpacing: 0.0,
      title: Text(
        Strings.inventoryNewItemAppBar,
        style: Theme.of(context)
            .textTheme
            .subtitle2
            .copyWith(color: myOnPrimaryColor),
      ),
    );
  }

  Widget myGenreDropdown() {
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
                      Strings.inventoryNewItemCategoryField,
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
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<dynamic>(
                      isExpanded: true,
                      items: genreItems.map((dynamic value) {
                        return DropdownMenuItem<dynamic>(
                          value: value,
                          child: Text(
                            value.toString().toUpperCase(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: Theme.of(context)
                                .textTheme
                                .button
                                .copyWith(color: myPrimaryColor),
                          ),
                        );
                      }).toList(),
                      hint: StreamBuilder<dynamic>(
                          initialData: '',
                          stream: addBookBloc.genreStream,
                          builder: (context, snapshot) {
                            selectedGenre = snapshot.data;
                            return Text(
                              snapshot.data == ''
                                  ? Strings.inventoryNewItemCategoryDropDown
                                  : snapshot.data,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(color: myPrimaryColor),
                            );
                          }),
                      onChanged: (value) {
                        if (value == Strings.inventoryDropDownAddNewCategory) {
                          //line 121
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  MyNewCategory(),
                            ),
                          );
                        }
                        addBookBloc.updateSelectedGenre(value);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget volumeSwitch() {
    return Container(
      height: 70,
      margin: EdgeInsets.only(left: 24, right: 24),
      padding: EdgeInsets.only(left: 0, top: 20, right: 0, bottom: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Strings.inventoryNewItemSingle,
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(color: myOnBackgroundColor),
                ),
                Switch(
                  activeColor: myAccentColor,
                  inactiveThumbColor: myBackgroundColor,
                  activeTrackColor: mySurfaceColor,
                  inactiveTrackColor: mySurfaceColor,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onChanged: (val) {
                    setState(() {
                      return _volumeSwitch = val;
                    });
                  },
                  value: _volumeSwitch,
                ),
              ],
            ),
          ),
          Flexible(
            flex: 2,
            child: _volumeSwitch
                ? TextFormField(
                    controller: volumesOfBook,
                    cursorColor: myPrimaryColor,
                    autofocus: false,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: false),
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: Strings.inventoryNewItemGroupedHint,
                      hintStyle: Theme.of(context).textTheme.caption,
                      contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 4),
                      /* enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(width: 1, color: mySurfaceColor),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(width: 1.5, color: myOnBackgroundColor),
                      ),*/
                    ),
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        .copyWith(color: myPrimaryColor),
                  )
                : Text(
                    Strings.inventoryNewItemGroupedSwitcherOn,
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        .copyWith(color: myOnBackgroundColor),
                  ),
          ),
        ],
      ),
    );
  }

  Widget releaseDateSwitch() {
    return Container(
      height: 70,
      margin: EdgeInsets.only(left: 24, right: 24),
      padding: EdgeInsets.only(left: 0, top: 20, right: 0, bottom: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Strings.inventoryNewItemDateSwitcherOff,
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(color: myOnBackgroundColor),
                ),
                Switch(
                  activeColor: myAccentColor,
                  inactiveThumbColor: myBackgroundColor,
                  activeTrackColor: mySurfaceColor,
                  inactiveTrackColor: mySurfaceColor,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onChanged: (val) {
                    setState(() {
                      return _purchaseSwitch = val;
                    });
                  },
                  value: _purchaseSwitch,
                ),
              ],
            ),
          ),
          Flexible(
            flex: 2,
            child: _purchaseSwitch
                ? TextFormField(
                    controller: purchaseDateOfBook,
                    cursorColor: myPrimaryColor,
                    autofocus: false,
                    readOnly: true,
                    onTap: () {
                      _buildDatePicker(context);
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: Strings.inventoryNewItemDateSwitcherOnHint,
                      hintStyle: Theme.of(context)
                          .textTheme
                          .caption
                          .copyWith(color: myPrimaryColor),
                      contentPadding: EdgeInsets.fromLTRB(0, 12, 0, 0),
                      isDense: false,
                      /*focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(width: 1.5, color: myOnBackgroundColor),
                      ),*/
                      suffixIcon: IconButton(
                          icon:
                              Icon(Icons.remove_circle, size: 24, color: myAccentColor),
                          onPressed: () {
                            purchaseDateOfBook.clear();
                          }),
                    ),
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        .copyWith(color: myPrimaryColor),
                  )
                : Text(
                    Strings.inventoryNewItemDateCalendarPicker,
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        .copyWith(color: myOnBackgroundColor),
                  ),
          ),
        ],
      ),
    );
  }

  Widget bookPhotoSwitch() {
    return Container(
      height: 70,
      margin: EdgeInsets.only(left: 24, right: 24),
      padding: EdgeInsets.only(left: 0, top: 20, right: 0, bottom: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Strings.inventoryNewItemPhotoSwitcherOff,
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(color: myOnBackgroundColor),
                ),
                Switch(
                  activeColor: myAccentColor,
                  inactiveThumbColor: myBackgroundColor,
                  activeTrackColor: mySurfaceColor,
                  inactiveTrackColor: mySurfaceColor,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onChanged: (val) {
                    setState(() {
                      return _bookPhotoSwitch = val;
                    });
                  },
                  value: _bookPhotoSwitch,
                ),
              ],
            ),
          ),
          Flexible(
            flex: 2,
            child: Row(
              children: <Widget>[
                Text(
                  Strings.inventoryNewItemPhotoSwitcherOn,
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(color: myOnBackgroundColor),
                ),
                IconButton(
                    icon: Icon(
                      Icons.photo,
                      color: _bookPhotoSwitch
                          ? myOnBackgroundColor
                          : mySurfaceColor,
                    ),
                    onPressed: _bookPhotoSwitch
                        ? () {
                            chooseSourceOfPhoto(context);
                          }
                        : () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget sellerLinkSwitch() {
    return Container(
      height: 70,
      margin: EdgeInsets.only(left: 24, right: 24),
      padding: EdgeInsets.only(left: 0, top: 20, right: 0, bottom: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Strings.inventoryNewItemLinkSwitcherOff,
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(color: myOnBackgroundColor),
                ),
                Switch(
                  activeColor: myAccentColor,
                  inactiveThumbColor: myBackgroundColor,
                  activeTrackColor: mySurfaceColor,
                  inactiveTrackColor: mySurfaceColor,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onChanged: (val) {
                    setState(() {
                      return _sellerLinkSwitch = val;
                    });
                  },
                  value: _sellerLinkSwitch,
                ),
              ],
            ),
          ),
          Flexible(
            flex: 2,
            child: Row(
              children: <Widget>[
                Text(
                  Strings.inventoryNewItemLinkSwitcherOn,
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(color: myOnBackgroundColor),
                ),
                IconButton(
                    icon: Icon(
                      Icons.insert_link,
                      color: _sellerLinkSwitch
                          ? myOnBackgroundColor
                          : mySurfaceColor,
                    ),
                    onPressed: _sellerLinkSwitch
                        ? () {
                            attachSellerLink();
                          }
                        : () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget descriptionSwitch() {
    return Container(
      height: 70,
      margin: EdgeInsets.only(left: 24, right: 24),
      padding: EdgeInsets.only(left: 0, top: 20, right: 0, bottom: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Strings.inventoryNewItemDescriptionSwitcherOff,
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(color: myOnBackgroundColor),
                ),
                Switch(
                  activeColor: myAccentColor,
                  inactiveThumbColor: myBackgroundColor,
                  activeTrackColor: mySurfaceColor,
                  inactiveTrackColor: mySurfaceColor,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onChanged: (val) {
                    setState(() {
                      return _descriptionSwitch = val;
                    });
                  },
                  value: _descriptionSwitch,
                ),
              ],
            ),
          ),
          Flexible(
            flex: 2,
            child: Row(
              children: <Widget>[
                Text(
                  Strings.inventoryNewItemDescriptionSwitcherOn,
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(color: myOnBackgroundColor),
                ),
                IconButton(
                    icon: Icon(
                      Icons.info_outline,
                      color: _descriptionSwitch
                          ? myOnBackgroundColor
                          : mySurfaceColor,
                    ),
                    onPressed: _descriptionSwitch
                        ? () async {
                            final description = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => MyBookStory(
                                  itemType: BookCreateType.editBook,
                                  bookStory:
                                      widget.itemType == BookCreateType.editBook
                                          ? widget.bookDetails.descriptionOfBook
                                          : widget.itemType !=
                                                  BookCreateType.editBook
                                              ? bookStory
                                              : '',
                                ),
                              ),
                            );
                            setState(() {
                              bookStory = description;
                            });
                          }
                        : () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget finishAddingBookButton() {
    return MaterialButton(
      child: Text(
        Strings.inventoryNewItemButton,
        style: Theme.of(context)
            .textTheme
            .button
            .copyWith(color: myOnPrimaryColor),
      ),
      color: myPrimaryColor,
      height: 60,
      minWidth: 220,
      elevation: 0,
      onPressed: () {
        finishAddingThisBook();
      },
    );
  }

  dynamic _buildDatePicker(BuildContext context) async {
    if (Platform.isIOS) {
      showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 250.0,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              maximumDate: DateTime.now(),
              initialDateTime: widget.itemType == BookCreateType.editBook
                  ? widget.bookDetails.bookPurchaseDate
                  : date,
              onDateTimeChanged: (DateTime newDateTime) {
                setState(() {
                  date = newDateTime;
                  purchaseDateOfBook.text = formatDate.format(newDateTime);
                });
              },
            ),
          );
        },
      );
    } else {
      final DateTime picked = await showDatePicker(
        context: context,
        initialDate: widget.itemType == BookCreateType.editBook
            ? widget.bookDetails.bookPurchaseDate
            : date,
        locale: const Locale('en', 'GB'),
        firstDate: DateTime(2000),
        lastDate: DateTime.now(),
      );
      if (picked != null && picked != date)
        setState(() {
          date = picked;
          purchaseDateOfBook.text = formatDate.format(picked);
        });
    }
  }

  dynamic chooseSourceOfPhoto(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 72,
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
      if (widget.itemType == BookCreateType.editBook) {
        isImageEdited = true;
      }
      compressedImage =
          await addBookBloc.compressImage(cameraImage, screenHeight.toInt());
      final uploadImageSizeInMb = compressedImage.lengthSync() / 1000000;
      if (uploadImageSizeInMb > 5.0) {
        PlatformAlertDialog(
          title: Strings.fileSize,
          content: Strings.fileSizeError,
          defaultActionText: Strings.cancel,
        ).show(context);
      } else {
        setState(() {
          imageSelected = true;
        });
      }
    }
  }

  dynamic _galleryPicker() async {
    final pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
    final File galleryImage = File(pickedFile.path);
    if (galleryImage != null) {
      if (widget.itemType == BookCreateType.editBook) {
        isImageEdited = true;
      }
      compressedImage =
          await addBookBloc.compressImage(galleryImage, screenHeight.toInt());
      final uploadImageSizeInMb = compressedImage.lengthSync() / 1000000;
      if (uploadImageSizeInMb > 5.0) {
        PlatformAlertDialog(
          title: Strings.fileSize,
          content: Strings.fileSizeError,
          defaultActionText: Strings.cancel,
        ).show(context);
      } else {
        setState(() {
          imageSelected = true;
        });
      }
    }
  }

  Future<dynamic> attachSellerLink() {
    return showDialog<dynamic>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          child: Container(
            color: myBackgroundColor,
            height: 160,
            width: 500,
            padding:
                const EdgeInsets.only(top: 0, bottom: 10, left: 0, right: 0),
            child: Column(
              children: <Widget>[
                Container(
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0),
                        child: Text(
                          Strings.inventoryNewItemLinkDialog,
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              .copyWith(color: myOnBackgroundColor),
                        ),
                      ),
                      IconButton(
                          icon: Icon(
                            Icons.close,
                            color: myOnBackgroundColor,
                            size: 20,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                    ],
                  ),
                ),
                Container(
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: MySellerLinkTextField(sellerLinkOfBook),
                  ),
                ),
                Container(
                  height: 50,
                  child: sellerLinkButton(),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget sellerLinkButton() {
    return MaterialButton(
      child: Text(
        Strings.buttonSave,
        style: Theme.of(context)
            .textTheme
            .button
            .copyWith(color: myOnPrimaryColor),
      ),
      color: myAccentColor,
      height: 50,
      minWidth: 286,
      onPressed: () {
        final FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
        Navigator.of(context).pop();
      },
    );
  }

  dynamic validateFields() async {
    if (newBookName.text == null || newBookName.text == '') {
      return PlatformAlertDialog(
        title: Strings.bookName,
        content: Strings.bookNameError,
        defaultActionText: Strings.cancel,
      ).show(context);
    } else if (selectedGenre.isEmpty) {
      return PlatformAlertDialog(
        title: Strings.bookGenre,
        content: Strings.bookGenreError,
        defaultActionText: Strings.cancel,
      ).show(context);
    } else if (priceOfBook.text == null || priceOfBook.text == '') {
      priceOfBook.text = '0';
    } else if ((volumesOfBook.text == null || volumesOfBook.text == '') &&
        _volumeSwitch) {
      return PlatformAlertDialog(
        title: Strings.bookVolume,
        content: Strings.bookVolumeError,
        defaultActionText: Strings.cancel,
      ).show(context);
    } else if ((purchaseDateOfBook.text == null ||
            purchaseDateOfBook.text == '') &&
        _purchaseSwitch) {
      return PlatformAlertDialog(
        title: Strings.bookPurchaseDate,
        content: Strings.bookPurchaseDateError,
        defaultActionText: Strings.cancel,
      ).show(context);
    } else if (imageSelected == false && _bookPhotoSwitch) {
      return PlatformAlertDialog(
        title: Strings.bookPhoto,
        content: Strings.bookPhotoError,
        defaultActionText: Strings.cancel,
      ).show(context);
    } else if ((sellerLinkOfBook.text == null || sellerLinkOfBook.text == '') &&
        _sellerLinkSwitch) {
      return PlatformAlertDialog(
        title: Strings.bookSellerLink,
        content: Strings.bookSellerLinkError,
        defaultActionText: Strings.cancel,
      ).show(context);
    } else if ((bookStory == null || bookStory == '') && _descriptionSwitch) {
      return PlatformAlertDialog(
        title: Strings.bookDescription,
        content: Strings.bookDescriptionError,
        defaultActionText: Strings.cancel,
      ).show(context);
    } else {
      Loader().showLoader(context);
      createBookHelper.bookName = newBookName.text;
      createBookHelper.bookGenre = selectedGenre;
      createBookHelper.bookPrice = priceOfBook.text;
      createBookHelper.bookVolumes =
          volumesOfBook.text.isEmpty ? '1' : volumesOfBook.text;
      createBookHelper.bookPurchaseDate = purchaseDateOfBook.text.isEmpty
          ? date
          : DateTime.parse(purchaseDateOfBook.text);
      if (widget.itemType == BookCreateType.editBook &&
          _bookPhotoSwitch == false) {
        createBookHelper.bookPhoto = '';
      } else {
        createBookHelper.bookPhoto =
            compressedImage == '' ? '' : compressedImage;
      }
      createBookHelper.sellerLink =
          sellerLinkOfBook.text.isEmpty ? '' : sellerLinkOfBook.text;
      createBookHelper.descriptionOfBook = bookStory.isEmpty ? '' : bookStory;

      if (widget.itemType == BookCreateType.editBook) {
        final editResult = await bookBloc.editBook(
            widget.bookDetails.bookId, createBookHelper, isImageEdited);
        Loader().hideLoader(context);
        if (editResult[1] != null) {
          PlatformAlertDialog(
            title: Strings.network,
            content: Strings.networkError,
            defaultActionText: Strings.cancel,
          ).show(context);
        } else {
          _key.currentState.showSnackBar(
            SnackBar(
              backgroundColor: myAccentColor,
              content: Text(
                Strings.inventoryNewItemEditedSnack,
                style: Theme.of(context)
                    .textTheme
                    .button
                    .copyWith(color: myBackgroundColor),
              ),
              duration: Duration(seconds: 1),
            ),
          );
          Future.delayed(Duration(seconds: 2)).then((_) {
            if (widget.editType == BookEditType.fromBookDetail) {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            } else {
              Navigator.of(context).pop();
            }
          });
        }
      } else {
        final result = await addBookBloc.createBook(createBookHelper);
        Loader().hideLoader(context);
        if (result[0]) {
          _key.currentState.showSnackBar(
            SnackBar(
              backgroundColor: myAccentColor,
              content: Text(
                Strings.inventoryNewItemCreatedSnack,
                style: Theme.of(context)
                    .textTheme
                    .button
                    .copyWith(color: myOnPrimaryColor),
              ),
              duration: Duration(seconds: 1),
            ),
          );
          Future.delayed(Duration(seconds: 2)).then((_) {
            Navigator.of(context).pop();
          });
        } else {
          if (result[1] != null) {
            PlatformAlertDialog(
              title: Strings.network,
              content: Strings.networkError,
              defaultActionText: Strings.cancel,
            ).show(context);
          } else {
            PlatformAlertDialog(
              title: Strings.bookMatch,
              content: Strings.bookMatchError,
              defaultActionText: Strings.cancel,
            ).show(context);
          }
        }
      }
    }
  }

  dynamic finishAddingThisBook() async {
    await validateFields();
  }
}

class MySellerLinkTextField extends StatelessWidget {
  const MySellerLinkTextField(this.controller);

  final dynamic controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: false,
      cursorColor: myAccentColor,
      controller: controller,
      maxLines: 1,
      style:
          Theme.of(context).textTheme.headline5.copyWith(color: myPrimaryColor),
      decoration: InputDecoration(
        focusColor: myAccentColor,
        border: InputBorder.none,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 24.0, horizontal: 24),
        hintStyle: Theme.of(context)
            .textTheme
            .subtitle2
            .copyWith(color: myAccentColor),
      ),
    );
  }
}

class MyNewItemTile extends StatelessWidget {
  const MyNewItemTile(this.myNewItemTileField, this.controller, this.type);

  final String myNewItemTileField;
  final dynamic controller;
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
                      '$myNewItemTileField',
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
                    autofocus: false,
                    controller: controller,
                    cursorColor: myAccentColor,
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: type == 2
                        ? TextInputType.numberWithOptions(decimal: false)
                        : TextInputType.text,
                    inputFormatters: type == 2
                        ? [WhitelistingTextInputFormatter.digitsOnly]
                        : null,
                    decoration: InputDecoration(
                      hintText: type == 1
                          ? Strings.inventoryNewItemNameFieldHint
                          : Strings.inventoryNewItemPriceFieldHint,
                      hintStyle: Theme.of(context)
                          .textTheme
                          .subtitle2
                          .copyWith(color: myAccentColor),
                      contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 4),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(width: 1, color: mySurfaceColor),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(width: 1.5, color: myOnBackgroundColor),
                      ),
                    ),
                    style: Theme.of(context).textTheme.headline5.copyWith(
                        color: controller.text == '0'
                            ? myAccentColor
                            : myPrimaryColor),
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
