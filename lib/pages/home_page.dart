import 'package:felling_good/controllers/home_page_controller.dart';
import 'package:felling_good/pages/note_select_page/note_select_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  HomePageController get homePageController => GetInstance().find<HomePageController>();
  @override
  Widget build(BuildContext context) {
    return NoteSelectPage();
  }
}
