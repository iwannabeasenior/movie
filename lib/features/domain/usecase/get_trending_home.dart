import 'package:movie/features/domain/entity/movie_detail.dart';
import 'package:movie/features/domain/entity/movie_trending.dart';
import 'package:movie/features/domain/entity/movie_trailer.dart';
import 'package:movie/features/domain/entity/popular_people.dart';
import 'package:movie/features/domain/repositories/movie_repo.dart';

import '../entity/people_detail.dart';

class GetTrendingHome {
  MovieRepo repo;
  GetTrendingHome({required this.repo});
  Future<List<MovieTrending>> callToday() async {
    return await repo.getTrendingHome();
  }
  Future<List<MovieTrending>> callThisWeek() async {
    return await repo.getTrendingHomeWeek();
  }
  Future<List<MovieTrailer>> callTrailer() async {
    return await repo.getMovieUpcomingTrailer();
  }
  Future<MovieDetail> callDetail({id, type}) async {
    return await repo.getMovieDetailById(id: id, type: type);
  }
  Future<PeopleDetail> callPeopleDetail({id, type}) async {
    return await repo.getPeopleDetail(id: id, type: type);
  }
  Future<List<MovieTrending>> getFilm({type, subtype, sort, fromDate, toDate, items, isFilter}) async {
    return await repo.getFilmByFilter(type: type, subtype: subtype, sort: sort, fromDate: fromDate, toDate: toDate, items: items, isFilter: isFilter);
  }
  Future<List<PopularPeople>> getPopularPeople() async {
    return await repo.getPopularPeople();
  }
}