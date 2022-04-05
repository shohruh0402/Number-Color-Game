import 'package:flutter_bloc/flutter_bloc.dart';

class CountCubit extends Cubit<CountState> {
  CountCubit() : super(CountInitial());

  int count = 15;
  bool start = true;
  int score = 0;

  

  startTimer() async {
    start = false;
    for (var i = count; i > 0; i--) {
      Future.delayed(
        Duration(seconds: i),
      ).then((value) {
        count -= 1;
        if (count == 0) {
          start = true;
          count = 20;
          emit(CountZero());
        }
        emit(CountChange());
      });
    }
  }
}

abstract class CountState {
  CountState();
}

class CountInitial extends CountState {
  CountInitial();
}

class CountChange extends CountState {
  CountChange();
}

class CountZero extends CountState {
  CountZero();
}
