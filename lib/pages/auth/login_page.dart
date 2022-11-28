import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kart_chatapp/pages/auth/register_page.dart';
import 'package:kart_chatapp/service/database_service.dart';
import 'package:kart_chatapp/widget/widget.dart';

import '../../constant.dart';
import '../../helper/helper_function.dart';
import '../../service/auth_service.dart';
import '../home_screen.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool _isLoading = false;
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading ? Center(child:CircularProgressIndicator(color: Theme.of(context)
          .primaryColor)):SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 80),
          child: Form(
            key: formKey,
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text("Groupie",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text("Login now to see what they are talking",
                style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w400,
                ),
                ),
                Image.asset("assets/Loginimage.jpg"),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                    labelText: "Email",
                    prefixIcon: Icon(Icons.email,
                    color: Theme.of(context).primaryColor),
                  ),
                  onChanged: (val){
                    setState(() {
                      email =val;
                    });
                  },
                  validator: (val){
                    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+"
                    r"@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val!)?null
                        :"Please enter a valid email";
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  obscureText: true,
                  decoration: textInputDecoration.copyWith(
                    labelText: "Password",
                    prefixIcon: Icon(Icons.lock,
                        color: Theme.of(context).primaryColor),
                  ),
                  validator: (val){
                    if(val!.length <6){
                      return "Password must be atleast 6 characters";
                    }
                    else{
                      return null;
                    }
                  },
                  onChanged: (val){
                    setState(() {
                      password =val;
                    });
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style:ElevatedButton.styleFrom(
                      foregroundColor: Constants().primarycolor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),),
                    ),
                    onPressed: () {
                      login();
                    },
                    child: const Text(
                      "Sign In",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text.rich(
                    TextSpan(
                      text: "Dont have an account?",
                      style: TextStyle(color:Colors.black, fontSize: 14),
                      children: <TextSpan>[
                        TextSpan(
                          text: "Register here",
                          style: TextStyle(
                            color: Constants().primarycolor,
                            decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()..onTap =(){
                            nextScreenReplace(context, RegisterPage());
                          }
                        )
                      ],
                    )
                )
              ],
            )
          ),
        ),
      ),
    );
  }
  login() async{
    if(formKey.currentState!.validate()){
      setState(() {
        _isLoading = true;
      });
      await authService.loginInWithUserAndPassword(
          email, password).then((value) async {
        if(value == true){
          QuerySnapshot snapshot = await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
              .gettinguserData(email);
          await Helperfunction.saveUserLoggedInStatus(true);
          await Helperfunction.saveUserEmailSF(email);
          await Helperfunction.saveUserNameSF(snapshot.docs[0]['fullName']);
          nextScreenReplace(
              context,
              HomePage());
        }else{
          showSnackBar(context, Colors.red, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}
