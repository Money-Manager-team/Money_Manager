import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money_manager/Widgets/registered_menu_widget.dart';



class CustomExpenseCategory extends StatefulWidget {
  @override
  CustomExpenseCategoryState createState() => CustomExpenseCategoryState();
}

class CustomExpenseCategoryState extends State<CustomExpenseCategory> {

  //KEYS
  GlobalKey<FormState> KEY = GlobalKey<FormState>();

  //Controllers
  TextEditingController Category_field = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: <Widget>[
            Text(
              'Add Custom Category',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
        centerTitle: true,
      ),
      drawer: RegisteredMenu(), 
      body:
          Form(
            key: KEY,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    margin: EdgeInsets.fromLTRB(70.0, 35.0, 5.0, 40.0) ,
                    width: 250,
                    child: TextFormField(
                      validator: (v)
                      {
                        if(v.trim() == "")
                        {
                          return "Category is empty";
                        }
                        else if (v.contains(" ") == true) 
                        {
                          return "Category can't include whitespace"; 
                        }
                      },
                      controller: Category_field,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter Custom Category',
                        hintText: 'Food, laundry,other expenses...',
                      ),
                      autofocus: false,
                    )),

                Container(
                  margin: EdgeInsets.fromLTRB(60.0, 35.0, 5.0, 20.0) ,
                  width: 150,
                  child: FloatingActionButton.extended(
                    onPressed: () async
                    {
                      if(KEY.currentState.validate() == true)
                      {
                        await FirebaseFirestore.instance.collection("USERs").doc(FirebaseAuth.instance.currentUser.uid).collection("Custom Categories").doc().set
                        ({
                          "Category": Category_field.text
                        });
                        ScaffoldMessenger.of(context).showSnackBar
                        (
                          SnackBar(backgroundColor: Colors.blue,content: Text("Category is added!")),
                        );
                      }
                    },
                    label: Text('Add Category'),
                    backgroundColor: Colors.indigo,
                  ),
                ),
              ],
            ),
          ),
      );
  }
}

//--------------------DATE PICKER CLASS---------------------//
