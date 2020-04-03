import 'package:flutter/material.dart';

class MyLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(80.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome',
                style: Theme.of(context).textTheme.display4,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Login',
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Mot de passe',
                ),
                obscureText: true,
              ),
              SizedBox(
                height: 24,
              ),
              RaisedButton(
                color: Colors.yellow,
                child: Text('Entrer'),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/trackers');
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}