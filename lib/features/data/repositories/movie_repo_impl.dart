import 'package:movie/features/data/source/api/data_api.dart';
import 'package:movie/features/domain/entity/movie_detail.dart';
import 'package:movie/features/domain/entity/movie_trending.dart';
import 'package:movie/features/domain/entity/movie_trailer.dart';
import 'package:movie/features/domain/entity/people_detail.dart';
import 'package:movie/features/domain/entity/popular_people.dart';
import 'package:movie/features/domain/repositories/movie_repo.dart';
class MovieRepoImpl implements MovieRepo {
  MovieApi api;
  MovieRepoImpl({required this.api});
  @override
  Future<List<MovieTrending>> getTrendingHome() async {
    return await api.getTrendingHome();
  }

  @override
  Future<List<MovieTrending>> getTrendingHomeWeek() async {
    return await api.getTrendingHomeWeek();
  }

  @override
  Future<List<MovieTrailer>> getMovieUpcomingTrailer() async {
    return await api.getTrailerHome();
  }

  @override
  Future<MovieDetail> getMovieDetailById({id, type}) async {
    return await api.getMovieDetail(id: id, type: type);
  }

  @override
  Future<PeopleDetail> getPeopleDetail({id, type}) async {
    return await api.getPeopleDetail(id: id, type: type);
  }

  @override
  Future<List<MovieTrending>> getFilmByFilter({type, subtype, sort, fromDate, toDate, items, isFilter}) async {
    return await api.getFilmFilter(type: type, subtype: subtype, sort: sort, fromDate: fromDate, toDate: toDate, items: items, isFilter: isFilter);
  }

  @override
  Future<List<PopularPeople>> getPopularPeople() async {
    return await api.getPopularPeople();
  }

}
