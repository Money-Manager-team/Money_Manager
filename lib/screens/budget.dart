import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money_manager/constants.dart';

class BudgetPage extends StatefulWidget {
  @override
  _BudgetPageState createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  //Ints
  int budget = 0;
  int expenditure = 0;

  //Voids
  get_budget() async
  {
    DocumentSnapshot BUDGET = await FirebaseFirestore.instance.collection("USERs").doc(FirebaseAuth.instance.currentUser.uid).get();
    setState(() {
      budget = int.parse(BUDGET["Budget"]);
    });
  }
  get_expenditure() async
  {
    DocumentSnapshot EXPENDITURES = await FirebaseFirestore.instance.collection("USERs").doc(FirebaseAuth.instance.currentUser.uid).get();
    setState(() {
      expenditure = EXPENDITURES["Expenditure"];
    });
  }
  
  @override
  void initState() {
    super.initState();
    get_budget();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   icon: Icon(Icons.menu),
        //   onPressed: (null),
        // ),
        title: Text('Money Manager'),
        centerTitle: true,
      ),
      //drawer: status? GuestMenu() : RegisteredMenu(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ListTile(
                title: Text("Expense Budget",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                    ))),
            ListTile(),
            ListTile(),
            ListTile(
                title: Text("Current Expenditure:",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 23,
                ))),
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection("USERs").doc(FirebaseAuth.instance.currentUser.uid).collection("Expense History").snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if(!snapshot.hasData)
                {
                  return CircularProgressIndicator();
                }
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  return CircularProgressIndicator();
                    break;
                  default:
                  int i2 = 0;
                  for(int i = 0; i < snapshot.data.docs.length; i++)
                  {
                    i2 += int.parse(snapshot.data.docs[i]["Amount"]);
                    expenditure = i2;
                  }
                   return ListTile(
                    title: Text("RM ${expenditure != 0? i2: expenditure}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        )));
                }
              }
            ),
                        RaisedButton(
              color: Colors.red,
                child: Text('Reset', style: TextStyle(color: Colors.white),),
                shape: RoundedRectangleBorder
                (
                  borderRadius: BorderRadius.circular(10)
                ),
                onPressed: () async {
                    expenditure = 0;
                  await FirebaseFirestore.instance.collection("USERs").doc(FirebaseAuth.instance.currentUser.uid).update
                  ({
                    "Expenditure": 0,
                  });
                  await FirebaseFirestore.instance.collection("USERs").doc(FirebaseAuth.instance.currentUser.uid).collection("Expense History").get().then((value)async => 
                  {
                    await FirebaseFirestore.instance.collection("USERs").doc(FirebaseAuth.instance.currentUser.uid).collection("Expense History").get().then((value) => 
                    {
                      value.docs.forEach((element) 
                      {
                        element.reference.delete();
                      })
                    })
                  });
                }),
            ListTile(),
            ListTile(
                title: Text("Budget Limit:",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 23,
                    ))),
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
                    return ListTile(
                    title: Text("RM ${snapshot.data.data().toString().contains("Budget") == true? snapshot.data["Budget"]: 0}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        )));
                }
              }
            ),
            SizedBox
            (height: 30,),
            RaisedButton(
                child: Text('Update Budget Limit', style: TextStyle(color: Colors.white),),
                color: Colors.blue[900],
                shape: RoundedRectangleBorder
                (
                  borderRadius: BorderRadius.circular(10)
                ),
                onPressed: () async {
                  Navigator.pushNamed(
                    context,
                    updateBudgetLimitRoute,
                    // arguments:
                      );
                }),
          ],
        ),
      ),
    );
  }
}
