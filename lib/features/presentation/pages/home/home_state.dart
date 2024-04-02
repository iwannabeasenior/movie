import 'package:flutter/material.dart';

enum TrendingState {
  Day,
  Week,
}
enum TrailerState {
  Popular,
  InTheater,
}
class HomeState extends ChangeNotifier {
  TrendingState stateTrending = TrendingState.Day;
  TrailerState stateTrailer  = TrailerState.Popular;

  void changeTrendingState() {
    if (stateTrending == TrendingState.Day) {
      stateTrending = TrendingState.Week;
    } else {
      stateTrending = TrendingState.Day;
    }
    notifyListeners();
  }

  void changeTrailerState() {
    if (stateTrailer == TrailerState.Popular) {
      stateTrailer = TrailerState.InTheater;
    } else {
      stateTrailer = TrailerState.Popular;
    }
    notifyListeners();
  }
}