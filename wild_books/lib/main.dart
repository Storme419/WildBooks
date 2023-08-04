import 'package:flutter/material.dart';
import 'package:wild_books/location_to_city.dart';
import 'package:wild_books/view/about_us_page.dart';
import 'package:wild_books/view/account_page.dart';
import 'package:wild_books/view/add_a_book_page.dart';
import 'package:wild_books/view/book_shelf_page.dart';
import 'package:wild_books/view/list_of_all_books.dart';
import 'package:wild_books/search_page.dart';
import 'package:wild_books/view/home_page.dart';
import 'package:wild_books/view/login_page.dart';
import 'package:wild_books/view/redirect_page.dart';
import 'package:wild_books/view/map_page.dart';
import 'package:wild_books/theme_controller.dart';
import 'package:wild_books/utils/db.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:wild_books/view/profile_page.dart';

Future<void> main() async {
  await initSupabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: ThemeController.instance,
        builder: (context, child) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeController.instance.isDarkTheme
                ? ThemeData.dark()
                : ThemeData.light(),
            debugShowCheckedModeBanner: false,
            //initialRoute: '/home',
            routes: {
              '/home': (context) => HomePage(),
              '/profile-button': (context) => RedirectPage(),
              '/sign-in': (context) => LoginPage(),
              '/add-book': (context) => AddBook(),
              '/about-us': (context) => LocationPage(),
              '/account': (context) => AccountPage(),
              '/books-list': (context) => ListOfBooks(),
              '/profile': (context) => ProfilePage(),
            },
            home: RootPage(),
          );
        });
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const Bookshelf(),
    const Map(),
    const Search(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(children: [
          UserAccountsDrawerHeader(
              currentAccountPicture: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Image.network(
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS29OImDEUJspbdQTIIKTar91MyZ920fD6jpQ&usqp=CAU")),
              accountName: Text("Test User"),
              accountEmail: Text("test@gmail.com")),
          SwitchListTile(
            title: Text('Dark Mode'),
            value: ThemeController.instance.isDarkTheme,
            onChanged: (value) {
              ThemeController.instance.changeTheme();
            },
          ),
          const SizedBox(
            height: 20,
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About Us'),
            onTap: () {
              Navigator.of(context).pushNamed('/about-us');
            },
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('Add a book'),
            onTap: () {
              Navigator.of(context).pushNamed('/add-book');
            },
          ),
          ListTile(
            leading: Icon(Icons.book_rounded),
            title: Text('All Books'),
            onTap: () {
              Navigator.of(context).pushNamed('/books-list');
            },
          ),
          ListTile(
            leading: Icon(Icons.search),
            title: Text('Find Books'),
            onTap: () {
              // Navigator.of(context).pushNamed('/about-us');
            },
          ),
          ListTile(
            leading: Icon(Icons.face),
            title: Text('My Profile'),
            onTap: () {
              Navigator.of(context).pushNamed('/profile');
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Log-out'),
            onTap: () async {
              await supabase.auth.signOut();
              Navigator.of(context).pushNamed('/home');
            },
          ),
        ]),
      ),
      appBar: AppBar(
        title: const Text(
          'W I L D B O O K S',
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/profile-button');
              },
              icon: const Icon(
                Icons.person_2_rounded,
                size: 35,
              ))
        ],
        //     title: Image.asset(
        //   "./images/logo-color.png",
        //   width: 140,
        // )
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        color: Colors.brown.shade800,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: GNav(
            backgroundColor: Colors.brown.shade800,
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.brown,
            padding: EdgeInsets.all(16),
            gap: 8,
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.book_rounded,
                text: 'Bookshelf',
              ),
              GButton(
                icon: Icons.map,
                text: 'Map',
              ),
              GButton(
                icon: Icons.search,
                text: 'Search',
              ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
