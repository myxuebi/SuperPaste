import 'package:flutter/services.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'paste.dart';

void cancelHotKey() async{
  await hotKeyManager.unregisterAll();
}

Future<void> startListenHotKey(List<HotKeyModifier> controlKey,KeyboardKey pkey) async{

  HotKey _hotKey = HotKey(
    key: pkey,
    modifiers: controlKey,
    scope: HotKeyScope.system,
  );

  await hotKeyManager.register(
    _hotKey,
    keyDownHandler: (hotKey) {
      // print('onKeyDown+${hotKey.toJson()}');
      paste();
      },
    // 只在MacOS生效
    keyUpHandler: (hotKey){
      // print('onKeyUp+${hotKey.toJson()}');
      paste();
    } ,
  );

}

String toKey(List<String> hotkey) {
  List<HotKeyModifier> controlKey = [];
  KeyboardKey? pkey;

  for (var i=0;i<hotkey.length;i++){

    var key = hotkey[i];
    switch (key) {
      case 'A':
        pkey = PhysicalKeyboardKey.keyA;
        break;
      case 'B':
        pkey = PhysicalKeyboardKey.keyB;
        break;
      case 'C':
        pkey = PhysicalKeyboardKey.keyC;
        break;
      case 'D':
        pkey = PhysicalKeyboardKey.keyD;
        break;
      case 'E':
        pkey = PhysicalKeyboardKey.keyE;
        break;
      case 'F':
        pkey = PhysicalKeyboardKey.keyF;
        break;
      case 'G':
        pkey = PhysicalKeyboardKey.keyG;
        break;
      case 'H':
        pkey = PhysicalKeyboardKey.keyH;
        break;
      case 'I':
        pkey = PhysicalKeyboardKey.keyI;
        break;
      case 'J':
        pkey = PhysicalKeyboardKey.keyJ;
        break;
      case 'K':
        pkey = PhysicalKeyboardKey.keyK;
        break;
      case 'L':
        pkey = PhysicalKeyboardKey.keyL;
        break;
      case 'M':
        pkey = PhysicalKeyboardKey.keyM;
        break;
      case 'N':
        pkey = PhysicalKeyboardKey.keyN;
        break;
      case 'O':
        pkey = PhysicalKeyboardKey.keyO;
        break;
      case 'P':
        pkey = PhysicalKeyboardKey.keyP;
        break;
      case 'Q':
        pkey = PhysicalKeyboardKey.keyQ;
        break;
      case 'R':
        pkey = PhysicalKeyboardKey.keyR;
        break;
      case 'S':
        pkey = PhysicalKeyboardKey.keyS;
        break;
      case 'T':
        pkey = PhysicalKeyboardKey.keyT;
        break;
      case 'U':
        pkey = PhysicalKeyboardKey.keyU;
        break;
      case 'V':
        pkey = PhysicalKeyboardKey.keyV;
        break;
      case 'W':
        pkey = PhysicalKeyboardKey.keyW;
        break;
      case 'X':
        pkey = PhysicalKeyboardKey.keyX;
        break;
      case 'Y':
        pkey = PhysicalKeyboardKey.keyY;
        break;
      case 'Z':
        pkey = PhysicalKeyboardKey.keyZ;
        break;
      case 'Ctrl':
        controlKey.add(HotKeyModifier.control);
        break;
      case 'Shift':
        controlKey.add(HotKeyModifier.shift);
        break;
      case 'Alt':
        controlKey.add(HotKeyModifier.alt);
        break;
      default:
        return "错误的key参数，请检查格式是否正确\n\n需要输入以下格式的快捷键：\n1.长度需要为2个或3个键\n2.只能有一个普通键（A-Z），可以有一个或两个控制键（Ctrl，Shift，Alt）\n3.键与键之间用+号分割\n4.注意区分大小写，普通键全为大写，控制键首字母大写，不能有重复的键\n例如：Ctrl+Shift+V\n\nPs：懒得写按键直接留空点启动即可";
    };
  }

  if (pkey != null) {
    startListenHotKey(controlKey, pkey);  // 注意这里传入的是 KeyboardKey 类型
    return "ok";
  } else {
    return "没有找到有效的普通键";
  }
}

String inputHotKey(List<String> hotkey) {
  Set<String> uniqueKeys = Set.from(hotkey);
  if (uniqueKeys.length != hotkey.length) {
    return "快捷键中有重复的键。请检查并确保没有重复的键。";
  }

  // 检查控制键和普通键的数量
  int controlKeyCount =
      hotkey.where((key) => ['Ctrl', 'Shift', 'Alt'].contains(key)).length;
  int normalKeyCount = hotkey.length - controlKeyCount;

  if (normalKeyCount == 1 && controlKeyCount <= 2) {
    var res = toKey(hotkey);
    if (res == "ok"){
      return "ok";
    }else{
      return res;
    }
  } else {
    return "需要一个普通键(A-Z)和一个或两个控制键(Ctrl,Shift,Alt)";
  }
}
