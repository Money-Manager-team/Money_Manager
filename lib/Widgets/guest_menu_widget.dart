import 'package:flutter/material.dart';
import 'package:money_manager/screens/Add_Expense.dart';
import 'package:money_manager/screens/budget.dart';
import 'package:money_manager/screens/view_expense.dart';
import '../constants.dart';

class GuestMenu extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return  Drawer(
        child: Card(
          child: ListView(
            padding: EdgeInsets.all(1),
            children: <Widget>[
              Container(
                height: 100,
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
                          title: Align(
                            child: new Text("  GUEST USER"),
                            alignment: Alignment(-1.5, 0),
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
                      "View Expense", Icons.list, context, 2)),
              Card(
                child: buildListTiledrawer(
                    "Budget Limit", Icons.edit_sharp, context, 3),
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
                  child: Text('Register'),                  
                  onPressed: () async {
                          Navigator.pushReplacementNamed(
                            context,
                            premiumRegistrationRoute,
                          );
                        },
                ),
              ),
              Center(child: Text('To get access to all features', style: TextStyle(color: Colors.red),),),
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
            Navigator.push(context, MaterialPageRoute(builder: (context)=> AddExpense()));
          }
          if (num == 2) {
            Navigator.push(context, MaterialPageRoute(builder: (context)=> ViewExpense()));
          }
          if (num == 3) {
            Navigator.push(context, MaterialPageRoute(builder: (context)=> BudgetPage()));
          }
          
        });
  }

}