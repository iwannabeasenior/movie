import 'package:flutter/material.dart';
import 'package:movie/features/domain/entity/popular_people.dart';
import 'package:movie/features/domain/usecase/get_trending_home.dart';
import 'package:movie/features/presentation/pages/people/detail_people.dart';
import 'package:provider/provider.dart';


class PeoplePageFather extends StatelessWidget {
  const PeoplePageFather({super.key});

  @override
  Widget build(BuildContext context) {
    var api = context.read<GetTrendingHome>();
    return FutureProvider(
        create: (_) => api.getPopularPeople(),
        initialData: <PopularPeople>[],
        child: Consumer<List<PopularPeople>> (
          builder: (context, value, child) {
            if (value == <PopularPeople>[]) {
              return Center(child: CircularProgressIndicator());
            } else {
              return PeoplePage();
            }
          },
          // child: PeoplePage(),
        )
    );
  }
}


class PeoplePage extends StatefulWidget {
  const PeoplePage({super.key});

  @override
  State<PeoplePage> createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  @override
  Widget build(BuildContext context) {
    var api = context.watch<List<PopularPeople>>();
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Text('Popular People', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400),),
            const SizedBox(height: 50),
            Container(
              width: width * .7,
              height: height * 0.05,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(flex: 1,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20))
                        ),
                        child: const Center(
                          child: Text('Actor'),
                        ),
                      )
                  ),
                  Expanded(flex: 1,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.purple
                        ),
                        child: const Center(
                          child: Text('Actress'),
                        ),
                      )
                  ),
                  Expanded(flex: 1,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
                        ),
                        child: const Center(child: Text('Director'))
                      )
                  )
                ],
              )
            ),
            const SizedBox(height: 30,),
            Expanded(
              child: Container(
                // color: Colors.white,
                padding: const EdgeInsets.only(left: 20,),
                child: GridView.builder(
                    padding: const EdgeInsets.only(top: 10),
                    scrollDirection: Axis.vertical,
                    itemCount: api.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 0.7,
                      crossAxisCount: 2
                    ),
                    itemBuilder: (context, index) =>  InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPeoplePage(id: api[index].id!, type: 'cast',)));
                      },
                      child: Container(
                        clipBehavior: Clip.none,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 3, spreadRadius: 1,)]
                        ),
                        margin: const EdgeInsets.only(right: 20, bottom: 20),
                        child: Column(
                          children: [
                            SizedBox(
                              height: width * 0.4,
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                                child: Image.network('http://image.tmdb.org/t/p/w500/${api[index].image}', fit: BoxFit.cover,),
                              ),
                            ),
                            Expanded(
                                child: Container(
                                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                                  child: Column(
                                    children: [
                                      Center(child: Text(api[index].name!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),),
                                      SizedBox(height: 5,),
                                      Center(child: Text(api[index].knownFilm!, overflow: TextOverflow.ellipsis, maxLines: 3,))
                                    ],
                                  ),
                                )
                            )
                          ],
                        )
                      ),
                    )
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}
