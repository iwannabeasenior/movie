import 'package:flutter/material.dart';
import 'package:movie/features/domain/entity/people_detail.dart';
import 'package:movie/features/presentation/pages/movie/detail_movie.dart';
import 'package:movie/features/presentation/pages/people/people.dart';
import 'package:provider/provider.dart';

import '../../../domain/usecase/get_trending_home.dart';
void main() {
  runApp(const MaterialApp(
    home: DetailPeople()
  ));
}
class DetailPeoplePage extends StatelessWidget {
  final int id;
  final String type;
  const DetailPeoplePage({super.key, required this.id, required this.type});

  @override
  Widget build(BuildContext context) {

    var api = context.read<GetTrendingHome>();
    return FutureProvider(
        create: (_) => api.callPeopleDetail(id: id, type: type),
        initialData: PeopleDetail(),
        child: Consumer<PeopleDetail> (
          builder: (context, value, child) {
            if (value == PeopleDetail()) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return const DetailPeople();
            }
          },
        )
    );
  }
}
class DetailPeople extends StatefulWidget {
  const DetailPeople({super.key});

  @override
  State<DetailPeople> createState() => _DetailPeopleState();
}

class _DetailPeopleState extends State<DetailPeople> {
  int _maxLine = 6;
  @override
  Widget build(BuildContext context) {
    var controller = context.watch<PeopleDetail>();
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 40),
              // height: height * 0.4,
              child: Row(
                children: [
                  Container(
                    height: height * 0.35,
                    // width: height * 0.17,
                    child: AspectRatio(
                      aspectRatio: 0.5,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(fit: BoxFit.cover, 'http://image.tmdb.org/t/p/w500/${controller.profilePath}',),
                      ),
                    ),
                  ),
                  SizedBox(width: width * 0.07),
                  Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(controller.name!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25, fontStyle: FontStyle.italic),),
                          const SizedBox(height: 10,),
                          const Text('Personal Info', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),),
                          const SizedBox(height: 10),
                          Bio(name: 'Known For', value: controller.job!),
                          const Bio(name: 'Known Credits', value: '12345'),
                          const SizedBox(height: 10,),
                          Bio(name: 'Gender', value: controller.gender!),
                          const SizedBox(height: 10,),
                          Bio(name: 'Birthday', value: controller.birthday!),
                          const SizedBox(height: 10,),
                          Bio(name: 'Place of Birth', value: controller.placeOfBirth!),
                        ],
                      )
                  ),
                ]
              )
            ),
            Container(
              // height: height * 0.25,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text('Biography', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500, )),
                  Text(controller.bio!, style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic), maxLines: _maxLine, overflow: TextOverflow.ellipsis),
                  TextButton(onPressed: () {
                    setState(() {
                      _maxLine = _maxLine == 6 ? 10000 : 6;
                    });
                  }, child: Text(_maxLine == 6 ? 'Read More' : 'Collapse', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple, fontStyle: FontStyle.italic, fontSize: 18),))
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: height * 0.3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Known For', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 28, fontWeight: FontWeight.bold),),
                  const SizedBox(height: 10,),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.movies!.length,
                      itemBuilder: (context, index) {
                        return LayoutBuilder(
                          builder: (context, constraints) =>  Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: Column(
                              children: [
                                InkWell(
                                  child: SizedBox(
                                    height: constraints.maxHeight * 0.8,
                                    child: AspectRatio(
                                      aspectRatio: 0.6,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network('http://image.tmdb.org/t/p/w500/${controller.movies![index].posterPath}', fit: BoxFit.fill,),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => DetailMovie(id: controller.movies![index].id!, type: 'movie')));
                                  },
                                ),
                                const SizedBox(height: 10),
                                Expanded(
                                    child: SizedBox(
                                      width: constraints.maxHeight * 0.8 * 0.6,
                                      child: Text(
                                          controller.movies![index].title!,
                                          style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
                                      ),
                                    )
                                )
                              ],
                            ),
                          ),
                        );
                      },

                    ),
                  )
                ],
              )
            ),
            Container(
              height: 200,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.grey)]
              ),
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: Instance.movies.length,
                itemBuilder: (context, index) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(Instance.movies[index].keys.toString()),
                    ],
                  );
                },
              ),
            )
          ],
        )
      ),
    );
  }
}
class Bio extends StatelessWidget {
  final String name;
  final String value;
  const Bio({super.key, required this.name, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500,fontStyle: FontStyle.italic),),
        const SizedBox(height: 5),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 14, fontStyle: FontStyle.italic),)
      ],
    );
  }
}
