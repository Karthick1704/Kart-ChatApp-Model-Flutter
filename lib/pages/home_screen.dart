import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kart_chatapp/pages/profile.dart';
import 'package:kart_chatapp/pages/search_page.dart';
import 'package:kart_chatapp/service/auth_service.dart';
import 'package:kart_chatapp/service/database_service.dart';
import 'package:kart_chatapp/widget/group_tile.dart';
import 'package:kart_chatapp/widget/widget.dart';

import '../helper/helper_function.dart';
import 'auth/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthService authService = AuthService();
  String username = "";
  String email ="";
  Stream? groups;
  bool _isLoading = false;
  String groupName ="";


  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  String getId(String res){
    return res.substring(0,res.indexOf("_"));
  }

  String getName(String res){
    return res.substring(res.indexOf("_")+1);
  }

  gettingUserData() async{
    await Helperfunction.getUserEmailFromSF().then((value) {
      setState(() {
        email =value!;
      });
    });

    await Helperfunction.getUserNameFromSF().then((val) {
      setState(() {
        username = val!;
      });
    });

    await DatabaseService(uid: FirebaseAuth.instance.
    currentUser!.uid).getUserGroups().then((snapshot){
      setState(() {
        groups = snapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: (){
                nextScreenReplace(
                    context,
                    const SearchPage());
              },
              icon: const Icon(Icons.search))
        ],
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "Groups",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 27,
          ),
        ),
      ),
      drawer: Drawer(
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 50),
        children: <Widget>[
          Icon(
            Icons.account_circle,
            size: 150,
            color: Colors.grey[700],
          ),
          const SizedBox(height: 15),
          Text(username,
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
            onTap: (){},
            selectedColor: Theme.of(context).primaryColor,
            selected: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              leading: const Icon(Icons.group),
            title: const Text("Groups",
            style: TextStyle(
              color: Colors.black,)
            ),
          ),
          ListTile(
            onTap: (){
              nextScreenReplace(
                context,
              ProfilePage(email: email,
              username: username));
            },
            selectedColor: Theme.of(context).primaryColor,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
            leading: const Icon(Icons.account_circle),
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
                            onPressed: (){
                                authService.signOut().whenComplete((){
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
      ),),
      body: groupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          popUpDialog(context);
        },
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
  popUpDialog(BuildContext context){
    showDialog(
      barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: ((context, setState){
            return AlertDialog(
              title: const Text("Create a Group",
              textAlign: TextAlign.left,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _isLoading == true ? Center(child:
              CircularProgressIndicator(color: Theme.of(context).primaryColor),)
                :TextField(
                    onChanged: (val){
                      setState(() {
                        groupName = val;
                      });
                    },
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor),
                        borderRadius: BorderRadius.circular(20)),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                            color: Colors.red),
                            borderRadius: BorderRadius.circular(20)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(20)),
            )),
                ],
              ),
              actions: [
                ElevatedButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                  style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                  child: const Text("CANCEL"),
                ),
                ElevatedButton(
                  onPressed: (){
                    if(groupName!=""){
                      setState(() {
                        _isLoading = true;
                      });
                      DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                          .createGroup(username, FirebaseAuth.instance.
                      currentUser!.uid, groupName).whenComplete(() {
                        _isLoading = false;
                      });
                      Navigator.of(context).pop();
                      showSnackBar(context, Colors.green, "Group created successfully");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  child: const Text("CREATE"),
                ),
              ],
            );
            }));
        });
  }

  groupList(){
    return StreamBuilder(
      stream: groups,
        builder: (context, AsyncSnapshot snapshot){
        if(snapshot.hasData){
          if(snapshot.data['groups']!=null){
            if(snapshot.data['groups'].length != 0){
              return ListView.builder(
                  itemCount: snapshot.data["groups"].length,
                itemBuilder: (context, index){
                  int reverseIndex = snapshot.data["groups"].length-index-1;
                    return GroupTile(
                        username: snapshot.data["fullName"],
                        groupId: getId(snapshot.data["groups"][reverseIndex]),
                        groupName: getName(snapshot.data["groups"][reverseIndex]));
                }
              );
          }
            else{
              return noGroupWidget();
            }
          }
          else{
            return noGroupWidget();
          }
        }
        else{
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          );
        }
        });
  }

  noGroupWidget(){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: (){
              popUpDialog(context);
            },
            child: Icon(Icons.add_circle,
            color: Colors.grey[700],
            size: 75),
          ),
          const SizedBox(height: 20),
          const Text("You've not just joined any groups, tap on the add icon to create a group or"
              " search for an existing group",
          textAlign: TextAlign.center,)
        ],
      ),
    );
  }
}
