import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';

class UpdateBudget extends StatefulWidget {

  @override
  _UpdateBudgetState createState() => _UpdateBudgetState();
}

class _UpdateBudgetState extends State<UpdateBudget> {

  //KEYS
  GlobalKey<FormState> KEY = GlobalKey<FormState>();

  //Controllers
  TextEditingController Budget = TextEditingController();

  //Ints
  int budget = 0;
  int expenditure = 0;
  get_expenditure() async
  {
    DocumentSnapshot EXPENDITURES = await FirebaseFirestore.instance.collection("USERs").doc(FirebaseAuth.instance.currentUser.uid).get();
    setState(() {
      expenditure = EXPENDITURES["Expenditure"];
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_expenditure();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(        
        title: Text('Money Manager'),
        centerTitle: true,
      ),
      //drawer: status? GuestMenu() : RegisteredMenu(),
      body: SingleChildScrollView(
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: KEY,
          child: Column(
            children: <Widget>[
              ListTile(
                  title: Text("Update Budget Limit",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                      ))),
              ListTile(),
              ListTile(),
              ListTile(
                  title: Text("Current Budget Limit:",
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
              ListTile(),
              ListTile(
                  title: Text("Enter New Budget Limit:",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 23,
                      ))),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                child: TextFormField(
                  validator: (v)
                  {
                    if(v.trim() == "")
                    {
                      return "Budget is empty";
                    }
                    else if(expenditure >= toInt(v))
                    {
                      return "Budget must be bigger than current expenditure";
                    }
                    else if(isNumeric(v) == false)
                    {
                      return "Budget is not an integer";
                    }
                  },
                  controller: Budget,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(border: OutlineInputBorder(), hintText: 'RM 50.00'),
                  
                ),
              ),
              ElevatedButton(
                  child: Text('Update'),
                  onPressed: () async
                  {

                    if(KEY.currentState.validate()== true)
                    {
                      await FirebaseFirestore.instance.collection("USERs").doc(FirebaseAuth.instance.currentUser.uid).update
                      ({
                        "Budget": Budget.text
                      });
                  }
                }
              )
            ],
          ),
        ),
      ),
    );
  }
}
