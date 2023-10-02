import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:newpro/Auth-services.dart';

class SignIn extends StatefulWidget {
  SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController _Email = TextEditingController();
  TextEditingController _Name = TextEditingController();
  TextEditingController _Password = TextEditingController();
  final CollectionReference users =
      FirebaseFirestore.instance.collection("users");
  AuthServies authServies = AuthServies();

  deluser(String id) async {
    await users.doc(id).delete();
  }

  updateUser(String id) async {
    await users.doc(id).update({"name": _Name.text, "email": _Email.text});
  }

  SignUp() async {
    final User? user = await authServies.signUp(_Email.text, _Password.text);
    await users.add({"name": _Name.text, "email": _Email.text});

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("nice")));
  }

  SignIn() async {
    final User? user = await authServies.SignIn(_Email.text, _Password.text);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("nicely done")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
          child: Column(
        children: [
          Text("Sign in"),
          TextFormField(
            controller: _Email,
            decoration: InputDecoration(
                hintText: 'Email', border: OutlineInputBorder()),
          ),
          TextFormField(
            controller: _Name,
            decoration:
                InputDecoration(hintText: 'Name', border: OutlineInputBorder()),
          ),
          TextFormField(
            controller: _Password,
            obscureText: true,
            decoration: InputDecoration(
                hintText: 'password', border: OutlineInputBorder()),
          ),
          ElevatedButton(
              onPressed: () {
                SignUp();
              },
              child: Text("Sign up")),
          ElevatedButton(
              onPressed: () {
                SignIn();
              },
              child: Text("Sign in")),
          StreamBuilder<QuerySnapshot>(
              stream: users.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                final UserList = snapshot.data!.docs;
                return Expanded(
                    child: ListView.builder(
                        itemCount: UserList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(UserList[index]['name']),
                            subtitle: Text(UserList[index]['email']),
                            trailing:
                                Row(mainAxisSize: MainAxisSize.min, children: [
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      deluser(UserList[index].id);
                                    });
                                  },
                                  icon: Icon(Icons.delete)),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _Name.text = UserList[index]['name'];
                                      _Email.text = UserList[index]['email'];
                                    });
                                  },
                                  icon: Icon(Icons.edit)),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      updateUser(UserList[index].id);
                                    });
                                  },
                                  icon: Icon(Icons.update)),
                            ]),
                          );
                        }));
              })
        ],
      )),
    );
  }
}
