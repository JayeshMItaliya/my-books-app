import 'package:byebye_flutter_app/my_constants/design_system.dart';
import 'package:flutter/material.dart';

class FullScreenImage extends StatefulWidget {
  const FullScreenImage({this.photoUrl});

  final String photoUrl;

  @override
  _FullScreenImageState createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          color: myDarkBackgroundColor,
          child: SizedBox.expand(
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Hero(
                    tag: widget.photoUrl,
                    child: Image.network(widget.photoUrl),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      AppBar(
                        centerTitle: false,
                        elevation: 0.0,
                        backgroundColor: Colors.transparent,
                        leading: IconButton(
                          icon: Icon(Icons.close, color: myBackgroundColor),
                          onPressed: () => Navigator.pop(context),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
