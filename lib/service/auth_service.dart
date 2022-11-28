import 'package:firebase_auth/firebase_auth.dart';
import 'package:kart_chatapp/helper/helper_function.dart';
import 'package:kart_chatapp/service/database_service.dart';

class AuthService{
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  // login
  Future loginInWithUserAndPassword(String email,String password) async{
    try{
      User user = (await firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password)).user!;
      if(user!= null){
        return true;
      }
    }on FirebaseAuthException catch(e){
      return e.message;
    }
  }


  // register
  Future registerUserWithEmailandPassword(String name, String email,String password) async{
   try{
     User user = (await firebaseAuth.createUserWithEmailAndPassword(
         email: email,
         password: password)).user!;
     if(user!= null){
       await DatabaseService(uid: user.uid).savinguserData(name, email);
       return true;
     }
   }on FirebaseAuthException catch(e){
     return e.message;
   }
  }

  Future signOut() async{
    try{
      await Helperfunction.saveUserLoggedInStatus(false);
      await Helperfunction.saveUserEmailSF("");
      await Helperfunction.saveUserNameSF("");
      await firebaseAuth.signOut();
    }catch(e){
      return null;
    }
  }

}