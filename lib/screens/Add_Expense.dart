import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Category {
  String title;
  String value;

  Category(this.title, this.value);
}
// list of class Category
List<Category> categories = [
  Category('Empty', ''),
  Category('Food', 'Food'),
  Category('Grocery', 'Grocery'),
  Category('Entertainment', 'Entertainment'),
];



class AddExpense extends StatefulWidget {
  @override
  AddExpenseState createState() => AddExpenseState();
}

class AddExpenseState extends State<AddExpense> {
  //KEYS
  GlobalKey<FormState> KEY = GlobalKey<FormState>();

  //Strings
  String categoryValue = '';
  String Alert_content = "";

  //Bools
  bool is_date_choosen = false;
  bool is_alert = false;
  
  //Ints
  String Date;
  int budget = 0;
  int expenditure = 0;

  //Controllers
  TextEditingController Amount = TextEditingController();

  //DateTimes
  DateTime selectedDate = DateTime.now();

  //Voids
  get_expenditure() async
  {
    DocumentSnapshot EXPENDITURES = await FirebaseFirestore.instance.collection("USERs").doc(FirebaseAuth.instance.currentUser.uid).get();
    setState(() {
      expenditure = EXPENDITURES["Expenditure"];
    });
    if(expenditure == budget)
    {
      print(expenditure);
      print(budget);
      setState(() {
        is_alert = true;
        Alert_content = "You have reached your budget limit";
      });
    }
    else if(expenditure >= budget * 0.8 && expenditure < budget)
    {
      print(expenditure);
      print(budget * 0.8);
      setState(() {
        is_alert = true;
        Alert_content = "You have almost reach your budget limit";
      });
    }
    else if(expenditure > budget)
    {
      print(expenditure);
      print(budget);
      setState(() {
        is_alert = true;
        Alert_content = "You have exceeded your budget limit";
      });
    }
  }
  void get_budget() async
  {
    DocumentSnapshot BUDGET = await FirebaseFirestore.instance.collection("USERs").doc(FirebaseAuth.instance.currentUser.uid).get();
    setState(() {
      budget = int.parse(BUDGET["Budget"]);
    });
  }
  void set_expenditure() async
  {
    await FirebaseFirestore.instance.collection("USERs").doc(FirebaseAuth.instance.currentUser.uid).update
    ({
      "Expenditure": expenditure,
    });
  }
  void _selectDate(BuildContext context) async {
    Date = selectedDate.toString().split(" ")[0];
    setState(() {
      is_date_choosen = true;
    });
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
    {
      setState(() {
        selectedDate = picked;
        Date = selectedDate.toString().split(" ")[0];
      });
    }
  }
  @override
  Widget build(BuildContext contxt) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
                'Money Manager',
                style: TextStyle(fontSize: 20),
              ),
          centerTitle: true,
        ),
        //drawer: status? GuestMenu() : RegisteredMenu(),
        body: is_alert?   AlertDialog(
        backgroundColor: Colors.white,
        title: Text("Warning!", style: TextStyle(color: Colors.red),),
        content: Text(Alert_content, style: TextStyle(color: Colors.red)),
        actions: 
            [
              FlatButton
              (
                onPressed: ()
                {
                  setState(() {
                    is_alert = false;
                  });
                },
                child: Text("OK", style: TextStyle(color: Colors.black))
              )
            ],
          ):  
          SingleChildScrollView(
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: KEY,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Container(
                    padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 25.0),
                    alignment: Alignment.topCenter,
                    child: Text(
                      "Add Expense",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30.0, 25.0, 45.0, 0.0),
                      child: Text(
                        'Amount',
                        style: TextStyle(fontSize: 18.0),
                      ),),
                    Container(
                        margin: EdgeInsets.fromLTRB(17.0, 35.0, 5.0, 2.0) ,
                        width: 150,
                        child: TextFormField(
                          validator: (v)
                          {
                            if(v.trim() == "")
                            {
                              return "Amount is empty";
                            }
                          },
                          controller: Amount,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Enter amount here',
                            hintText: 'RM 0.00',
                          ),
                          autofocus: false,
                        )),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30.0, 25.0, 45.0, 0.0),
                      child: Text(
                        'Category',
                        style: TextStyle(fontSize: 18.0),
                      ),),
                      StreamBuilder
                      (
                        stream: FirebaseFirestore.instance.collection("USERs").doc(FirebaseAuth.instance.currentUser.uid).collection("Custom Categories").snapshots(),
                        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot)
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
                            List<String> s = [];
                            categories.forEach((element) 
                            {
                              s.add(element.title);
                            });
                            for(int i = 0; i < snapshot.data.docs.length; i++)
                            { 
                              print("entered");
                              print(i);
                              DocumentSnapshot i2 = snapshot.data.docs[i];
                              if(s.toString().contains(i2.data().toString().replaceAll("{Category: ", "").replaceAll("}", "")) == false)
                              {
                                categories.add
                                (
                                  Category(i2.get("Category"),i2.get("Category")),
                                );
                              }
                            }
                            return Card
                            (
                              margin: EdgeInsets.fromLTRB(10.0, 30.0, 12.0, 20.0),
                              elevation: 2.0,
                              child: Padding
                              (
                                padding: const EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 2.0),
                                child: DropdownButton<String>
                                (
                                  
                                  isExpanded: false,
                                  value: categoryValue,
                                  //? used to construct dropdown menu
                                  items: categories.map((Category category)
                                  {
                                    return DropdownMenuItem<String>
                                    (
                                      child: Text(category.title),
                                      value: category.value,
                                    );
                                  }).toList(),
                                  onChanged: (newValue) 
                                  {
                                    setState(() 
                                    {
                                      categoryValue = newValue;
                                    });
                                  },
                              ), )
                            );
                          }
                        }
                      ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30.0, 50.0, 45.0, 0.0),
                      child: Text(
                        'Date: ${selectedDate.toLocal().toString().split(" ")[0]}',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                        margin: EdgeInsets.fromLTRB(90.0, 35.0, 5.0, 2.0) ,
                        width: 200,

                        child: FloatingActionButton.extended(
                           heroTag: 'select date',
                          onPressed: ()
                          {
                            _selectDate(context);
                          },
                          label: Text('Select date'),
                          backgroundColor: Colors.indigo,
                        ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(90.0, 85.0, 5.0, 2.0) ,
                  width: 200,
                        child: StreamBuilder(
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
                                print(i);
                                i2 += int.parse(snapshot.data.docs[i]["Amount"]);
                                expenditure = i2;
                              }
                            }
                            return FloatingActionButton.extended(
                            onPressed: () async
                            {
                              if(KEY.currentState.validate() == true)
                              {
                                if(categoryValue == "")
                                {
                                  ScaffoldMessenger.of(context).showSnackBar
                                  (
                                    SnackBar(backgroundColor: Colors.red,content: Text("Please choose a Category")),
                                  );
                                }
                                else if(is_date_choosen == false)
                                {
                                  ScaffoldMessenger.of(context).showSnackBar
                                  (
                                    SnackBar(backgroundColor: Colors.red,content: Text("Please choose a Date")),
                                  );
                                }
                                else 
                                {
                                  await FirebaseFirestore.instance.collection("USERs").doc(FirebaseAuth.instance.currentUser.uid).collection("Expense History").doc().set
                                  ({
                                    "Amount": Amount.text,
                                    "Category": categoryValue,
                                    "Date": Date,
                                  }).then((value)async => 
                                  {
                                    await FirebaseFirestore.instance.collection("USERs").doc(FirebaseAuth.instance.currentUser.uid).collection("New Expense History").doc().set
                                    ({
                                      "Amount": Amount.text,
                                      "Category": categoryValue,
                                      "Date": Date,
                                    }).then((value)async => 
                                    {
                                      await FirebaseFirestore.instance.collection("USERs").doc(FirebaseAuth.instance.currentUser.uid).update
                                      ({
                                        "Expenditure": expenditure
                                      }).then((value) => 
                                      {
                                          get_budget(),
                                          set_expenditure(),
                                          get_expenditure(),
                                        ScaffoldMessenger.of(context).showSnackBar
                                        (
                                          SnackBar(backgroundColor: Colors.blue,content: Text("Expense is added!")),
                                        ),
                                      })
                                    })
                                  });
                                }
                              }
                            },
                            heroTag: 'add expense',
                            label: Text('Add Expense'),
                            backgroundColor: Colors.indigo,
                          );
                          }
                        )
                ),
              ],
            ),
          ),
        ),
    );
  }
}

//--------------------DATE PICKER CLASS---------------------//
