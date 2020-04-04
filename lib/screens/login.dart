import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:io';

import 'package:flutter/material.dart';

class MyLogin extends StatefulWidget {
  @override
  MyLoginState createState() {
    return MyLoginState();
  }
}

class MyLoginState extends State<MyLogin> {
  bool _isLoading = false;
  bool _wrongPassword = false;
  final _formKey = GlobalKey<FormState>();
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
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "S'identifier",
                    style: Theme.of(context).textTheme.display4,
                  ),
                  TextFormField(
                    controller: usernameController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Saisir votre login';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: 'Login', icon: Icon(Icons.perm_identity)),
                  ),
                  TextFormField(
                    controller: passwordController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Saisir votre mot de passe';
                      }
                      if (value.length < 6) {
                        return 'Mot de passe trop court';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: 'Mot de passe',
                        icon: Icon(Icons.lock),
                        errorText:
                            _wrongPassword ? "Erreur de mot de passe" : null),
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
                      if (_formKey.currentState.validate()) {
                        setState(() {
                          _isLoading = true;
                        });

                        signIn(
                            usernameController.text, passwordController.text);
                      }
                    },
                  )
                ],
              ),
            )),
      ),
    );
  }

  signIn(String login, String password) async {
    final response = await http.post('http://192.168.1.85:8000/api/token/',
        body: {'username': login, 'password': password});

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      final jwt = data['access'];
      setState(() {
        _wrongPassword = false;
        _isLoading = false;
      });
      // Create storage
      final storage = new FlutterSecureStorage();
      await storage.write(key: 'jwt', value: jwt);

      // Change page
      Navigator.pushReplacementNamed(context, '/trackers');
    } else {
      setState(() {
        _wrongPassword = true;
        _isLoading = false;
      });
    }
  }
}
