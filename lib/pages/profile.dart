import 'package:flutter/material.dart';
import 'package:kart_chatapp/pages/home_screen.dart';
import 'package:kart_chatapp/service/auth_service.dart';

import '../widget/widget.dart';
import 'auth/login_page.dart';

class ProfilePage extends StatefulWidget {
  String username;
  String email;

  ProfilePage({Key? key, required this.username,required this.email}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Profile",
        style: TextStyle(
          color: Colors.white,fontSize: 27,fontWeight: FontWeight.bold
        ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 75),
          children: <Widget>[
            const Icon(
              Icons.account_circle,
              size: 150,
              color: Colors.grey,
            ),
            const SizedBox(height: 15),
            Text(widget.username,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 30,
            ),
            const Divider(
              height: 2,
            ),
            ListTile(
              onTap: (){
                nextScreen(
                    context,
                    HomePage());
              },
              selectedColor: Theme.of(context).primaryColor,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              leading: const Icon(Icons.group),
              title: const Text("Groups",
                  style: TextStyle(
                    color: Colors.black,)
              ),
            ),
            ListTile(
              onTap: (){
              },
              selectedColor: Theme.of(context).primaryColor,
              selected: true,
              leading: Icon(Icons.account_circle),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              title: const Text("Profile",
                  style: TextStyle(
                    color: Colors.black,)
              ),
            ),
            ListTile(
              onTap: () async{
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Logout"),
                        content: Text("Are you sure to logout from this device?"),
                        actions: [
                          IconButton(
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.cancel,
                                color: Colors.red,)),
                          IconButton(
                              onPressed: () async{
                                await authService.signOut().whenComplete((){
                                  nextScreenReplace(context, LoginPage());
                                });
                              },
                              icon: const Icon(Icons.done,
                                color: Colors.green,))
                        ],
                      );
                    });
              },
              selectedColor: Theme.of(context).primaryColor,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              leading: const Icon(Icons.logout),
              title: const Text("Logout",
                  style: TextStyle(
                    color: Colors.black,)
              ),
            ),
          ],
        ),
      ),

      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40,
        vertical: 140),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.account_circle,
            size: 150,
            color: Colors.grey,),
            const SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Full name",style: TextStyle(fontSize: 17)),
                Text(widget.username,style:TextStyle(fontSize: 17)),
              ],
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Email",style: TextStyle(fontSize: 17)),
                Text(widget.email,style:TextStyle(fontSize: 17)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

