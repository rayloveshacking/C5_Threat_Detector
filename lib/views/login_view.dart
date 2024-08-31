import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/usage/usage.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
    _password = TextEditingController();
  }

 @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Login",
          style: TextStyle(
            color: Colors.blue, // Set the color of the title text here
          ),
        ),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: "Enter your email here."),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(hintText: "Enter your password here."),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
              await FirebaseAuth.instance
                    .signInWithEmailAndPassword(email: email, password: password);
                    Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const HomeView()),
                    );
              } on FirebaseAuthException catch (e) {
                if (e.code == 'invalid-credential') {
                  print("User not found");
                  
                } else {
                  print("Something else happened");
                  print(e.code);
                }
              }
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
 

  
}

