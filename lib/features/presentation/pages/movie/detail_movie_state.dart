import 'package:flutter/cupertino.dart';
import 'package:movie/features/domain/entity/movie_detail.dart';

import '../../../domain/usecase/get_trending_home.dart';

class DetailMovieState with ChangeNotifier {

  late MovieDetail movie;
  GetTrendingHome api;
  int id;
  String type;
  DetailMovieState({required this.api, required this.id, required this.type});
  Future<MovieDetail> fetch() async {
    movie = await api.callDetail(id: id, type: type);
    return movie;
  }
}