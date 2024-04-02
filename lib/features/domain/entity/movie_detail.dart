import 'package:movie/features/domain/entity/movie_trailer.dart';

import 'cast.dart';
import 'package:equatable/equatable.dart';
class MovieDetail with EquatableMixin{
  int? id;
  String? title;
  String? tagLine;
  String? postPath;
  String? backdropPath;
  String? overview;
  String? originalLanguage;
  String? genres;
  String? status;
  String? director;
  List<Cast>? casts;
  List<MovieTrailer>? videos;
  int? runTime;
  double? vote;
  String? revenue;
  String? budget;
  String? releaseDate;
  String? trailer;

  String? type;
  String? network;
  List<String>? pathNetwork;
  MovieDetail({this.id, this.title, this.tagLine, this.postPath,
      this.backdropPath, this.overview, this.originalLanguage, this.genres,
      this.status, this.director, this.casts, this.videos, this.runTime,
      this.vote, this.revenue, this.budget, this.releaseDate, this.trailer, this.type, this.network, this.pathNetwork});

  @override
  // TODO: implement props
  List<Object?> get props => [
    id, title, tagLine, postPath, backdropPath, overview, originalLanguage, genres, status, director, casts, videos, runTime, vote, revenue, budget, releaseDate, trailer, type, network, pathNetwork
  ];
}

