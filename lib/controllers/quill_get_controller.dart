import 'package:felling_good/controllers/controllers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:note_database/note_database.dart';

import '../universal_ui/universal_ui.dart';
import '../widgets/opinion_embed_widget.dart';
import '../widgets/time_stamp_embed_widget.dart';

class QuillGetController extends GetxController{
  final List<EmbedBuilder> embedBuilders=[
    TimeStampEmbedBuilderWidget(),
    OpinionEmbedWidgetBuilderWidget()
  ];
  NotebookController get notebookController => GetInstance().find<NotebookController>();
  void onInit() async {
    super.onInit();
    if (kIsWeb) {
      for (var element in defaultEmbedBuildersWeb) {
        embedBuilders.add(element);
      }
    } else {
      FlutterQuillEmbeds.builders().forEach((element) {
        embedBuilders.add(element);
      });
    }
  }

  void insertEmbedFromJson(Map<String,dynamic> json){
    if(json.containsKey('opinion')) {
      notebookController.addOpinion(Opinion.fromJsonString(json['opinion']));
    }
  }
  void embedDeleteCallback(List<String> embeds){
    for(var embed in embeds){
      if(embed.startsWith('opinion')){
        var json=embed.split('|')[1];
        Opinion opinion=Opinion.fromJsonString(json);
        notebookController.deleteOpinion(opinion);
        print('delete opinion ${opinion.content}');
      }
    }
  }
  void embedInsertCallback(List<String> embeds){
    for(var embed in embeds){
      if(embed.startsWith('opinion')){
        var json=embed.split('|')[1];
        Opinion opinion=Opinion.fromJsonString(json);
        notebookController.addOpinion(opinion);
        print('add opinion ${opinion.content}');
      }
    }
  }
}