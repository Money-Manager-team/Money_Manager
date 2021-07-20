import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money_manager/screens/premiumUserLogin.dart';
import '../constants.dart';

class RegisteredMenu extends StatefulWidget {
  

  @override
  _RegisteredMenuState createState() => _RegisteredMenuState();
}

class _RegisteredMenuState extends State<RegisteredMenu> {

  //Strings
  String username = "";
  String email = FirebaseAuth.instance.currentUser.email;
  String user = FirebaseAuth.instance.currentUser.uid;

  //voids
  void get_data() async
  {
    DocumentSnapshot get_username = await FirebaseFirestore.instance.collection("USERs").doc(user).get();
    setState(() {
      username = get_username["Name"];
    });
  }
  
  @override
  Widget build(BuildContext context) {
    get_data();
    return Drawer(
        child: Card(
          child: ListView(
            padding: EdgeInsets.all(1),
            children: <Widget>[
              Container(
                height: 200,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 30,
                        child: ListTile(
                          leading: Icon(Icons.person_pin_outlined),
                          title: Row
                          (
                            children: 
                            [
                              Text(username),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                        child: ListTile(
                          leading: Icon(Icons.email_outlined),
                          title: Row
                          (
                            children: 
                            [
                              Expanded(child: Text(email)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: buildListTiledrawer(
                    "Add Expense", Icons.add_circle_outline, context, 1),
              ),
              Card(
                child: buildListTiledrawer(
                    "Add Custom Category", Icons.add_circle, context, 2),
              ),
              Card(
                  child: buildListTiledrawer(
                      "View Expense", Icons.list, context, 3)),
              Card(
                child: buildListTiledrawer(
                    "Budget Limit", Icons.edit_sharp, context, 4),
              ),
              FractionallySizedBox(
                widthFactor: 0.4,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.indigo,
                    onPrimary: Colors.white,
                    onSurface: Colors.grey,
                    shape: const BeveledRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                  ),
                  child: Text('Sign Out'),
                 
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> PremiumUserLogin()));
                  },
                ),
              )
            ],
          ),
        ),
      );
  }

  ListTile buildListTiledrawer(text, icon, BuildContext context, num) {
    return ListTile(
        leading: Icon(icon),
        title: Text(text),
        onTap: () async{
          if (num == 1) {
            Navigator.pushNamed(
              context,
              addExpenseRoute            
            );
          }
          if (num == 2) {
            Navigator.pushNamed(
              context,
              addCategoryRoute,              
            );
          }
          if (num == 3) {
            Navigator.pushNamed(
              context,
              viewExpenseRoute,              
            );
          }
          if (num == 4) {
            Navigator.pushNamed(
              context,
              viewBudgetLimitRoute             
            );
          }
        });
  }
}