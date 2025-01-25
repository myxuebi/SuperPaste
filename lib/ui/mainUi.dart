import 'package:flutter/material.dart';
import '../keyboard/hotkey.dart';

// 窗口主界面
class mainUi extends StatelessWidget {
  const mainUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Colors.lightBlue.shade50,
          child: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Title and Description in the upper middle part
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.paste,
                          color: Colors.blueAccent,
                          size: 28,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "SuperPaste-万能粘贴工具",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      "通过键盘模拟的方式对禁止粘贴的程序进行绕过",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ],
                ),
                // Usage Section in the lower middle part
                Column(
                  children: [
                    Text(
                      "使用方法",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "1. 在右侧设置快捷键，单击启动按钮启动程序（留空则为使用默认快捷键）",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "2. 在需要粘贴文字的输入框中，按下快捷键，程序就会自动输入文本",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "3. 若运行中需要修改快捷键，请先点击停止",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "！！！使用之前请切换英文输入法！！！",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )),
        Expanded(
            child: Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: Colors.lightBlue.shade50,
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("设置快捷键：",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    )),
                input_key()
              ],
            ),
          ),
        ))
      ],
    );
  }
}

// 输入框
class input_key extends StatefulWidget {
  const input_key({super.key});

  @override
  State<StatefulWidget> createState() {
    return _input_key();
  }
}

class _input_key extends State<input_key> {
  var key_status = "Ctrl+Shift+V";
  TextEditingController text_key = TextEditingController();
  var btn_icon = const Icon(Icons.play_arrow);
  var btn_text = "应用并启动";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("当前快捷键为：$key_status"),
        const SizedBox(
          height: 20,
        ),
        TextField(
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "请输入快捷键",
              hintText: "例如: Ctrl+Shift+V",
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              )),
          controller: text_key,
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton.icon(
          icon: btn_icon,
          label: Text(btn_text),
          onPressed: () {
            if (btn_text == "应用并启动"){
              String key = text_key.text;
              List<String> key_spl = key.split("+");
              if (2 <= key_spl.length && key_spl.length <= 3) {
                var res = inputHotKey(key_spl);
                if (res == "ok"){
                  setState(() {
                    btn_text = "停止";
                    key_status = key;
                    btn_icon = const Icon(Icons.stop);
                  });
                }else{
                  _showAlertDialog(context, "出现错误", res);
                }
              } else if (key.isEmpty) {
                var res = inputHotKey(["Ctrl","Shift","V"]);
                if (res == "ok"){
                  setState(() {
                    btn_text = "停止";
                    key_status = "Ctrl+Shift+V";
                    btn_icon = const Icon(Icons.stop);
                  });
                }else{
                  _showAlertDialog(context, "出现错误", res);
                }
              } else {
                _showAlertDialog(context, "快捷键输入异常",
                    "需要输入以下格式的快捷键：\n1.长度需要为2个或3个键\n2.只能有一个普通键（A-Z），可以有一个或两个控制键（Ctrl，Shift，Alt）\n3.键与键之间用+号分割\n4.注意区分大小写，普通键全为大写，控制键首字母大写，不能有重复的键\n例如：Ctrl+Shift+V\n\nPs：懒得写按键直接留空点启动即可");
              }
            }else{
              cancelHotKey();
              setState(() {
                btn_text = "应用并启动";
                btn_icon = const Icon(Icons.play_arrow);
              });
            }
          },
        )
      ],
    );
  }
}

Future<void> _showAlertDialog(
    BuildContext context, String title, String content) async {
  await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
                child: const Text(
                  '知道了',
                ),
                onPressed: () {
                  Navigator.pop(context, "取消");
                }),
          ],
        );
      });
}
