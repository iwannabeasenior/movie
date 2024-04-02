
import 'package:flutter/material.dart';
import 'package:movie/features/domain/entity/movie_trending.dart';
import 'package:movie/features/presentation/pages/movie/item.dart';

import '../../../domain/usecase/get_trending_home.dart';

class MoviePageState with ChangeNotifier {
  bool isFilter = false;
  String type;
  GetTrendingHome api;
  List<MovieTrending> films = [];
  List<ItemPick> itemsMovie = [
    ItemPick(name: 'Action', picked: false, id: 28),
    ItemPick(name: 'Adventure', picked: false, id: 12),
    ItemPick(name: 'Animation', picked: false, id: 16),
    ItemPick(name: 'Comedy', picked: false, id: 35),
    ItemPick(name: 'Crime', picked: false, id: 80),
    ItemPick(name: 'Documentary', picked: false, id: 99),
    ItemPick(name: 'Drama', picked: false, id: 18),
    ItemPick(name: 'Family', picked: false, id: 10751),
    ItemPick(name: 'Fantasy', picked: false, id: 14),
    ItemPick(name: 'History', picked: false, id: 36),
    ItemPick(name: 'Horror', picked: false, id: 27),
    ItemPick(name: 'Music', picked: false, id: 10402),
    ItemPick(name: 'Mystery', picked: false, id: 9648),
    ItemPick(name: 'Romance', picked: false, id: 10749),
    ItemPick(name: 'Science Fiction', picked: false, id: 878),
    ItemPick(name: 'TV Movie', picked: false, id: 10770),
    ItemPick(name: 'Thriller', picked: false, id: 53),
    ItemPick(name: 'War', picked: false, id: 10752),
    ItemPick(name: 'Western', picked: false, id: 37),
  ];
  List<ItemPick> itemsTVShows = [
    ItemPick(name: 'Action & Adventure', picked: false, id: 10759),
    ItemPick(name: 'Animation', picked: false, id: 16),
    ItemPick(name: 'Comedy', picked: false, id: 35),
    ItemPick(name: 'Crime', picked: false, id: 80),
    ItemPick(name: 'Documentary', picked: false, id: 99),
    ItemPick(name: 'Drama', picked: false, id: 18),
    ItemPick(name: 'Family', picked: false, id: 10751),
    ItemPick(name: 'Kids', picked: false, id: 10762),
    ItemPick(name: 'Mystery', picked: false, id: 9648),
    ItemPick(name: 'News', picked: false, id: 10763),
    ItemPick(name: 'Reality', picked: false, id: 10764),
    ItemPick(name: 'Sci-Fi & Fantasy', picked: false, id: 10765),
    ItemPick(name: 'Soap', picked: false, id: 10766),
    ItemPick(name: 'Talk', picked: false, id: 10767),
    ItemPick(name: 'War & Politics', picked: false, id: 10768),
    ItemPick(name: 'Western', picked: false, id: 37),
  ];
  String fromDate = '';
  String toDate = DateTime.now().toString().substring(0, 10);
  String subtype = 'Popular';
  String sort = 'Popularity Descending';
  String items = '';
  MoviePageState({required this.type, required this.api});

  Future<void> search() async {
    // xu ly sort,

    if (type == 'movie') {
      items = itemsMovie.where((element) => element.picked).map((e) => e.id).join(',');
    } else {
      items = itemsTVShows.where((element) => element.picked).map((e) => e.id).join(',');
    }
    String? subtypePass = switch(subtype) {
      'Popular' => 'popular',
      'Now Playing' => 'now_playing',
      'Top Rated' => 'top_rated',
      'Upcoming' => 'upcoming',
      'Airing Today' => 'airing_today',
      'On TV' => 'on_the_air',
      _ => null,
    };
    var sortPass = switch(sort) {
      'Popularity Descending' => 'popularity.desc',
      'Popularity Ascending' => 'popularity.asc',
      'Rating Descending' => 'vote_average.desc',
      'Rating Ascending' => 'vote_average.asc',
      'Release Date Descending' => 'primary_release_date.desc',
      'Release Date Ascending' => 'primary_release_date.asc',
      '(Title)A-Z' => 'title.asc',
      '(Title)Z-A' => 'title.desc',
      _ => null
    };
    films = await api.getFilm(sort: sortPass, subtype: subtypePass, fromDate: fromDate, toDate: toDate, type: type, items: items, isFilter: isFilter);
    notifyListeners();
  }
}