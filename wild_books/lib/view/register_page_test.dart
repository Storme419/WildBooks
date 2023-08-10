import 'package:flutter/material.dart';
import '../utils/db.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: BoxDecoration(
                image: DecorationImage(
                  alignment: Alignment(0, 1),
                  fit: BoxFit.fill,
                  image: AssetImage("lib/images/signin2.png"),
                ),
              ),
            ),
            Positioned(
                bottom: 80.0,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Hey there!",
                              style: TextStyle(
                                height: 1.4,
                                fontSize: 30.0,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                          child: Column(
                        children: [
                          TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                hintText: "Email",
                                suffixIcon: Icon(Icons.email_rounded),
                              )),
                          SizedBox(
                            height: 15.0,
                          ),
                          TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: "Password",
                              )),
                          SizedBox(
                            height: 25.0,
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                try {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  final email = _emailController.text.trim();
                                  final password =
                                      _passwordController.text.trim();
                                  await supabase.auth.signUp(
                                    email: email,
                                    password: password,
                                  );
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text('Check your inbox.')));
                                  }
                                } on AuthException catch (error) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(error.message)));
                                } catch (error) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Unexpected error occurred')));
                                }
                                if (mounted) {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                              },
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: Center(
                                          child: CircularProgressIndicator(
                                              color: Colors.white)),
                                    )
                                  : const Text('Let\'s go!',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black87,
                                      ))),
                          SizedBox(height: 16),
                          TextButton(
                            onPressed: () =>
                                Navigator.of(context).pushNamed('/sign-in'),
                            child: Text('I already have an account'),
                          )
                        ],
                      ))
                    ],
                  ),
                )),
          ]),
        ),
      ),
    );
  }
}
