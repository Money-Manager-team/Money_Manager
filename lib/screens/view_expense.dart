import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ViewExpense extends StatefulWidget {
  @override
  _DatePicker createState() => _DatePicker();
}

class _DatePicker extends State<ViewExpense> {

  //DateTimes
  DateTime startDate;
  DateTime endDate;

  //Bools
  bool s = true;

  //Strings
  String date_ = "";
  String newDate = "";

  //Voids
  void get_data() async
  {
    DocumentSnapshot get_username = await FirebaseFirestore.instance.collection("USERs").doc(FirebaseAuth.instance.currentUser.uid).collection("Expense").doc().get();
    setState(() {
      date_ = get_username["Date"];
    });
  }
  
  @override
  void initState() {
    super.initState();
    startDate = DateTime.now();
    endDate = DateTime.now();
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
                title: Text("View Expenses",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 23, fontWeight: FontWeight.bold))),
            ListTile(
              title: Text(
                  "Start Date: ${startDate.day}/ ${startDate.month}/ ${startDate.year}"),
              trailing: Icon(Icons.date_range),
              onTap: _startDate,
            ),
            ListTile(
              title: Text(
                  "End Date: ${endDate.day}/ ${endDate.month}/ ${endDate.year}"),
              trailing: Icon(Icons.date_range),
              onTap: _endDate,
            ),
            SizedBox
            (height: 20,),
            StreamBuilder
            (
              stream: FirebaseFirestore.instance.collection("USERs").doc(FirebaseAuth.instance.currentUser.uid).collection("New Expense History").snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot)
              {
                if(!snapshot.hasData)
                {
                  return CircularProgressIndicator();
                }
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  return CircularProgressIndicator();
                    break;
                  default:
                  return Column
                  (
                    children: snapshot.data.docs.map((DocumentSnapshot doc){
                      if(DateTime.parse(doc["Date"]).isAfter(startDate) == true && DateTime.parse(doc["Date"]).isBefore(endDate) == true || DateTime.parse(doc["Date"]).compareTo(startDate) == 0 || DateTime.parse(doc["Date"]).compareTo(endDate) == 0)
                      {
                        print(doc["Date"]);
                          newDate = doc["Date"];
                      }
                      else
                      {
                          newDate = "no data";
                      }
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: newDate == "no data"? null: Container(
                          height: 150,
                          width: 270,
                          decoration: BoxDecoration
                          (
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.blue[100],
                          ),
                          child: Center(
                            child: ListTile
                            (

                              title: Text("Category: " + doc["Category"]),
                              subtitle: Text
                              (
                                "Price: RM " +
                                 doc["Amount"]+
                                 "\n"+
                                "Date: "+
                                newDate
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList()
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }

  void _startDate() async {
    DateTime date = await showDatePicker(
        context: context,
        initialDate: startDate,
        firstDate: DateTime(DateTime.now().year),
        lastDate: DateTime(DateTime.now().year + 10));

    if (date != null) {
      setState(() {
        startDate = date;
      });
    }
  }

  void _endDate() async {
    DateTime date = await showDatePicker(
        context: context,
        initialDate: endDate,
        firstDate: DateTime(DateTime.now().year),
        lastDate: DateTime(DateTime.now().year + 10));

    if (date != null) {
      setState(() {
        endDate = date;
      });
    }
  }
}
