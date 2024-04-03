import 'package:equatable/equatable.dart';

class PopularPeople with EquatableMixin{
  String? name;
  int? id;
  String? image;
  String? knownFilm;

  String? job;
  PopularPeople({this.id, this.name, this.image, this.knownFilm, this.job});

  @override
  // TODO: implement props
  List<Object?> get props => [
    name, id, image, knownFilm, job
  ];
}