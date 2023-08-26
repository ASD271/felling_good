import 'package:felling_good/pages/editor_page/editor_page.dart';
import 'package:felling_good/repository/note_repository.dart';
import 'package:felling_good/repository/note_translation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'controllers/controllers.dart';

import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var noteRepository=NoteRepository();
  await noteRepository.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FG',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        cardColor: Colors.yellow,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'NotoSansSC',
        canvasColor: Color.fromRGBO(255,251,240,1.0),
        iconTheme: IconThemeData(color: Colors.black)
      ),
      darkTheme: ThemeData.dark().copyWith(primaryColor: Colors.black38),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      translations: NoteTranslation(),
      locale: Locale('zh','CN'),
      // supportedLocales: [
      //   const Locale('en', 'US'),
      //   const Locale('zh', 'HK'),
      //   const Locale('zh', 'CN'),
      // ],
      initialBinding: Bind(),
      initialRoute: '/home',
      getPages: [GetPage(name: '/home', page: ()=>HomePage())],

    );
  }
}
