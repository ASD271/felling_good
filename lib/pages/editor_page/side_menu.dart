import 'package:flutter/material.dart';
import 'package:felling_good/controllers/controllers.dart';

class SideMenu extends StatelessWidget {
  EditorController get editorController => GetInstance().find<EditorController>();
  const SideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const itemStyle = TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );
    editorController.headerNavigationComponent.updateHeader();
    print('build');
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Divider(
          thickness: 2,
          color: Colors.white,
          indent: size.width * 0.1,
          endIndent: size.width * 0.1,
        ),
        Expanded(
          child: Obx(
                () => ListView.builder(
                itemCount: editorController.headerNavigationComponent.length,
                itemBuilder: (context, index) {
                  Header header = editorController.headerNavigationComponent.headers[index];
                  return TextButton(
                      onPressed: () {
                        editorController.moveToPosition(header.offset,
                            extentOffset: header.offset + header.text.length);
                        Navigator.pop(context);
                      },
                      child: Text(
                        header.text,
                        style: TextStyle(fontSize: header.value == 1 ? 24 : 16),
                      ));
                }),
          ),
        ),
        // ListTile(
        //   title: const Center(child: Text('hello nav', style: itemStyle)),
        //   dense: true,
        //   visualDensity: VisualDensity.compact,
        //   onTap: _readOnly,
        // ),
        Divider(
          thickness: 2,
          color: Colors.white,
          indent: size.width * 0.1,
          endIndent: size.width * 0.1,
        ),
      ],
    );
  }
}
