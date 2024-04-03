import 'package:movie/features/domain/entity/movie_detail.dart';
import 'package:movie/features/domain/entity/movie_trending.dart';
import 'package:movie/features/domain/entity/movie_trailer.dart';
import 'package:movie/features/domain/entity/people_detail.dart';
import 'package:movie/features/domain/entity/popular_people.dart';


abstract class MovieRepo {
  Future<List<MovieTrending>> getTrendingHome();
  Future<List<MovieTrending>> getTrendingHomeWeek();
  Future<List<MovieTrailer>> getMovieUpcomingTrailer();
  Future<MovieDetail> getMovieDetailById({id, type});
  Future<PeopleDetail> getPeopleDetail({id, type});
  Future<List<MovieTrending>> getFilmByFilter({type, subtype, sort, fromDate, toDate, items, isFilter});
  Future<List<PopularPeople>> getPopularPeople();
  Future<Map<String, List<dynamic>>> getResultSearch({keyword});
}