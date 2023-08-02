import 'package:flutter/material.dart';
import 'package:wild_books/about_us_page.dart';
import 'package:wild_books/add_a_book_page.dart';
import 'package:wild_books/book_shelf_page.dart';
import 'package:wild_books/geolocation_test.dart';
import 'package:wild_books/list_of_all_books.dart';
import 'package:wild_books/search_page.dart';
import 'package:wild_books/signin_page.dart';
import 'package:wild_books/home_page.dart';
import 'package:wild_books/map_page.dart';
import 'package:wild_books/theme_controller.dart';
import 'package:wild_books/utils/db.dart';

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
              '/sign-in': (context) => SigninPage(),
              '/about-us': (context) => AboutUs(),
              '/add-book': (context) => AddBook(),
              //'/books-list': (context) => ListOfBooks(),
              '/books-list': (context) => LocationTest(),
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
  int pageIndex = 0;

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
              leading: Icon(Icons.logout),
              title: Text('Log-out'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/home');
              },
            ),
          ]),
        ),
        appBar: AppBar(
          title: const Text(
            'Wild Books',
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/sign-in');
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
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: pageIndex,
            onTap: (index) {
              setState(() {
                pageIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home, size: 30),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.book_rounded, size: 30),
                label: 'Bookshelf',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.map_rounded, size: 30),
                label: 'Map',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search, size: 30),
                label: 'Search',
              ),
            ]),
        body: _pages[pageIndex]);
  }
}
