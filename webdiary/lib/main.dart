// Imports

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:webdiary/get_started_page.dart';
import 'package:webdiary/screens/login_page.dart';
import 'package:webdiary/screens/page_not_found.dart';
import 'models/diary.dart';
import 'screens/main_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

// App run
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

// Stateless Widget to create app
class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  final userDiaryDataStream =
      FirebaseFirestore.instance.collection('diaries').snapshots()
          // ignore: top_level_function_literal_block
          .map((diaries) {
    return diaries.docs.map((diary) {
      return Diary.fromDocument(diary);
    }).toList();
  });
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider(
            create: (context) => FirebaseAuth.instance.idTokenChanges(),
            initialData: null),
        StreamProvider<List<Diary>>(
            create: (context) => userDiaryDataStream, initialData: [])
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Diary Book',
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          primarySwatch: Colors.purple,
        ),
        initialRoute: '/',
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) {
              return RouteController(settingsName: settings.name!);
            },
          );
        },
        onUnknownRoute: (settings) => MaterialPageRoute(
          builder: (context) => PageNotFound(),
        ),
        //home: TesterApp(),
      ),
    );
  }
}

class TesterApp extends StatelessWidget {
  const TesterApp({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    CollectionReference booksCollection =
        FirebaseFirestore.instance.collection('diaries');
    return Scaffold(
        appBar: AppBar(
          title: Text('Main Page'),
        ),
        body: Center(
          child: StreamBuilder<QuerySnapshot>(
            stream: booksCollection.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final bookListStream = snapshot.data!.docs.map((book) {
                return Diary.fromDocument(book);
              }).toList();
              for (var item in bookListStream) {
                print(item.entry!);
              }
              return ListView.builder(
                itemCount: bookListStream.length,
                itemBuilder: (context, index) {
                  return Text(bookListStream[index].entry!);
                },
              );
            },
          ),
        ));
  }
}

class RouteController extends StatelessWidget {
  final String settingsName;

  const RouteController({Key? key, required this.settingsName})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final userSignedIn = Provider.of<User?>(context) != null;
    print(settingsName);

    final signedInGotoMain = userSignedIn && settingsName == '/main';
    final notSignedInGotoMain = !userSignedIn && settingsName == '/main';

    if (settingsName == '/') {
      return GettingStartedPage();
    } else if (settingsName == '/main' || notSignedInGotoMain) {
      return MyLoginPage();
    } else if (settingsName == '/login' || notSignedInGotoMain) {
      return MyLoginPage();
    } else if (signedInGotoMain) {
      return MyMainPage();
    } else {
      return PageNotFound();
    }
  }
}
