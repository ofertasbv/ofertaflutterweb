import 'package:flutter/material.dart';

class TesteRadioList extends StatefulWidget {
  @override
  _TesteRadioListState createState() => _TesteRadioListState();
}

class _TesteRadioListState extends State<TesteRadioList> {
  List<User> users;
  User selectedUser;

  @override
  void initState() {
    super.initState();
    users = User.getUsers();
  }

  setSelectedUser(User user) {
    setState(() {
      selectedUser = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("RadioListTitle"),
      ),
      body: Container(
        child: Center(
          child: RaisedButton(
            child: Text("dialog"),
            onPressed: () {
              teste();
            },
          ),
        ),
      ),
    );
  }

  teste() {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Teste dialog"),
              content: Container(
                width: 300.0,
                child: ListView(
                  children: users.map((u) {
                    return RadioListTile<User>(
                      value: u,
                      groupValue: selectedUser,
                      title: Text(u.firstName),
                      subtitle: Text(u.lastName),
                      selected: selectedUser == u,
                      activeColor: Colors.green,
                      autofocus: true,
                      toggleable: true,
                      secondary: Icon(Icons.select_all_outlined),
                      onChanged: (valor) {
                        setState(() {
                          setSelectedUser(valor);
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancelar"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  dialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          contentPadding: EdgeInsets.only(top: 10.0),
          content: Container(
            width: 300.0,
            child: ListView(
              children: users.map((u) {
                return RadioListTile<User>(
                  value: u,
                  groupValue: selectedUser,
                  title: Text(u.firstName),
                  subtitle: Text(u.lastName),
                  selected: selectedUser == u,
                  activeColor: Colors.green,
                  autofocus: true,
                  toggleable: true,
                  secondary: Icon(Icons.select_all_outlined),
                  onChanged: (valor) {
                    setState(() {
                      setSelectedUser(valor);
                    });
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("ok"),
            )
          ],
        );
      },
    );
  }
}

class User {
  int userId;
  String firstName;
  String lastName;

  User({this.userId, this.firstName, this.lastName});

  static List<User> getUsers() {
    return <User>[
      User(userId: 1, firstName: "Aaron", lastName: "Jackson"),
      User(userId: 2, firstName: "Ben", lastName: "John"),
      User(userId: 3, firstName: "Carrie", lastName: "Brown"),
      User(userId: 4, firstName: "Deep", lastName: "Sen"),
      User(userId: 5, firstName: "Emily", lastName: "Jane"),
      User(userId: 6, firstName: "Aaron", lastName: "Jackson"),
      User(userId: 7, firstName: "Ben", lastName: "John"),
      User(userId: 8, firstName: "Carrie", lastName: "Brown"),
      User(userId: 9, firstName: "Deep", lastName: "Sen"),
      User(userId: 10, firstName: "Emily", lastName: "Jane"),
    ];
  }
}
