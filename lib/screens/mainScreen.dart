import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:money_manager/constants.dart';

class MainScreen extends StatefulWidget {
  static const String idScreen = "mainScreen";

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 40.0,
              ),
              Image(
                image: AssetImage("images/logo.png"),
                width: 350.0,
                height: 250.0,
                alignment: Alignment.center,
              ),
              SizedBox(
                height: 70,
              ),
              Text(
                "Money management made simple!",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Brand Bold",
                ),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 1.0,
                    ),

                    SizedBox(
                      height: 25.0,
                    ),
                    // ignore: deprecated_member_use
                    RaisedButton(
                        color: Colors.greenAccent[700],
                        textColor: Colors.white,
                        child: Container(
                          height: 50.0,
                          child: Center(
                            child: Text(
                              "Login as a Premium User",
                              style: TextStyle(
                                  fontSize: 18.0, fontFamily: "Brand Bold"),
                            ),
                          ),
                        ),
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(23.0),
                        ),
                        onPressed: () async {
                          Navigator.pushNamed(
                            context,
                            premiumLoginRoute,
                            //arguments:
                             
                          );
                        }
                        ),

                    SizedBox(
                      height: 25.0,
                    ),
                    // ignore: deprecated_member_use
                    RaisedButton(
                        color: Colors.greenAccent[700],
                        textColor: Colors.white,
                        child: Container(
                          height: 50.0,
                          child: Center(
                            child: Text(
                              "Use as a Guest",
                              style: TextStyle(
                                  fontSize: 18.0, fontFamily: "Brand Bold"),
                            ),
                          ),
                        ),
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(23.0),
                        ),
                        onPressed: () async {
                          await Firebase.initializeApp();
                          await FirebaseAuth.instance.signInAnonymously();
                          await FirebaseFirestore.instance.collection("USERs").doc(FirebaseAuth.instance.currentUser.uid).set
                          ({
                            "Expenditure": 0,
                            "Budget": 0,
                          });
                          Navigator.pushNamed(
                            context,
                            guestDashRoute,
                            // arguments: 
                          );
                        })
                  ],
                ),
              ),

              SizedBox(
                height: 60.0,
              ),
              Text(
                "Want to unlock all the features?",
                style: TextStyle(
                  fontSize: 17.0,
                  fontFamily: "Brand Bold",
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(
                height: null,
              ),
              // ignore: deprecated_member_use
              FlatButton(
                onPressed: () async{
                  Navigator.pushNamed(
                    context,
                    premiumRegistrationRoute,
                    // arguments: 
                  );
                },
                textColor: Colors.lightGreenAccent[700],
                child: Text(
                  "Register Here.",
                  style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Brand Bold"),
                      textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
