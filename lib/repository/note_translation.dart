import 'package:get/get.dart';
class NoteTranslation extends Translations{
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US':{
    },
    'zh_CN':{
      'sort':'排序',
      'default':'默认',
      'createTime':'创建时间',
      'updateTime':'更新时间',

      'delete':'删除',
      'alert':'警告',
      'Are you sure to delete this directory?,here are @dirNum directories and @noteNum notes':
          '你确定删除该文件夹吗，文件夹下有@dirNum个文件，以及@noteNum个笔记',
      'cancel':'取消',
      'confirm':'确认',
      'history record':'历史记录',
      'change':'修改',
    }
  };

}