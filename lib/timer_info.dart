// import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';

class TimerInfo extends ChangeNotifier {
  int _remainingTime = 10;
  int getRemainingTime() => _remainingTime;
  bool timerStopped = true;
  bool timerPaused = true;

  updateRemainingTime() {
    if (timerStopped == false &&
        timerPaused == false &&
        getRemainingTime() != 0) {
      _remainingTime--;
    } else if (timerStopped == true) {
      stopTimer();
    } else if (timerPaused == true) {
      pauseTimer();
    }
    notifyListeners();
  }

  stopTimer() {
    _remainingTime = 10;
    timerStopped = true;
    timerPaused = true;
    notifyListeners();
  }

  startTimer() {
    timerPaused = false;
    timerStopped = false;
    notifyListeners();
  }

  pauseTimer() {
    timerPaused = true;
    timerStopped = false;
    notifyListeners();
  }
}
