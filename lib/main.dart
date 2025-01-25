import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'ui/mainUi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
      size: Size(1200, 800), center: true, titleBarStyle: TitleBarStyle.hidden,title: "SuperPaste");

  windowManager.waitUntilReadyToShow(windowOptions, () {});
  await hotKeyManager.unregisterAll();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const DargMoveWindow(),
        ),
        body: const mainUi(),
      ),
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.blue,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.blue,
        ),
      )
    );
  }
}

// 标题窗口拖动逻辑
class DargMoveWindow extends StatelessWidget {
  const DargMoveWindow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: GestureDetector(
            onPanStart: (d) async {
              await windowManager.startDragging();
            },
            onDoubleTap: () {
              changeWindowStat();
            },
            child: Container(
              color: Colors.transparent,
              alignment: Alignment.centerLeft,
              child: const Text("SuperPaste"),
            ),
          ),
        ),
        const controlWindow(),
      ],
    );
  }
}

// 监听窗口切换状态
class _WindowEventListener with WindowListener {
  final Function() onEventCallback;

  _WindowEventListener(this.onEventCallback);

  @override
  void onWindowMaximize() => onEventCallback();

  @override
  void onWindowUnmaximize() => onEventCallback();

  @override
  void onWindowMinimize() => onEventCallback();

  @override
  void onWindowRestore() => onEventCallback();
}

// 最大化窗口化切换
Future<void> changeWindowStat() async {
  bool isMaximized = await windowManager.isMaximized();
  bool isMinimized = await windowManager.isMinimized();

  if (isMinimized) {
    windowManager.maximize();
  } else if (isMaximized) {
    windowManager.unmaximize();
  } else {
    windowManager.maximize();
  }
}

// 窗口控制组件
class controlWindow extends StatefulWidget {
  const controlWindow({super.key});

  @override
  State<StatefulWidget> createState() {
    return _controlWindow();
  }
}

class _controlWindow extends State<controlWindow> {
  var maiIcon = const Icon(Icons.crop_square);
  late final WindowListener _windowListener;

  // 启动监听器
  @override
  void initState() {
    super.initState();
    _windowListener = _WindowEventListener(() {
      _updateWindowState();
    });
    windowManager.addListener(_windowListener);
    _updateWindowState();
  }

  @override
  void dispose() {
    // 移除监听器
    windowManager.removeListener(_windowListener);
    super.dispose();
  }

  // 更新图标状态
  Future<void> _updateWindowState() async {
    bool isMaximized = await windowManager.isMaximized();
    bool isMinimized = await windowManager.isMinimized();

    setState(() {
      if (isMinimized) {
        maiIcon = const Icon(Icons.crop_square);
      } else if (isMaximized) {
        maiIcon = const Icon(Icons.fullscreen_exit);
      } else {
        maiIcon = const Icon(Icons.crop_square);
      }
    });
  }

  // 窗口控制三大金刚？
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
            onPressed: () {
              windowManager.minimize();
            },
            icon: const Icon(Icons.minimize)),
        IconButton(onPressed: changeWindowStat, icon: maiIcon),
        IconButton(
            onPressed: () {
              windowManager.close();
            },
            icon: const Icon(Icons.close)),
      ],
    );
  }
}
