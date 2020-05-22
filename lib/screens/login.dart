import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackerapp/providers/tracker_provider.dart';

class MyLogin extends StatefulWidget {
  static const routeName = '/login';

  @override
  MyLoginState createState() {
    return MyLoginState();
  }
}

class MyLoginState extends State<MyLogin> {
  bool _isLoading = false;
  String usernameErrorMsg;
  String passwordErrorMsg;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
            padding: EdgeInsets.all(80.0),
            child: AutofillGroup(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "S'identifier",
                    style: Theme.of(context).textTheme.display4,
                  ),
                  TextField(
                    controller: usernameController,
                    autofillHints: [AutofillHints.username],
                    decoration: InputDecoration(
                        hintText: 'Login',
                        icon: Icon(Icons.perm_identity),
                        errorText: usernameErrorMsg),
                  ),
                  TextField(
                    controller: passwordController,
                    textInputAction: TextInputAction.done,
                    autofillHints: [AutofillHints.password],
                    decoration: InputDecoration(
                        hintText: 'Mot de passe',
                        icon: Icon(Icons.lock),
                        errorText: passwordErrorMsg),
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  RaisedButton(
                    color: Colors.yellow,
                    child: Center(
                        child: _isLoading
                            ? SizedBox(
                                height: 20.0,
                                width: 20.0,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                    backgroundColor: Colors.black))
                            : Text('Entrer')),
                    onPressed: () {
                      if (validateFields()) {
                        signIn(context);
                      }
                    },
                  )
                ],
              ),
            )),
      ),
    );
  }

  bool validateFields() {
    bool valid = false;
    setState(() {
      // Username validation
      if (usernameController.text.isEmpty) {
        usernameErrorMsg = 'Saisir votre login';
      } else {
        usernameErrorMsg = null;
      }

      // Password validation
      if (passwordController.text.isEmpty) {
        passwordErrorMsg = 'Saisir votre mot de passe';
      } else if (passwordController.text.length < 6) {
        passwordErrorMsg = 'Mot de passe trop court';
      } else {
        passwordErrorMsg = null;
      }

      if (usernameErrorMsg == null && passwordErrorMsg == null) {
        _isLoading = true;
        valid = true;
      }
    });
    return valid;
  }

  signIn(BuildContext context) async {
    final response = await http.post('https://www.benbb96.com/api/token/',
        body: {
          'username': usernameController.text,
          'password': passwordController.text
        });

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      final jwt = data['access'];
      final refresh = data['refresh'];
      setState(() {
        passwordErrorMsg = null;
        _isLoading = false;
      });
      // Create storage
      final storage = new FlutterSecureStorage();
      await storage.write(key: 'jwt', value: jwt);
      await storage.write(key: 'refresh', value: refresh);

      // Fetch trackers now that we have the JWT
      Provider.of<TrackerProvider>(context, listen: false)
          .fetchTrackers(context);

      // Change page
      Navigator.pushReplacementNamed(context, '/trackers');
    } else {
      print(response.body);
      setState(() {
        passwordErrorMsg = "Erreur de mot de passe";
        _isLoading = false;
      });
    }
  }
}
