import 'package:flutter/material.dart';
import 'package:memoapp/memohome.dart';

//これらのデータをメモリストページにペーストする。

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 58, 13, 136),
        useMaterial3: true,
        fontFamily: 'Noto',
      ),
      home: const MyHomePage(),
    );
  }
}

//テキストを黒文字にする。ラベルテキストを削除する。
//これらのデータをメモリストページにペーストする。


