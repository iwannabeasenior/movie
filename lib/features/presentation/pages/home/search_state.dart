
import 'package:flutter/material.dart';

import '../../../domain/entity/movie_trending.dart';
import '../../../domain/entity/popular_people.dart';
import '../../../domain/usecase/get_trending_home.dart';

enum Type {
  Movie, TVShows, People
}
class SearchState with ChangeNotifier {
  String keyword;
  List<dynamic> people = [];
  List<dynamic> movie = [];
  List<dynamic> tv = [];
  Type state = Type.Movie;
  GetTrendingHome api;
  SearchState({required this.api, required this.keyword});
  void search({keyword}) async {
    var data = await api.getResultSearch(keyword: keyword);
    people = data['person']!;
    movie = data['movie']!;
    tv = data['tv']!;
    print(movie.length);
    // print('aaaa : ${movie[0].title}');
    notifyListeners();
  }
  void changeState(Type newState) {
    state = newState;
    notifyListeners();
  }
}