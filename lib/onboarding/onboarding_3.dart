import 'package:byebye_flutter_app/app/sign_in/sign_in_page.dart';
import 'package:byebye_flutter_app/my_constants/design_system.dart';
import 'package:flutter/material.dart';
import 'package:byebye_flutter_app/constants/strings.dart';
import '../my_constants/design_system.dart';

class Onboarding3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: myBackgroundColor,
        child: OnboardingInstance3(),
      ),
    );
  }
}

class Onboarding2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: myBackgroundColor,
        child: OnboardingInstance3(),
      ),
    );
  }
}

class OnboardingInstance3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            /*SizedBox(height: 20),*/
            Container(
              padding: EdgeInsets.fromLTRB(24, 70, 0, 0),
              child: Text(
                Strings.OnBoarding3Phrase1,
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    .copyWith(fontSize: 24, letterSpacing: -1),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(24, 4, 0, 0),
              /*margin: EdgeInsets.fromLTRB(24, 100, 0, 0),*/
              child: Text(
                Strings.OnBoarding3Phrase2,
                style: Theme.of(context).textTheme.headline2.copyWith(
                    height: 1.4,
                    fontWeight: FontWeight.w600,
                    color: myPrimaryColor),
              ),
            ),
          ],
        ),
        SizedBox(height: 45),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fitHeight,
                  image: AssetImage('assets/o3.png'),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 40),

        //back-next
        Container(
          height: 56,
          color: myOnBackgroundColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                child: Container(
                  height: 56,
                  color: myOnBackgroundColor,
                  margin: EdgeInsets.fromLTRB(32, 0, 0, 0),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Icon(Icons.arrow_back, color: myOnPrimaryColor),
                      ),
                      Text(Strings.OnboardingBack,
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              .copyWith(color: myOnPrimaryColor)),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              GestureDetector(
                child: Container(
                  height: 56,
                  color: myOnBackgroundColor,
                  margin: EdgeInsets.fromLTRB(0, 0, 32, 0),
                  child: Row(
                    children: [
                      Text(Strings.OnboardingGetStarted,
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              .copyWith(color: myOnPrimaryColor)),
                      Container(
                        padding: EdgeInsets.fromLTRB(4, 0, 0, 0),
                        child:
                            Icon(Icons.arrow_forward, color: myOnPrimaryColor),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignInPageBuilder(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
