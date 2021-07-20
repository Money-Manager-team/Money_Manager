import 'package:flutter/material.dart';
import 'package:money_manager/main.dart';
import 'package:money_manager/screens/Add_Custom_Category.dart';
import 'package:money_manager/screens/Add_Expense.dart';
import 'package:money_manager/screens/budget.dart';
import 'package:money_manager/screens/guest_user_dash.dart';
import 'package:money_manager/screens/mainScreen.dart';
import 'package:money_manager/screens/premiumUserLogin.dart';
import 'package:money_manager/screens/premiumUserRegistration.dart';
import 'package:money_manager/screens/registered_user_dash.dart';
import 'package:money_manager/screens/update_budget.dart';
import 'package:money_manager/screens/view_expense.dart';
import 'constants.dart';

Route<dynamic> createRoute(settings) {
  switch (settings.name) {
    case splashScreen1: 
      return MaterialPageRoute
      (
        builder: (context) => splashScreen(),
      );
    case homeRoute:return MaterialPageRoute(
        builder: (context) => MainScreen(),
      );
    case premiumLoginRoute:
      return MaterialPageRoute(
        builder: (context) => PremiumUserLogin(),
      );

    case premiumRegistrationRoute:
      return MaterialPageRoute(
        builder: (context) => PremiumUserRegistration(),
      );

    case guestDashRoute:
      return MaterialPageRoute(
        builder: (context) => GuestUserDash(),
      );

    case registeredDashRoute:
      return MaterialPageRoute(
        builder: (context) => RegisteredUserDash(),
      );  

    case addCategoryRoute:
      return MaterialPageRoute(
        builder: (context) => CustomExpenseCategory(),
      ); 

    case addExpenseRoute:
      return MaterialPageRoute(
        builder: (context) => AddExpense(),
      ); 

    case viewExpenseRoute:
      return MaterialPageRoute(
        builder: (context) => ViewExpense(),
      ); 

    case viewBudgetLimitRoute:
      return MaterialPageRoute(
        builder: (context) => BudgetPage(),
      ); 

    case updateBudgetLimitRoute:
      return MaterialPageRoute(
        builder: (context) => UpdateBudget(),
      );            

  }
  return null;
}
