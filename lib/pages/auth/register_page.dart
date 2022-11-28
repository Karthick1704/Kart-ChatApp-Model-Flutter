import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kart_chatapp/helper/helper_function.dart';
import 'package:kart_chatapp/pages/home_screen.dart';
import 'package:kart_chatapp/service/auth_service.dart';

import '../../constant.dart';
import '../../widget/widget.dart';
import 'login_page.dart';



class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  String name = "";
  String email = "";
  String password = "";
  bool _isLoading = false;
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading ? Center(child: CircularProgressIndicator(color:
      Theme.of(context).primaryColor)):SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
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
                  const Text("Create your account now to chat and explore",
                    style: TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Image.asset("assets/register_image.png"),
                  const SizedBox(height: 50),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(
                      labelText: "Full Name",
                      prefixIcon: Icon(Icons.person,
                          color: Theme.of(context).primaryColor),
                    ),
                    onChanged: (val){
                      setState(() {
                        name =val;
                      });
                    },
                    validator: (val){
                      if(val!.isNotEmpty){
                        return null;
                      }
                      else{
                        return "Name cannot be empty";
                      }
                    },
                  ),
                  const SizedBox(height: 15),
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
                    height: 30,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style:ElevatedButton.styleFrom(
                        foregroundColor: Constants().primarycolor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      onPressed: () {
                        register();
                      },
                      child: const Text(
                        "Register",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height:20,
                  ),
                  Text.rich(
                      TextSpan(
                        text: "Do have an account? ",
                        style: const TextStyle(color:Colors.black, fontSize: 14),
                        children: <TextSpan>[
                          TextSpan(
                              text: "Login now",
                              style: TextStyle(
                                  color: Constants().primarycolor,
                                  decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()..onTap =(){
                                nextScreenReplace(context, LoginPage());
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
  register() async{
    if(formKey.currentState!.validate()){
      setState(() {
        _isLoading = true;
      });
      await authService.registerUserWithEmailandPassword(
          name, email, password).then((value) async {
            if(value == true){
              await Helperfunction.saveUserLoggedInStatus(true);
              await Helperfunction.saveUserEmailSF(email);
              await Helperfunction.saveUserNameSF(name);
              nextScreenReplace(context,HomePage());
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
