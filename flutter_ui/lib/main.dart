import 'package:flutter/material.dart';
import 'package:flutter_ui/custom_text_field.dart';

void main() => runApp(
      MaterialApp(
        theme: ThemeData(useMaterial3: true),
        debugShowCheckedModeBanner: false,
        home: const CustomWidget(),
      ),
    );

class CustomWidget extends StatelessWidget {
  const CustomWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: CustomContainer(height: 0.4, width: 0.5, color: const Color.fromRGBO(233, 233, 233, 1)),
        ),
      ),
    );
  }
}

class CustomContainer extends StatelessWidget {
  CustomContainer({super.key, this.child, this.height = 1.0, this.width = 1.0, this.color = const Color.fromRGBO(0, 0, 0, 0.7)});
  Color color;
  double height;
  double width;
  Widget? child;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          width: 2.0,
          color: color,
        ),
      ),
      width: MediaQuery.of(context).size.width * width,
      height: MediaQuery.of(context).size.height * height,
      child: child,
    );
  }
}

class ReplayWidget extends StatelessWidget {
  ReplayWidget({super.key});

  final List<Map<String, dynamic>> _replySample = [
    {"id": "해피투게더", "content": "오늘은 좋은날", "num": 1, "depth": 1},
    {"id": "유재석", "content": "안녕하세요?", "num": 2, "depth": 1},
    {"id": "김원희", "content": "반갑습니다.", "num": 3, "depth": 1},
    {"id": "해피투게더", "content": "오늘은 좋은날", "num": 4, "depth": 2},
    {"id": "유재석", "content": "안녕하세요?", "num": 5, "depth": 2},
    {"id": "김원희", "content": "반갑습니다.", "num": 6, "depth": 2},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("댓글영역"),
              CustomTextfield(
                hintText: "댓글을 입력해주세요",
                onTapFunction: () {
                  print("실행");
                },
              ),
              Container(
                width: double.maxFinite,
                height: 500,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: ListView.builder(
                    itemCount: _replySample.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Column(
                          children: [
                            OriginalReply(
                              replySample: _replySample,
                              index: index,
                            ),
                            ReReply(
                              replySample: _replySample,
                              index: index,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ReReply extends StatelessWidget {
  ReReply({super.key, required List<Map<String, dynamic>> replySample, required this.index}) : _replySample = replySample;

  final List<Map<String, dynamic>> _replySample;
  int index;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black),
        ),
      ),
      padding: const EdgeInsets.only(left: 16),
      child: ListTile(
        leading: Text(
          _replySample[index]['id'] as String,
        ),
        title: Text(
          _replySample[index]['content'] as String,
        ),
      ),
    );
  }
}

class OriginalReply extends StatelessWidget {
  OriginalReply({super.key, required List<Map<String, dynamic>> replySample, required this.index}) : _replySample = replySample;

  final List<Map<String, dynamic>> _replySample;
  int index;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black),
        ),
      ),
      child: ListTile(
        leading: Text(
          _replySample[index]['id'] as String,
        ),
        title: Text(
          _replySample[index]['content'] as String,
        ),
      ),
    );
  }
}
