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

void main() {
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
      body: _pages[pageIndex],

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
