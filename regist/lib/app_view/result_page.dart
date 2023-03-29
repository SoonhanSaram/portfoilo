import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:regist/viewmodel/booked_view_model.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    var bookedViewModel = context.read<BookedViewModel>();
    if (bookedViewModel.sdate.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("예약정보 확인"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            infoCard(content: "${bookedViewModel.user}님의 예약정보입니다"),
            infoCard(content: "예약일 : ${bookedViewModel.resDate} 일"),
            infoCard(content: "예약시간 : ${bookedViewModel.resTime}"),
            infoCard(
                content:
                    "출발지 :   ${bookedViewModel.from} \n도착지 :   ${bookedViewModel.destination}"),
            infoCard(content: "이용차량 ${bookedViewModel.transport}"),
            infoCard(content: "요금은 ${bookedViewModel.fee}원입니다"),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width * 0.8,
                    maxHeight: MediaQuery.of(context).size.width * 0.8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        dotenv.env["CANCEL"]!,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                    ),
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("예약 완료"),
                              content: const Text("예약을 완료하시겠습니까?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    bookedViewModel.infoSaveFunc(
                                        bookedViewModel.reserInfomation!);
                                    print(bookedViewModel.reserInfomation);
                                    Navigator.pushNamedAndRemoveUntil(
                                        context, "/menu", (route) => false);
                                  },
                                  child: const Text("완료"),
                                )
                              ],
                            );
                          },
                        );
                      },
                      child: Text(
                        dotenv.env["SAVE"]!,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("예약정보 확인"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          infoCard(content: "${bookedViewModel.user}님의 예약정보입니다"),
          infoCard(content: "예약일 : ${bookedViewModel.resDate} 일"),
          infoCard(content: "예약시간 : ${bookedViewModel.resTime}"),
          infoCard(
              content:
                  "출발지 :   ${bookedViewModel.from} \n도착지 :   ${bookedViewModel.destination}"),
          infoCard(content: "이용차량 ${bookedViewModel.transport}"),
          infoCard(content: "요금은 ${bookedViewModel.fee}원입니다"),
          Padding(
              padding: const EdgeInsets.all(12.0),
              child: ConstrainedBox(
                  constraints: BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width * 0.8,
                      maxHeight: MediaQuery.of(context).size.width * 0.8),
                  child: TextButton(
                    onPressed: () {
                      bookedViewModel.resetReserInfoWithoutUser();
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "확인",
                      style: TextStyle(fontSize: 24),
                    ),
                  )))
        ],
      ),
    );
  }

  Card infoCard({required String content}) {
    return Card(
        elevation: 2,
        child: Text(
          content,
          style: const TextStyle(fontSize: 24),
        ));
  }
}
