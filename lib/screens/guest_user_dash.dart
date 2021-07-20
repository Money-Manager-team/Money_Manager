import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money_manager/Widgets/guest_menu_widget.dart';

class GuestUserDash extends StatefulWidget {
  @override
  _GuestUserDashState createState() => _GuestUserDashState();
}

class _GuestUserDashState extends State<GuestUserDash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: Text('Money Manager'),
        centerTitle: true,
      ),
      //! using guest_menu_widget
       drawer: GuestMenu(),
      
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 25.0),
                alignment: Alignment.topCenter,
                child: Text(
                  "Dashboard",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Container(
                child:  buildCardDashboard("Welcome to" , "MONEY MANAGER", 330, 150 , Colors.indigo, Colors.lightBlue, Colors.indigo),
              ),
             
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    StreamBuilder(
                      stream: FirebaseFirestore.instance.collection("USERs").doc(FirebaseAuth.instance.currentUser.uid).snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if(!snapshot.hasData)
                        {
                          return CircularProgressIndicator();
                        }
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                          return CircularProgressIndicator();
                            break;
                          default:
                          return buildCardDashboard("${snapshot.data["Expenditure"]} RM" , "Current Total Expense", 330, 150 ,Colors.indigo, Colors.red, Colors.indigo);
                        }
                      }
                    ),
                    StreamBuilder(
                      stream: FirebaseFirestore.instance.collection("USERs").doc(FirebaseAuth.instance.currentUser.uid).snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if(!snapshot.hasData)
                        {
                          return CircularProgressIndicator();
                        }
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                          return CircularProgressIndicator();
                            break;
                          default:
                          return buildCardDashboard("${snapshot.data["Budget"]} RM" , "Budget Limit", 330, 150 ,Colors.indigo, Colors.red, Colors.indigo);
                        }
                      }
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Card buildCardDashboard(first, second,double w,double  h, shadowCol, grad1col, grad2col ) {
    return Card(
      elevation: 10,
      clipBehavior: Clip.antiAlias,
      shadowColor: shadowCol,
      margin: EdgeInsets.all(10.0),
      shape: RoundedRectangleBorder(
       borderRadius: BorderRadius.circular(24),
      ),
     
      child: Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [grad1col, grad2col],
            begin: Alignment.topRight,            
            end: Alignment.bottomCenter,
          ),
           // borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
       
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
              children: [
              
                Text(
                  '  ' + first,
                  style: TextStyle(fontSize: 35, color: Colors.blueGrey[900], fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Text("    " + second, style: TextStyle(fontSize: 20, color: Colors.blueGrey[900], fontWeight: FontWeight.bold))
          ],
        ),
      ),
    );
  }  
}
