import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:movie/features/data/models/movie_treding_model.dart';
import 'package:http/http.dart' as http;
import 'package:movie/features/data/models/movie_trailer_model.dart';
import 'package:movie/features/data/models/popular_people_model.dart';
import 'package:movie/helper/constant.dart';

import '../../../../helper/format_birthday.dart';
import '../../../../helper/format_day.dart';
import '../../../domain/entity/cast.dart';
import '../../../domain/entity/movie_cast.dart';
import '../../models/movie_detail_model.dart';
import '../../models/people_detail.dart';

abstract class MovieApi {
  Future<List<MovieTrendingModel>> getTrendingHome();
  Future<List<MovieTrendingModel>> getTrendingHomeWeek();
  Future<List<MovieTrailerModel>> getTrailerHome();
  Future<MovieDetailModel> getMovieDetail({id, type});
  Future<PeopleDetailModel> getPeopleDetail({id, type});
  Future<List<MovieTrendingModel>> getFilmFilter({type, subtype, sort, fromDate, toDate, items, isFilter});
  Future<List<PopularPeopleModel>> getPopularPeople();
}

class MovieApiImpl implements MovieApi {
  Logger logger = Logger();
  @override
  Future<List<MovieTrendingModel>> getTrendingHome() async {
    List<MovieTrendingModel> list = [];
    try {
      final url = Uri.https('api.themoviedb.org', '/3/trending/all/day',
      {
        'language': 'en-US'
      });
      final response = await http.get(url, headers: Constant.header);
      final data = jsonDecode(response.body);
      for (var item in data['results']) {
        list.add(MovieTrendingModel(
          type: item['media_type'] ?? '-',
          title: item['title'] ?? item['name'],
          backdropPath: item['backdrop_path'] ?? '',
          id: item['id'] ?? 0,
          posterPath: item['poster_path'] ?? '',
          voteAverage: item['vote_average'] ?? 0,
          releaseDate: formatDay(item['release_date']) ?? formatDay(item['first_air_date'])
        ));
      }
    } catch(e) {
      logger.d(e);
    }
    return list;
  }

  @override
  Future<List<MovieTrendingModel>> getTrendingHomeWeek() async {
    List<MovieTrendingModel> list = [];
    try {
      final url = Uri.https('api.themoviedb.org', '/3/trending/all/week',
          {
            'language': 'en-US'
          });
      final response = await http.get(url, headers: Constant.header);
      final data = jsonDecode(response.body);
      for (var item in data['results']) {
        list.add(MovieTrendingModel(
          type: item['media_type'] ?? '-',
          title: item['title'] ?? item['name'],
          backdropPath: item['backdrop_path'] ?? '',
          id: item['id'] ?? 0,
          posterPath: item['poster_path'] ?? '',
          voteAverage: item['vote_average'] ?? 0,
            releaseDate: formatDay(item['release_date']) ?? formatDay(item['first_air_date'])
        ));
      }
    } catch(e) {
      logger.d(e);
    }
    return list;
  }

  @override
  Future<List<MovieTrailerModel>> getTrailerHome() async {
    List<MovieTrailerModel> list = [];
    try{
      final url = Uri.https('api.themoviedb.org', '/3/movie/upcoming');
      final response = await http.get(url, headers: Constant.header);
      final data = jsonDecode(response.body);
      for (var item in data['results']) {
        var id = item['id'];
        final subUrl = Uri.https('api.themoviedb.org', '/3/movie/$id/videos');
        final subResponse = await http.get(subUrl, headers: Constant.header);
        final subData = jsonDecode(subResponse.body);
        var trailer;
        for (var video in subData['results']) {
          if (video['type'] == 'Trailer') {
            trailer = video;
          }
        }
        list.add(
            MovieTrailerModel(
                title: item['title'] ?? '',
                key: trailer['key'] ?? '',
                titleTrailer: trailer['name'] ?? '',
                path: item['backdrop_path'] ?? '',
            )
        );
      }
    } catch(e) {
      logger.d(e);
    }
    return list;
  }

  @override
  Future<MovieDetailModel> getMovieDetail({id, type}) async {
    MovieDetailModel movie = MovieDetailModel();
    try {
        final url = Uri.https('api.themoviedb.org', '/3/$type/$id');
        final response = await http.get(url, headers: Constant.header);
        final data = jsonDecode(response.body);
        movie.id = data['id'];
        movie.status = data['status'] ?? '-';
        movie.title = data['title'] ?? '-';
        movie.vote = data['vote_average'] ?? 0;
        movie.postPath = data['poster_path'] ?? '-';
        movie.backdropPath = data['backdrop_path'] ?? '-';
        movie.originalLanguage = data['original_language'] ?? '-';
        movie.revenue = data['revenue']?.toString() ?? '-';
        movie.budget = data['budget']?.toString() ?? '-';
        movie.overview = data['overview'] ?? '-';
        movie.runTime = data['runtime'] ?? 0;
        movie.tagLine = data['tagline'] ?? '-';
        movie.releaseDate = data['release_date'] ?? data['first_air_date'];
        movie.releaseDate ??= '-';
        movie.genres = data['genres']?.where((e) => e['name'] != null).map((e) => e['name']).join(', ') ?? '-';
        movie.genres ??= '-';

        movie.type = data['type'] ?? '-';
        movie.network = data['networks']?.where((e) => e['name'] != null).map((e) => e['name']).join(', ') ?? '-';
        // movie.pathNetwork = data['networks']?.map((e) => e['logo_path']).toList();
        final urlVideo = Uri.https('api.themoviedb.org', '/3/$type/$id/videos');
        final responseVideo = await http.get(urlVideo, headers: Constant.header);
        final dataVideo = jsonDecode(responseVideo.body);
        movie.videos = [];
        bool setTrailer = false;
        for (var item in dataVideo['results']) {
          if (item['type'] == 'Trailer' && !setTrailer) {
            movie.trailer = item['key'];
            setTrailer = true;
          }
          movie.videos!.add(MovieTrailerModel(title: item['name'] ?? 'Unknown', key: item['key'] ?? 0, titleTrailer: '', path: data['backdrop_path'] ?? '-'));
        }
        movie.trailer ??= '-';
        final urlCast = Uri.https('api.themoviedb.org', '/3/$type/$id/credits');
        final responseCast = await http.get(urlCast, headers: Constant.header);
        final dataCast = jsonDecode(responseCast.body);
        if (type == 'movie') {
          for (var item in dataCast['crew']) {
            if (item['job'] == "Director") {
              movie.director = item['name'];
              break;
            }
          }
        }
        else {
          for (var item in dataCast['crew']) {
            if (item['job'] == "Creator") {
              movie.director = item['name'];
              break;
            }
          }
        }
        movie.director ??= '-';
        int count = 0;
        movie.casts = [];
        for (var item in dataCast['cast']) {
          movie.casts!.add(Cast(
              id: item['id'],
              image: item['profile_path'] ?? '',
              name: item['name'] ?? 'Unknown',
              character: item['character'] ?? 'Unknown'
          ));
          count++;
          if (count == 10) break;
        }

    } catch(e) {
      logger.d(e);
    }
    return movie;
  }

  @override
  Future<PeopleDetailModel> getPeopleDetail({id, type}) async {
    PeopleDetailModel people = PeopleDetailModel();
    try {
      final url = Uri.https('api.themoviedb.org', '/3/person/$id');
      final response = await http.get(url, headers: Constant.header);
      final data = jsonDecode(response.body);
      people.profilePath = data['profile_path'] ?? '';
      people.job = data['known_for_department'] ?? '-';
      people.placeOfBirth = data['place_of_birth'] ?? '-';
      people.bio = data['biography'] ?? '-';
      people.birthday = formatBirthday(data['birthday']) ?? '0000-00-00';
      people.deathday = data['deathday'] ?? '-';
      people.gender = data['gender'] == 2 ? 'Male' : 'Female';
      people.name = data['name'] ?? '-';
      final urlMovies = Uri.https('api.themoviedb.org', '/3/person/$id/movie_credits');
      final responseMovies = await http.get(urlMovies, headers: Constant.header);
      final dataMovies = jsonDecode(responseMovies.body);
      people.movies = [];
      
      for (var item in dataMovies['cast']) {
        people.movies!.add(MovieCast(
            character: item['character'] ?? item['job'],
            id: item['id'],
            releaseDate: item['release_date'],
            posterPath: item['poster_path'],
            title: item['title'],
            vote: item['vote'] ?? 0,
        ));
      }
      
      people.movies!.sort((a, b) {
        if (a.vote! < b.vote!) {
          return 1;
        } else {
          return -1;
        }
      });

    } catch(e) {
      logger.d(e);
    }
    
    return people;
  }

  @override
  Future<List<MovieTrendingModel>> getFilmFilter({type, subtype, sort, fromDate, toDate, items, isFilter}) async {
    List<MovieTrendingModel> list = [];
    try {
      var url;
      if (isFilter) {
        if (fromDate == '') {
          url = Uri.https('api.themoviedb.org', '/3/discover/$type', {
            'primary_release_date.lte' : toDate,
            // 'language': 'en-US',
            'sort_by' : sort,
            'with_genres': items,
          });
        } else {
          url = Uri.https('api.themoviedb.org', '/3/discover/$type', {
            'primary_release_date.gte' : fromDate,
            'primary_release_date.lte' : toDate,
            // 'language': 'en-US',
            'sort_by' : sort,
            'with_genres': items,
          });
        }

      } else {
        url = Uri.https('api.themoviedb.org', '/3/$type/$subtype');
      }
      final response = await http.get(url, headers: Constant.header);
      final data = jsonDecode(response.body);
      for (var item in data['results']) {
        list.add(MovieTrendingModel(
          type: type,
          title: item['title'] ?? item['name'],
          voteAverage: item['vote_average'] ?? 0,
          posterPath: item['poster_path'] ?? '-',
          releaseDate: item['release_date'] ?? item['first_air_date'],
          id: item['id'],
          backdropPath: item['backdrop_path'] ?? '-',
        ));
      }
    } catch(e) {
      logger.d(e);
    }
    return list;
  }

  @override
  Future<List<PopularPeopleModel>> getPopularPeople() async {
    List<PopularPeopleModel> list = [];
    try {
      final url = Uri.https('api.themoviedb.org', '/3/person/popular');
      final response = await http.get(url, headers: Constant.header);
      final data = jsonDecode(response.body);
      for (var people in data['results']) {
        list.add(PopularPeopleModel(
          id: people['id'] ?? 0,
          name: people['name'] ?? '-',
          image: people['profile_path'] ?? '-',
          knownFilm: people['known_for']?.where((e) => e['title'] != null).map((e) => e['title']).join(', ') ?? '-',
        ));
      }
    } catch(e) {
      logger.d(e);
    }
    return list;
  }

}