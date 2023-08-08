import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../components/avatar_img.dart';
import '../utils/db.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _usernameController = TextEditingController();
  final _aboutMeController = TextEditingController();

  String? _avatarUrl;
  var _loading = true;

  /// Called once a user id is received within `onAuthenticated()`
  Future<void> _getProfile() async {
    setState(() {
      _loading = true;
    });

    try {
      final userId = supabase.auth.currentUser!.id;
      final data = await supabase
          .from('profiles')
          .select<Map<String, dynamic>>()
          .eq('id', userId)
          .single();
      _usernameController.text = (data['username'] ?? '') as String;
      _avatarUrl = (data['avatar_url'] ?? '') as String;
      _aboutMeController.text = (data['about_me'] ?? '') as String;
    } on PostgrestException catch (error) {
      SnackBar(
        content: Text(error.message),
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    } catch (error) {
      SnackBar(
        content: const Text('Unexpected error occurred'),
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  /// Called when user taps `Update` button
  Future<void> _updateProfile() async {
    setState(() {
      _loading = true;
    });
    final userName = _usernameController.text.trim();
    final user = supabase.auth.currentUser;
    final aboutMe = _aboutMeController.text.trim();
    final updates = {
      'id': user!.id,
      'username': userName,
      'about_me': aboutMe,
      'updated_at': DateTime.now().toIso8601String(),
    };
    try {
      await supabase.from('profiles').upsert(updates);
      if (mounted) {
        const SnackBar(
          content: Text('Successfully updated profile!'),
        );
      }
    } on PostgrestException catch (error) {
      SnackBar(
        content: Text(error.message),
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    } catch (error) {
      SnackBar(
        content: const Text('Unexpected error occurred'),
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> _signOut() async {
    try {
      await supabase.auth.signOut();
    } on AuthException catch (error) {
      SnackBar(
        content: Text(error.message),
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    } catch (error) {
      SnackBar(
        content: const Text('Unexpected error occurred'),
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    } finally {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    }
  }

  /// Called when image has been uploaded to Supabase storage from within Avatar widget
  Future<void> _onUpload(String imageUrl) async {
    try {
      final userId = supabase.auth.currentUser!.id;
      await supabase.from('profiles').upsert({
        'id': userId,
        'avatar_url': imageUrl,
      });
      if (mounted) {
        const SnackBar(
          content: Text('Updated your profile image!'),
        );
      }
    } on PostgrestException catch (error) {
      SnackBar(
        content: Text(error.message),
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    } catch (error) {
      SnackBar(
        content: const Text('Unexpected error occurred'),
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _avatarUrl = imageUrl;
    });
  }

  @override
  void initState() {
    super.initState();
    _getProfile();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _aboutMeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: Stack(children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 40),
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
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding:
                    const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                children: [
                  Avatar(
                    imageUrl: _avatarUrl,
                    onUpload: _onUpload,
                  ),
                  const SizedBox(height: 18),
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(labelText: 'Username'),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _aboutMeController,
                    decoration: const InputDecoration(labelText: 'About me'),
                  ),
                  const SizedBox(height: 18),
                  ElevatedButton(
                    onPressed: _loading ? null : _updateProfile,
                    style: ElevatedButton.styleFrom(
                        onPrimary: Color.fromARGB(1, 42, 87, 255),
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
                        width: 60,
                        height: 40,
                        alignment: Alignment.center,
                        child: Text(
                          _loading ? 'Saving...' : 'Update',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextButton(
                      onPressed: _signOut, child: const Text('Sign Out')),
                ],
              ),

        // ElevatedButton(
        //   onPressed: () {},
        //   style: ElevatedButton.styleFrom(
        //       onPrimary: Color.fromARGB(1, 42, 87, 255),
        //       shadowColor: Colors.blueGrey,
        //       elevation: 5,
        //       padding: EdgeInsets.zero,
        //       shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(20))),
        //   child: Ink(
        //     decoration: BoxDecoration(
        //         color: Color.fromARGB(1, 42, 87, 255),
        //         borderRadius: BorderRadius.circular(20)),
        //     child: Container(
        //       width: 150,
        //       height: 40,
        //       alignment: Alignment.center,
        //       child: const Text(
        //         'Let\'s go!',
        //         style: TextStyle(
        //           fontSize: 16,
        //           color: Colors.black87,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
      ]),
    );
  }
}

    //   body: _loading
    //       ? const Center(child: CircularProgressIndicator())
    //       : ListView(
    //           padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
    //           children: [
    //             Avatar(
    //               imageUrl: _avatarUrl,
    //               onUpload: _onUpload,
    //             ),
    //             const SizedBox(height: 18),
    //             TextFormField(
    //               controller: _usernameController,
    //               decoration: const InputDecoration(labelText: 'User Name'),
    //             ),
    //             const SizedBox(height: 18),
    //             ElevatedButton(
    //               onPressed: _loading ? null : _updateProfile,
    //               child: Text(_loading ? 'Saving...' : 'Update'),
    //             ),
    //             const SizedBox(height: 18),
    //             TextButton(onPressed: _signOut, child: const Text('Sign Out')),
    //           ],
    //         ),
    // );
