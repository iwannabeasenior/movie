import 'package:equatable/equatable.dart';

class PopularPeople with EquatableMixin{
  String? name;
  int? id;
  String? image;
  String? knownFilm;
  PopularPeople({this.id, this.name, this.image, this.knownFilm});

  @override
  // TODO: implement props
  List<Object?> get props => [
    name, id, image, knownFilm,
  ];
}