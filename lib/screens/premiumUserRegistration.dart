import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:money_manager/Loading.dart';
import 'package:money_manager/constants.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import 'package:string_validator/string_validator.dart';

class PremiumUserRegistration extends StatefulWidget {
  static const String idScreen = "registerTutor";

  @override
  _PremiumUserRegistrationState createState() => _PremiumUserRegistrationState();
}

class _PremiumUserRegistrationState extends State<PremiumUserRegistration> {

  //KEYS
  GlobalKey<FormState> KEY = GlobalKey<FormState>();

  //Controllers
  TextEditingController Username = TextEditingController();
  TextEditingController Email = TextEditingController();
  TextEditingController Phone = TextEditingController();
  TextEditingController Password = TextEditingController();
  TextEditingController Confirmed_Password = TextEditingController();

  //Bools
  bool password_icon_state = false;
  bool is_email_already_in_use = false;
  bool is_loading = false;

  //Strings
  String phone_number;
  
  //Voids
  void HIDE_SHOW()
  {
    setState(() {
      password_icon_state = !password_icon_state;
    });
  }
  void turn_loading_off()
  {
    setState(() {
      is_loading = false;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return is_loading? Loading(): Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: KEY,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  height: 50.0,
                ),
                Image(
                  image: AssetImage("images/logo.png"),
                  width: 350.0,
                  height: 200.0,
                  alignment: Alignment.center,
                ),
                SizedBox(
                  height: 35.0,
                ),
                Text(
                  "Become a Premium User",
                  style: TextStyle(
                    fontSize: 21.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Brand Bold",
                  ),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 0.50,
                      ),
                      TextFormField(
                        validator: (v)
                        {
                          if(v.trim() == '')
                          {
                            return "Name is empty";
                          }
                          else if(v.length < 6)
                          {
                            return "Name must be 6 letters at least";
                          }
                        },
                        controller: Username,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Name",
                          labelStyle: TextStyle(
                            fontSize: 14.0,
                            fontFamily: "Brand Bold",
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          ),
                        ),
                        style: TextStyle(fontSize: 14.0),
                      ),

                      SizedBox(
                        height: 1.0,
                      ),
                      TextFormField(
                        onChanged: (s)
                        {
                          setState(() {
                            is_email_already_in_use = false;
                          });
                        },
                        validator: (v)
                        {
                          if(v.trim() == '')
                          {
                            return "Email is empty";
                          }
                          else if(isEmail(v) == false)
                          {
                            return "Invaild email format";
                          }
                          else if(is_email_already_in_use == true)
                          {
                            return "Email is already in use";
                          }
                        },
                        controller: Email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(
                            fontSize: 14.0,
                            fontFamily: "Brand Bold",
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          ),
                        ),
                        style: TextStyle(fontSize: 14.0),
                      ),

                      SizedBox(
                        height: 1.0,
                      ),
                      InternationalPhoneNumberInput
                      (
                        onInputChanged: (s)
                        {
                          setState(() {
                            phone_number = s.toString();
                          });
                        },
                        keyboardType: TextInputType.phone,
                        inputDecoration: InputDecoration(
                          labelText: "Phone",
                          labelStyle: TextStyle(
                            fontSize: 14.0,
                            fontFamily: "Brand Bold",
                          ),
                        ),
                        textStyle: TextStyle(fontSize: 14.0),
                        textFieldController: Phone,
                        selectorConfig: SelectorConfig(selectorType: PhoneInputSelectorType.BOTTOM_SHEET, useEmoji: true),
                        autoValidateMode: AutovalidateMode.onUserInteraction,
                      ),
                      SizedBox(
                        height: 1.0,
                      ),
                      TextFormField(
                        validator: (v)
                        {
                          if(v.trim() == '')
                          {
                            return 'Password is empty';
                          }
                          else if(v.length < 8)
                          {
                            return 'Password must be at least 8 letters';
                          }
                          else if(v.contains(RegExp(r'[A-Z]')) == false)
                          {
                            return "Password must contains 1 UPPERCASE at least";
                          }
                          else if(v.contains(RegExp(r'[a-z]')) == false)
                          {
                            return "Password must contains 1 lowercase at least";
                          }
                          else if(v.contains(RegExp(r'[0-9]')) == false)
                          {
                            return "Password must contains 1 number at least";
                          }
                          else if(v.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')) == false)
                          {
                            return "Password must contains 1 special letter at least";
                          }
                        },
                        controller: Password,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(
                            fontSize: 14.0,
                            fontFamily: "Brand Bold",
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          ),
                        ),
                        style: TextStyle(fontSize: 14.0),
                      ),

                      SizedBox(
                        height: 1.0,
                      ),
                      TextFormField(
                        validator: (v)
                        {
                          if(v.trim() == '')
                          {
                            return 'Password is empty';
                          }
                          else if(equals(v, Password.text) == false)
                          {
                            return 'Password does not match';
                          }
                        },
                        controller: Confirmed_Password,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Confirm Password",
                          labelStyle: TextStyle(
                            fontSize: 14.0,
                            fontFamily: "Brand Bold",
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          ),
                        ),
                        style: TextStyle(fontSize: 14.0),
                      ),

                      SizedBox(
                        height: 35.0,
                      ),
                      // ignore: deprecated_member_use
                      RaisedButton(
                      color: Colors.greenAccent[700],
                      textColor: Colors.white,
                      child: Container(
                        height: 50.0,
                        child: Center(
                          child: Text(
                            "Create Account",
                            style: TextStyle(
                                fontSize: 18.0, fontFamily: "Brand Bold"),
                          ),
                        ),
                      ),
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(23.0),
                      ),
                      onPressed: () async {
                        if(KEY.currentState.validate() == true)
                        {
                          try
                          {
                            await Firebase.initializeApp();
                            UserCredential user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: Email.text, password: Password.text,);
                            await FirebaseFirestore.instance.collection("USERs").doc(user.user.uid).set
                            ({
                              "Name": Username.text,
                              "Phone number": phone_number,
                              "Expenditure": 0,
                              "Budget": 0,
                            });
                            setState(() {
                              is_loading = true;
                            });
                            await Future.delayed(Duration(seconds: 2));
                            Navigator.pushReplacementNamed(
                              context,
                              registeredDashRoute,
                            ).then((value) => turn_loading_off());
                          } 
                          on FirebaseAuthException catch(e,s)
                          {
                            print(e);
                            print(s);
                            if(e.code == "email-already-in-use")
                            {
                              setState(() {
                                is_email_already_in_use = true;
                              }); 
                            }
                            }catch(e,s)
                            {
                              print("there is an unknown error");
                              print(e);
                              print(s);
                            }
                          }
                        }
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}