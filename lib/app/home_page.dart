import 'package:byebye_flutter_app/app/drawer.dart';
import 'package:byebye_flutter_app/app/version_check.dart';
import 'package:byebye_flutter_app/booklovers/people_list.dart';
import 'package:byebye_flutter_app/constants/strings.dart';
import 'package:byebye_flutter_app/library/category_list.dart';
import 'package:byebye_flutter_app/my_constants/design_system.dart';
import 'package:byebye_flutter_app/app/getting_started.dart';
import 'package:byebye_flutter_app/stats/stats.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import '../my_constants/design_system.dart';
import 'drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Firestore _firestore = Firestore.instance;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    // addField();
    // removeDemoEntry();
    addTotalBooksVolumeOneTime();
    try {
      versionCheck(context);
    } catch (e) {
      print(e);
    }
    super.initState();
  }

  Future<void> addTotalBooksVolumeOneTime() async {
    int totalBookVolume = 0;
    int totalBookPrice = 0;
    final int totalBooksVolume = prefsObject.getInt('totalBooksVolume');
    final int totalBooksPrice = prefsObject.getInt('totalBooksPrice');
    if (totalBooksVolume == null) {
      _firestore
          .collection('library')
          .where('uid', isEqualTo: prefsObject.getString('uid'))
          .getDocuments()
          .then((onValue) {
        for (DocumentSnapshot library in onValue.documents) {
          if (library['uid'] == prefsObject.getString('uid')) {
            final int bookVolume = int.parse(library['bookVolumes']);
            totalBookVolume = totalBookVolume + bookVolume;
          }
          _firestore
              .collection('users')
              .document(prefsObject.getString('uid'))
              .updateData({'totalBooksVolume': totalBookVolume});
          prefsObject.setInt('totalBooksVolume', totalBookVolume);
        }
      });
    }
    if (totalBooksPrice == null) {
      _firestore
          .collection('library')
          .where('uid', isEqualTo: prefsObject.getString('uid'))
          .getDocuments()
          .then((onValue) {
        for (DocumentSnapshot library in onValue.documents) {
          if (library['uid'] == prefsObject.getString('uid')) {
            final int bookPrice = int.parse(library['bookPrice']);
            totalBookPrice = totalBookPrice + bookPrice;
          }
          _firestore
              .collection('users')
              .document(prefsObject.getString('uid'))
              .updateData({'totalBooksPrice': totalBookPrice});
          prefsObject.setInt('totalBooksPrice', totalBookPrice);
        }
      });
    }
  }

  // TODO(Marius): Dont update and uncomment this Function because this function runs the batch update in live DB

  // Future addField() async {
  //   Firestore.instance.collection('users').getDocuments().then((users) async {
  //     if (users.documents.isNotEmpty) {
  //       for (DocumentSnapshot user in users.documents) {
  //         int bookVolume = 0;
  //         int bookPrice = 0;
  //         _firestore
  //             .collection('library')
  //             .where('uid', isEqualTo: user.documentID)
  //             .getDocuments()
  //             .then((onValue) {
  //           for (DocumentSnapshot book in onValue.documents) {
  //             final int bookVol = int.parse(book['bookVolumes']);
  //             final int bookPri = int.parse(book['bookPrice']);
  //             bookVolume = bookVolume + bookVol;
  //             bookPrice = bookPrice + bookPri;
  //           }
  //         }).then((_) async {
  //           final Map<String, int> totalBooksData = {
  //             'totalBooksVolume': bookVolume,
  //             'totalBooksPrice': bookPrice
  //           };
  //           final WriteBatch _batch = Firestore.instance.batch();
  //           _batch.updateData(
  //               _firestore.collection('users').document(user.documentID),
  //               totalBooksData);
  //           await _batch.commit();
  //         });
  //       }
  //     }
  //   });
  // }

  //Remove Demo entry from all users genre and library table

  // Future removeDemoEntry() async {
  //   Firestore.instance.collection('users').getDocuments().then((users) async {
  //     if (users.documents.isNotEmpty) {
  //       for (DocumentSnapshot user in users.documents) {
  //         _firestore.collection('genres').getDocuments().then((onValue) {
  //           for (DocumentSnapshot genre in onValue.documents) {
  //             if (user.documentID == genre['uid']) {
  //               if (genre['genreName'] == 'DEMO CATEGORY #1' ||
  //                   genre['genreName'] == 'DEMO CATEGORY #2') {
  //                 _firestore
  //                     .collection('genres')
  //                     .document(genre.documentID)
  //                     .delete();
  //               }
  //             }
  //           }
  //         });

  //         _firestore.collection('library').getDocuments().then((onValue) {
  //           for (DocumentSnapshot library in onValue.documents) {
  //             if (user.documentID == library['uid']) {
  //               if (library['bookGenre'] == 'DEMO CATEGORY #1' ||
  //                   library['bookGenre'] == 'DEMO CATEGORY #2') {
  //                 _firestore
  //                     .collection('library')
  //                     .document(library.documentID)
  //                     .delete();
  //               }
  //             }
  //           }
  //         });
  //       }
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: false,
        title: Text(Strings.homePage,
            style: Theme.of(context)
                .textTheme
                .subtitle2
                .copyWith(color: myOnPrimaryColor)),
        titleSpacing: 0.0,
        iconTheme: IconThemeData(color: myOnPrimaryColor),
      ),
      drawer: SideDrawer(),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height - 176,
                child: GestureDetector(
                  onTap: () {},
                  child: Container(child: AdBoxPhoto()),
                ),
              ),
            ),
            Container(
              height: 120,
              child: ListView(
                key: PageStorageKey('walkThroughKey'),
                scrollDirection: Axis.horizontal,
                children: [
                  MyWalkThroughCards1(
                      iconIndex: 0,
                      mwtcTitle: Strings.homeTileTitle1,
                      mwtcSubtitle: Strings.homeTileSubtitle1,
                      mwtcDescription: Strings.homeTileBody1),
                  MyWalkThroughCards1(
                      iconIndex: 1,
                      mwtcTitle: Strings.homeTileTitle2,
                      mwtcSubtitle: Strings.homeTileSubtitle2,
                      mwtcDescription: Strings.homeTileBody2),
                  MyWalkThroughCards1(
                      iconIndex: 2,
                      mwtcTitle: Strings.homeTileTitle3,
                      mwtcSubtitle: Strings.homeTileSubtitle3,
                      mwtcDescription: Strings.homeTileBody3),
                  MyWalkThroughCards1(
                      iconIndex: 3,
                      mwtcTitle: Strings.homeTileTitle4,
                      mwtcSubtitle: Strings.homeTileSubtitle4,
                      mwtcDescription: Strings.homeTileBody4),
                  MyWalkThroughCards1(
                      iconIndex: 4,
                      mwtcTitle: Strings.homeTileTitle5,
                      mwtcSubtitle: Strings.homeTileSubtitle5,
                      mwtcDescription: Strings.homeTileBody5),
                  MyWalkThroughCards1(
                      iconIndex: 5,
                      mwtcTitle: Strings.homeTileTitle6,
                      mwtcSubtitle: Strings.homeTileSubtitle6,
                      mwtcDescription: Strings.homeTileBody6),
                  MyWalkThroughCards1(
                      iconIndex: 6,
                      mwtcTitle: Strings.homeTileTitle7,
                      mwtcSubtitle: Strings.homeTileSubtitle7,
                      mwtcDescription: Strings.homeTileBody7),
                  /*MyNewsFeedMediaCard(),*/
                  /*MyNewsFeedUserCard(),*/
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//Marius added code starting here

class MyNewsFeedUserCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                width: 280,
                height: 60,
                color: myBackgroundColor,
                padding: EdgeInsets.fromLTRB(96, 12, 4, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 0),
                      child: Text(
                        'Charlie Xiu',
                        style: Theme.of(context)
                            .textTheme
                            .headline4
                            .copyWith(color: myPrimaryColor),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(
                        'May, 07',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(color: myOnSurfaceColor),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 280,
                height: 60,
                color: myOnBackgroundColor,
                padding: EdgeInsets.fromLTRB(96, 12, 6, 0),
                child: Text(
                  'Added another title to the Mystery collection. Find out more!',
                  maxLines: 2,
                  style: Theme.of(context)
                      .textTheme
                      .headline3
                      .copyWith(color: myBackgroundColor),
                ),
              ),
            ],
          ),

          // avatar radius64 start
          Container(
            padding: EdgeInsets.fromLTRB(16, 28, 0, 23),
            child: Container(
              height: 64,
              width: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/user.png'),
                ),
              ),
            ),
          ),
          // avatar radius64 end
        ],
      ),
    );
  }
}

class MyNewsFeedMediaCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                width: 280,
                height: 60,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/newsfeed1.jpeg'),
                  ),
                ),
              ),
              Container(
                width: 280,
                height: 60,
                color: mySurfaceColor,
                padding: EdgeInsets.fromLTRB(96, 12, 6, 0),
                child: Text('Tips and tricks to keep the books as new!',
                    maxLines: 2,
                    style: Theme.of(context)
                        .textTheme
                        .headline3
                        .copyWith(color: myOnBackgroundColor)),
              ),
            ],
          ),

          // avatar radius64 start
          Container(
            padding: EdgeInsets.fromLTRB(16, 28, 0, 18),
            child: Container(
              height: 64,
              width: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/vimeo-logo.png'),
                ),
              ),
            ),
          ),
          // avatar radius64 end
        ],
      ),
    );
  }
}

class AdBoxPhoto extends StatelessWidget {
  static String unsplashUrl = 'https://source.unsplash.com/collection/9697343/';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GettingStarted(),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,

            // info at https://source.unsplash.com/

            image: NetworkImage(unsplashUrl +
                'toString(oX)'
                    'x'
                    'toString(oY)'),
          ),
        ),
      ),
    );
  }
}

class MyWalkThroughCards1 extends StatelessWidget {
  MyWalkThroughCards1(
      {this.iconIndex,
      this.mwtcTitle,
      this.mwtcSubtitle,
      this.mwtcDescription});

  final String mwtcTitle;
  final String mwtcSubtitle;
  final String mwtcDescription;

  final int iconIndex;

  final List<Icon> icons = [
    Icon(Icons.arrow_forward, color: myBackgroundColor),
    Icon(Icons.add, color: myBackgroundColor),
    Icon(Icons.people, color: myBackgroundColor),
    Icon(Icons.show_chart, color: myBackgroundColor),
    Icon(Icons.build, color: myBackgroundColor),
    Icon(Icons.title, color: myBackgroundColor),
    Icon(Icons.share, color: myBackgroundColor),
  ];

  final List<String> _myLinkURL = [
    '',
    '',
    '',
    '',
    'https://www.byebye.io/help',
    'https://www.twitter.com/byebyeapp',
    '',
  ];

  final List<Widget> _myRoute = [
    GettingStarted(),
    MyCategories(), //open the screen to add without an implicit genre selected
    MyPeopleList(),
    MyState(),
    null,
    null,
    null,
  ];

  dynamic _launchURL(_myLinkURL) async {
    if (await canLaunch(_myLinkURL)) {
      await launch(_myLinkURL);
    } else {
      throw 'Could not launch $_myLinkURL';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _myRoute[iconIndex] != null
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => _myRoute[iconIndex],
                ),
              );
            }
          : _myLinkURL[iconIndex] != ''
              ? () => _launchURL(_myLinkURL[iconIndex])
              : () =>
                  Share.share(Strings.shareText, subject: Strings.shareSubject),
      child: Container(
        child: Stack(
          children: [
            //big-box
            Container(
              width: 280,
              height: 120,
              color: myBackgroundColor,
              /*padding: EdgeInsets.fromLTRB(96, 12, 4, 0),*/
            ),

            //small-box
            Container(
              width: 280,
              height: 10,
              color: mySurfaceColor,
              /*padding: EdgeInsets.fromLTRB(96, 12, 4, 0),*/
            ),

            //icon
            Container(
              padding: EdgeInsets.fromLTRB(16, 24, 0, 23),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: myOnBackgroundColor,
                child: icons[iconIndex],
              ),
            ),

            //title
            Container(
              padding: EdgeInsets.fromLTRB(64, 20, 6, 0),
              child: Text(
                mwtcTitle,
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    .copyWith(color: myOnBackgroundColor),
              ),
            ),

            //subtitle2
            Container(
              padding: EdgeInsets.fromLTRB(64, 40, 6, 0),
              child: Text(
                mwtcSubtitle,
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                    color: myOnBackgroundColor, fontWeight: FontWeight.w700),
              ),
            ),

            //paragraph
            Container(
              width: 280,
              padding: EdgeInsets.fromLTRB(64, 70, 6, 0),
              child: Text(
                mwtcDescription,
                maxLines: 2,
                style: Theme.of(context)
                    .textTheme
                    .headline3
                    .copyWith(color: myOnBackgroundColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
