import 'package:flutter/material.dart';
import '../utils/db.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/cupertino.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        width: double.infinity,
        decoration:
            BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 100),
              child: const Text(
                "Welcome back!",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: 1,
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50))),
                margin: const EdgeInsets.only(top: 60),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        margin: const EdgeInsets.only(left: 22, bottom: 20),
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black87,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 55,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Color.fromARGB(1, 42, 87, 255),
                                width: 0.5),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.blueGrey,
                                  blurRadius: 5,
                                  offset: Offset(1, 1)),
                            ],
                            color: Colors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(Icons.email_outlined),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(left: 10),
                                child: TextFormField(
                                  controller: _emailController,
                                  maxLines: 1,
                                  decoration: const InputDecoration(
                                    label: Text("Email"),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                          width: double.infinity,
                          height: 55,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 5),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color.fromARGB(1, 42, 87, 255),
                                  width: 0.5),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.blueGrey,
                                    blurRadius: 5,
                                    offset: Offset(1, 1)),
                              ],
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(Icons.password_outlined),
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  child: TextFormField(
                                    controller: _passwordController,
                                    maxLines: 1,
                                    decoration: const InputDecoration(
                                      label: Text("Password"),
                                      border: InputBorder.none,
                                    ),
                                    obscureText: true,
                                  ),
                                ),
                              ),
                            ],
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            final email = _emailController.text.trim();
                            final password = _passwordController.text.trim();
                            await supabase.auth.signInWithPassword(
                              email: email,
                              password: password,
                            );
                            if (mounted) {
                              Navigator.pushNamedAndRemoveUntil(context,
                                  '/account', ModalRoute.withName('/'));
                            }
                          } on AuthException catch (error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(error.message)));
                          } catch (error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Unexpected error occurred')));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            //onPrimary: Color.fromARGB(1, 42, 87, 255),
                            shadowColor: Colors.blueGrey,
                            elevation: 5,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                        child: Ink(
                          decoration: BoxDecoration(
                              color: Color.fromARGB(1, 42, 87, 255),
                              borderRadius: BorderRadius.circular(20)),
                          child: Container(
                            width: 150,
                            height: 40,
                            alignment: Alignment.center,
                            child: const Text(
                              'Let\'s go!',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
