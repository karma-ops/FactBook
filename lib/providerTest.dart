import 'dart:async';
import 'package:factbook_info/increment_provider.dart';
import 'package:flutter/material.dart';
import 'package:factbook_info/timer_info.dart';
import 'package:provider/provider.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  dynamic timer;
  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      var timerInfo = Provider.of<TimerInfo>(context, listen: false);
      timerInfo.updateRemainingTime();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('======strated from scratch=======');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.lightBlue.shade100,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  color: Colors.lightGreen.shade100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                          onPressed: () {
                            Provider.of<TimerInfo>(context, listen: false)
                                .stopTimer();
                          },
                          icon: const Icon(Icons.stop_circle_outlined)),
                      Consumer<TimerInfo>(
                        builder: (context, data, child) {
                          return IconButton(
                              onPressed: () {
                                data.timerPaused == true
                                    ? data.startTimer()
                                    : data.pauseTimer();
                              },
                              icon: data.timerPaused == true
                                  ? const Icon(Icons.play_arrow_outlined)
                                  : const Icon(Icons.pause_outlined));
                        },
                      ),
                      const SizedBox(height: 32),
                      Consumer<TimerInfo>(
                        builder: (context, data, child) {
                          return Text(
                              data.getRemainingTime() == 0
                                  ? 'Done'
                                  : data.getRemainingTime().toString(),
                              style: const TextStyle(fontSize: 72));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Consumer<IncrementProvider>(
                        builder: (context, data, child) {
                      return Text(data.initialValue().toString(),
                          style: const TextStyle(fontSize: 42));
                    }),
                    IconButton(
                        onPressed: () {
                          Provider.of<IncrementProvider>(context, listen: false)
                              .increment();
                        },
                        icon: const Icon(Icons.add))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
