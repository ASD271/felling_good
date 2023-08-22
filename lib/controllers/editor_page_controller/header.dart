import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';

class HeaderNavigationComponent{
  HeaderNavigationComponent(this.quillController);
  final QuillController quillController;
  RxList<Header> headers=<Header>[].obs;
  void updateHeader(){
    headers.value=<Header>[];
    for(var x in quillController.document.root.children){
      print(x);
      print(x.runtimeType);
      print('${x.offset}  ${x.style} ${x.style.attributes['header']?.value}');
      if(x.style.containsKey('header')){
        int value=x.style.attributes['header']!.value;
        int offset=x.offset;
        String text=x.toPlainText();
        headers.add(Header(text, value, offset));
      }
    }
  }
  int get length=>headers.length;
}

class Header{
  String text;
  int value;
  int offset;
  Header(this.text,this.value,this.offset);
}