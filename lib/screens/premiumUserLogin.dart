import 'package:flutter/material.dart';
import 'package:money_manager/Loading.dart';
import 'package:money_manager/constants.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:string_validator/string_validator.dart';

class PremiumUserLogin extends StatefulWidget {
  @override
  _PremiumUserLoginState createState() => _PremiumUserLoginState();
}

class _PremiumUserLoginState extends State<PremiumUserLogin> {
  //KEYS
  GlobalKey<FormState> KEY = GlobalKey<FormState>();

  //Controllers
  TextEditingController Email = TextEditingController();
  TextEditingController Password = TextEditingController();

  //Bools
  bool is_email_exist = true;
  bool is_password_not_wrong = true;
  bool is_too_requests = false;
  bool password_icon_state = false;
  bool is_loading = false;

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
    return  is_loading? Loading(): Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: KEY,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  height: 40.0,
                ),
                Image(
                  image: AssetImage("images/logo.png"),
                  width: 350.0,
                  height: 200.0,
                  alignment: Alignment.center,
                ),
                SizedBox(
                  height: 60.0,
                ),
                Text(
                  "Login as a Premium User",
                  style: TextStyle(
                    fontSize: 21.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Brand Bold",
                  ),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 1.0,
                      ),
                      TextFormField(
                        onChanged: (e)
                        {
                          is_email_exist = true;
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
                          else if(is_email_exist == false)
                          {
                            return "Email is not exist";
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
                      TextFormField(
                        onChanged: (e)
                        {
                          is_password_not_wrong = true;
                          is_too_requests = false;
                        },
                        validator: (v)
                        {
                          if(v.trim() == '')
                          {
                            return "Password is empty";
                          }
                          else if(is_password_not_wrong == false)
                          {
                            return "Password is wrong";
                          }
                          else if(is_too_requests == true)
                          {
                            return "Too many requests, Please try again later";
                          }
                        },
                        controller: Password,
                        obscureText: !password_icon_state,
                        decoration: InputDecoration(
                          suffixIcon: IconButton
                          (
                            icon: password_icon_state? Icon(Icons.visibility): Icon(Icons.visibility_off),
                            //on clicked
                            onPressed: ()
                            {
                              HIDE_SHOW();
                            },
                          ),
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
                        height: 30.0,
                      ),
                      // ignore: deprecated_member_use
                      RaisedButton(
                          color: Colors.greenAccent[700],
                          textColor: Colors.white,
                          child: Container(
                            height: 50.0,
                            child: Center(
                              child: Text(
                                "Login",
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
                                await FirebaseAuth.instance.signInWithEmailAndPassword(email: Email.text, password: Password.text);
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
                                if(e.code == 'user-not-found')
                                {
                                  setState(() {
                                    is_email_exist = false;
                                  });
                                }
                                else if(e.code == "wrong-password")
                                {
                                  setState(() {
                                    is_password_not_wrong = false;
                                  });
                                }
                                else if(e.code == "too-many-requests")
                                {
                                  setState(() {
                                    is_too_requests = true;
                                  });
                                }
                              }
                            }
                          })
                    ],
                  ),
                ),

                SizedBox(
                  height: 25.0,
                ),
                // ignore: deprecated_member_use
                FlatButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                      context,
                      premiumRegistrationRoute,
                      // arguments: 
                    );
                  },
                  child: Text(
                    "Do not have an Account? Register Here.",
                    style: TextStyle(fontSize: 16.0, fontFamily: "Brand Bold", color: Colors.green[500]),
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
