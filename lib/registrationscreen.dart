import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vssauthen/HomeScreen.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // final TextEditingController _controller = TextEditingController();

  late String _email, _password;
  final _formkey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Registration",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Container(
                margin: const EdgeInsets.all(16),
                alignment: Alignment.center,
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        validator: (item) {
                          return (item == null ||
                                  item.isEmpty ||
                                  item.contains("@"))
                              ? null
                              : "Enter a valid email";
                        },
                        onChanged: (item) {
                          setState(() {
                            _email = item;
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: "Enter Email",
                          labelText: "Email",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        validator: (item) {
                          return (RegExp(r'[a-zA-Z]').hasMatch(item!) &&
                                  item.length > 6)
                              ? null
                              : "Enter a valid password (at least 7 characters with both uppercase and lowercase letters)";
                        },
                        onChanged: (item) {
                          setState(() {
                            _password = item;
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: "Enter password",
                          labelText: "Password",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.blue,
                              ),
                              onPressed: () {
                                signup();
                              },
                              child: const Text("Register"),
                            ),
                          ),
                          const SizedBox(
                            width: 40,
                          ),
                          const Expanded(
                            child: Text("Login here"),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  void signup() {
    if (_formkey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: _email, password: _password)
          .then((UserCredential user) {
        setState(() {
          isLoading = false;
        });

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (Route<dynamic> route) => false,
        );
      }).catchError((onError) {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(
          msg: "Error: $onError",
          timeInSecForIosWeb: 50,
        );
      });
    }
  }
}
