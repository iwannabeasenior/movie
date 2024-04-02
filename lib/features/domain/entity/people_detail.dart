import 'package:equatable/equatable.dart';
import 'package:movie/features/domain/entity/movie_cast.dart';

class PeopleDetail with EquatableMixin{
  String? name;
  String? bio;
  String? birthday;
  String? deathday;
  String? placeOfBirth;
  String? profilePath;
  String? job;
  String? gender;
  List<MovieCast>? movies;
  PeopleDetail({this.name, this.bio, this.birthday, this.placeOfBirth, this.gender, this.deathday, this.job, this.profilePath});

  @override
  // TODO: implement props
  List<Object?> get props => [
    name, bio, birthday, deathday, placeOfBirth, profilePath, job, gender, movies
  ];

}