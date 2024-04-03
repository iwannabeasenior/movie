
import 'package:flutter/material.dart';
import 'package:movie/features/presentation/pages/movie/detail_movie.dart';
import 'package:movie/features/presentation/pages/movie/movie_page_state.dart';
import 'package:movie/helper/format_day.dart';
import 'package:provider/provider.dart';

import '../../../domain/usecase/get_trending_home.dart';
class MoviePageFather extends StatelessWidget {
  final String type;
  const MoviePageFather({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    var api = context.read<GetTrendingHome>();
    return ChangeNotifierProvider(
        create: (_) => MoviePageState(api: api, type: type),
        child: MoviePage(type: type)
    );
  }
}

class MoviePage extends StatefulWidget {
  final String type;
  const MoviePage({super.key, required this.type});

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MoviePageState>().search();
    }); // call when initstate done
  }

  @override
  Widget build(BuildContext context) {
    var api = context.watch<MoviePageState>();
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration:  BoxDecoration(
                  color: Colors.purple.withOpacity(0.7),
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20))
              ),
              height: height * 0.5,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
                child:  Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        widget.type == 'movie' ? DropdownButton<String>(
                            dropdownColor: Colors.white,
                            iconEnabledColor: Colors.white,
                            iconSize: 50,
                            borderRadius: BorderRadius.circular(10),
                            value: api.subtype,
                            onChanged: (String? value) {
                              setState(() {
                                api.subtype = value!;
                              });
                            },
                            items: <String>['Popular', 'Now Playing', 'Upcoming', 'Top Rated']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            })
                                .toList()
                        ) :
                        DropdownButton<String>(
                          dropdownColor: Colors.white,
                          iconEnabledColor: Colors.white,
                          iconSize: 50,
                          borderRadius: BorderRadius.circular(10),
                          value: api.subtype,
                          onChanged: (String? value) {
                            setState(() {
                              api.subtype = value!;
                            });
                          },
                          items: <String>['Popular', 'Airing Today', 'On TV', 'Top Rated']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          })
                              .toList(),
                        ),


                        DropdownButton<String>(
                          dropdownColor: Colors.white,
                          iconEnabledColor: Colors.white,
                          iconSize: 50,
                          borderRadius: BorderRadius.circular(10),
                          value: api.sort,
                          onChanged: (String? value) {
                            setState(() {
                              api.sort = value!;
                            });
                          },
                          items: <String>['Popularity Descending', 'Popularity Ascending', 'Rating Descending', 'Rating Ascending', 'Release Date Descending', 'Release Date Ascending', '(Title)A-Z', '(Title)Z-A']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          })
                              .toList(),
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    widget.type == 'movie' ? Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: GridView.builder(
                          itemCount: api.itemsMovie.length,
                          itemBuilder: (context, index) => InkWell(
                            onTap: () {
                              setState(() {
                                api.itemsMovie[index].picked = !api.itemsMovie[index].picked;
                              });
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    color: api.itemsMovie[index].picked ? Colors.lightBlueAccent : Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    // boxShadow: [BoxShadow(color: Colors.grey, spreadRadius: 1, blurRadius: 1)]
                                    border: Border.all(color: Colors.black),
                                ),
                                child: Center(child: Text(api.itemsMovie[index].name, style: TextStyle(fontSize: 13),))
                            ),
                          ),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount (
                            crossAxisCount: 3,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 3,
                          ),
                        ),
                      ),
                    ) : Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: GridView.builder(
                          itemCount: api.itemsTVShows.length,
                          itemBuilder: (context, index) => InkWell(
                            onTap: () {
                              setState(() {
                                api.itemsTVShows[index].picked = !api.itemsTVShows[index].picked;
                              });
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    color: api.itemsTVShows[index].picked ? Colors.lightBlueAccent : Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    // boxShadow: [BoxShadow(color: Colors.black, spreadRadius: 1, blurRadius: 1)],
                                    border: Border.all(color: Colors.black)
                                ),
                                child: Center(child: Text(api.itemsTVShows[index].name, style: TextStyle(fontSize: 13),))
                            ),
                          ),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount (
                            crossAxisCount: 3,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 3,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('From', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),),
                        Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            height: 40,
                            width: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(api.fromDate, style: TextStyle(color: Colors.white, fontSize: 15),),
                                IconButton(icon: Icon(Icons.calendar_today_rounded), color: Colors.white,
                                  onPressed: () async {
                                    final DateTime? picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1900, 1), lastDate: DateTime(DateTime.now().year, (DateTime.now().month + 1)));
                                    if (picked != null && picked.toString().substring(0, 10) != api.fromDate) {
                                      setState(() {
                                        api.fromDate = picked.toString().substring(0, 10);
                                      });
                                    }
                                  },
                                )

                              ],
                            )
                        ),
                        Text('To', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),),
                        Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            height: 40,
                            width: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(api.toDate, style: TextStyle(color: Colors.white, fontSize: 15),),
                                IconButton(icon: Icon(Icons.calendar_today_rounded), color: Colors.white,
                                  onPressed: () async {
                                    final DateTime? picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1900, 1), lastDate: DateTime(DateTime.now().year, (DateTime.now().month + 1)));
                                    if (picked != null && picked.toString().substring(0, 10) != api.toDate) {
                                      setState(() {
                                        api.toDate = picked.toString().substring(0, 10);
                                      });
                                    }
                                  },
                                )
                              ],
                            )
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                    InkWell(
                      onTap: () async {
                        api.isFilter = true;
                        await api.search();
                      },
                      child: Container(
                          height: 45,
                          margin: EdgeInsets.symmetric(horizontal: 120),
                          decoration: BoxDecoration(
                            color: Colors.lightBlueAccent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.search, color: Colors.black,),
                                SizedBox(width: 10,),
                                Text('Search', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),)
                              ]
                          )
                      ),
                    )
                  ],
                ),
              ),
            ),
            // SizedBox(height: height * 0.05,),
            Expanded(
                child: GridView.builder(
                    padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.5,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    itemCount: api.films.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => DetailMovie(type: widget.type, id: api.films[index].id!),));
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                                boxShadow: const [BoxShadow(color: Colors.grey, spreadRadius: 2, blurRadius: 3)]
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    SizedBox(
                                      height: width * 0.35,
                                      width: double.infinity,
                                      child: ClipRRect(
                                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                                          child: Image.network('http://image.tmdb.org/t/p/w500/${api.films[index].posterPath}', fit: BoxFit.cover,)
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Baseline(
                                          baseline: width* 0.35 + 5,
                                          baselineType: TextBaseline.alphabetic,
                                          child: Container(
                                            height: 30,
                                            width: 30,
                                            decoration: const BoxDecoration(
                                                color: Colors.green,
                                                shape: BoxShape.circle
                                            ),
                                            child: Center(
                                                child: Text((api.films[index].voteAverage! * 10).toInt().toString())
                                            ),
                                          )
                                      ),
                                    ),
                                    Positioned(
                                      top: 10,
                                      right: 10,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                            color: Colors.white70,
                                            shape: BoxShape.circle
                                        ),
                                        child: InkWell(
                                            onTap: () {

                                            },
                                            child: const Icon(Icons.star)),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5,),
                                Center(child: Text(api.films[index].title!, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold), maxLines: 3, overflow: TextOverflow.ellipsis,)),
                                const SizedBox(height: 5),
                                Center(child: Text(formatDay(api.films[index].releaseDate) ?? '-')),
                              ],
                            )
                        ),
                      );
                    })
            ),
          ],
        ),
      ) ,
    );
  }
}