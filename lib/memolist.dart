import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MemoListPage extends StatefulWidget {
  const MemoListPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MemoListPageState createState() => _MemoListPageState();
}

class _MemoListPageState extends State<MemoListPage> {
  List<bool> isExpandedList = [];
  List<TextEditingController> controllers = [];

  @override
  void initState() {
    super.initState();
    loadTextData();
  }

  Future<void> loadTextData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> textDataList = prefs.getStringList('textDataList') ?? [];

    setState(() {
      isExpandedList = List.generate(textDataList.length, (index) => false);
      controllers = List.generate(
        textDataList.length,
        (index) => TextEditingController(text: textDataList[index]),
      );
    });
  }

  Future<void> saveTextData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> textDataList =
        controllers.map((controller) => controller.text).toList();
    prefs.setStringList('textDataList', textDataList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expandable Text Fields'),
      ),
      body: ListView.builder(
        itemCount: isExpandedList.length,
        itemBuilder: (context, index) {
          return buildSlidableTextField(index);
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              setState(() {
                isExpandedList.add(false);
                controllers.add(TextEditingController());
              });
            },
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                isExpandedList =
                    List.generate(controllers.length, (index) => false);
              });
            },
            child: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }

  void removeItem(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('text_$index');

    setState(() {
      isExpandedList.removeAt(index);
      controllers.removeAt(index);
    });
  }

  Widget buildSlidableTextField(int index) {
    double screenHeight = MediaQuery.of(context).size.height;
    int maxLines = (screenHeight / 40).round();
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            onPressed: (context) async {
              removeItem(index);
            },
            backgroundColor: Colors.red,
            icon: Icons.delete,
          ),
        ],
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            isExpandedList[index] = !isExpandedList[index];
          });
        },
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.purple),
            borderRadius: BorderRadius.circular(0.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //テキストを黒文字にする。ラベルテキストを削除する。

              Text(
                controllers[index].text.isNotEmpty
                    ? '${controllers[index].text.substring(0, 5)} '
                    : 'メモ ${index + 1}',
              ),

              if (isExpandedList[index])
                TextField(
                  controller: controllers[index],
                  maxLines: maxLines,
                  onChanged: (text) {
                    saveTextData();
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
