

import 'package:flutter/material.dart';
import 'package:movie/features/domain/entity/movie_trailer.dart';
import 'package:movie/features/domain/usecase/get_trending_home.dart';
import 'package:movie/features/presentation/pages/home/home_state.dart';
import 'package:movie/features/presentation/pages/home/widget/trailer.dart';
import 'package:movie/features/presentation/pages/home/widget/trending.dart';
import 'package:movie/helper/constant.dart';
import 'package:provider/provider.dart';

import '../../../domain/entity/movie_trending.dart';
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => HomeState(),
        child: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<MovieTrending> listMovieTrending = [];
  List<MovieTrending> listMovieTrendingWeek = [];
  List<MovieTrailer> listMovieUpcomingTrailer = [];
  @override
  void initState() {

  }
  @override
  Widget build(BuildContext context) {
    final getTrendingHome = context.read<GetTrendingHome>();
    final size = MediaQuery.of(context).size;
    var controller = Provider.of<HomeState>(context);
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: [
            //Search
            Container(
              padding: const EdgeInsets.all(20),
              height: size.height * .25,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/image_design_ui_figma_movie/image7.jpeg'),
                )
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Welcome', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
                  const Text('Millions of movies, TV show and people', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: size.height * 0.06),
                  Container(
                    padding: const EdgeInsets.only(left: 20),
                    height: size.height * 0.06,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Search movie you want...', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 20),),
                        Container(
                          width: size.width * 0.2,
                          decoration: BoxDecoration(
                            color: Colors.lightBlueAccent,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Center(child: Text('Search', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),)),
                        )
                      ],
                    ),
                  ),

                ],
              ),
            ),
            //Oscar
            Container(
                padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                width: double.infinity,
                height: size.height * 0.12,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(138, 91, 214, 1)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Oscar Winner 2024', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 30,),),

                    Container(
                      padding: const EdgeInsets.only(left: 10),
                      height: 40,
                      width: 140,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('View the winner',),
                          Icon(Icons.arrow_right_alt_outlined),
                        ],
                      ),
                    )
                  ],
                )
            ),
            // Trending
            Container(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 10),
              width: double.infinity,
              height: size.height * .35,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(255, 212, 212, 1),
                boxShadow: [BoxShadow(color: Colors.grey, blurStyle: BlurStyle.inner, blurRadius: 5, spreadRadius: 4)]
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text('Trending', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
                      const SizedBox(width: 30,),
                      Container(
                        height: 30,
                        width: size.width * 0.3,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(138, 91, 214, 1),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.blue)
                        ),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 2,
                                child: InkWell(
                                  onTap: () {
                                    if (controller.stateTrending != TrendingState.Day) {
                                      controller.changeTrendingState();
                                    }
                                  },
                                  child: AnimatedContainer(
                                    duration: Constant.timeSpace,
                                    height: 30,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: controller.stateTrending == TrendingState.Day ? Colors.yellow : const Color.fromRGBO(138, 91, 214, 1),
                                      ),
                                      child: const Center(child: Text('Today'))
                                  ),
                                )
                            ),
                            Expanded(
                                flex: 3,
                                child: InkWell(
                                  onTap: () {
                                    if (controller.stateTrending != TrendingState.Week) {
                                      controller.changeTrendingState();
                                    }
                                  },
                                  child: AnimatedContainer(
                                      duration: Constant.timeSpace,
                                      height: 30,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(30),
                                          color: controller.stateTrending == TrendingState.Week ? Colors.yellow : const Color.fromRGBO(138, 91, 214, 1)
                                      ),
                                      child: const Center(child: Text('This Week'))
                                  ),
                                )
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 15),
                  controller.stateTrending == TrendingState.Day ?
                  Expanded(
                    child: listMovieTrending.isEmpty ? FutureBuilder(
                      future: get1(getTrendingHome: getTrendingHome),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else {
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: listMovieTrending.length,
                            itemBuilder: (context, index) {
                              final movie = listMovieTrending[index];
                              return Trending(type: movie.type!, id: movie.id! ,title: movie.title!, releaseDate: movie.releaseDate!, rating: movie.voteAverage!, postPath: movie.posterPath!,);
                            },
                          );
                        }
                      },
                    ) : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: listMovieTrending.length,
                      itemBuilder: (context, index) {
                        final movie = listMovieTrending[index];
                        return Trending(type: movie.type!, id: movie.id! ,title: movie.title!, releaseDate: movie.releaseDate!, rating: movie.voteAverage!, postPath: movie.posterPath!,);
                      },
                    ),
                  ) :
                  Expanded(
                    child: listMovieTrendingWeek.isEmpty ? FutureBuilder(
                      future: get2(getTrendingHome: getTrendingHome),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else {
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: listMovieTrendingWeek.length,
                            itemBuilder: (context, index) {
                              final movie = listMovieTrendingWeek[index];
                              return Trending(type: movie.type!, id: movie.id! ,title: movie.title!, releaseDate: movie.releaseDate!, rating: movie.voteAverage!, postPath: movie.posterPath!,);
                            },
                          );
                        }
                      },
                    ) : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: listMovieTrendingWeek.length,
                      itemBuilder: (context, index) {
                        final movie = listMovieTrendingWeek[index];
                        return Trending(type: movie.type!, id: movie.id! ,title: movie.title!, releaseDate: movie.releaseDate!, rating: movie.voteAverage!, postPath: movie.posterPath!,);
                      },
                    ),
                  )
                  ,
                ],
              ),
            ),
            // Trailer
            Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              height: size.height * .25,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/image_design_ui_figma_movie/image1.jpg')
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 15,),
                  Row(
                    children: [
                      const Text('Lastest Trailer', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
                      const SizedBox(width: 30,),
                      Container(
                        height: 30,
                        width: size.width * 0.3,
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(138, 91, 214, 1),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.blue)
                        ),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 2,
                                child: Container(
                                    height: 30,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.yellow
                                    ),
                                    child: const Center(child: Text('Popular'))
                                )
                            ),
                            const Expanded(
                                flex: 3,
                                child: Center(child: Text('In Theaters')))
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: listMovieUpcomingTrailer.isNotEmpty ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: listMovieUpcomingTrailer.length,
                        itemBuilder: (context, index) {
                          final item = listMovieUpcomingTrailer[index];
                          return Trailer(
                            path: item.path!,
                            title: item.title!,
                            titleTrailer: item.titleTrailer!,
                            url: item.path!,
                          );
                        }
                    ): FutureBuilder(
                        future: get3(getTrendingHome: getTrendingHome),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else {
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: listMovieUpcomingTrailer.length,
                              itemBuilder: (context, index) {
                                final item = listMovieUpcomingTrailer[index];
                                return Trailer(
                                  path: item.path!,
                                  title: item.title!,
                                  titleTrailer: item.titleTrailer!,
                                  url: item.key!,
                                );
                              }
                            );
                          }
                        },
                    )
                  ),
                ],
              )
            )
          ],
        )
      ),
    );
  }
  Future<void> get1({getTrendingHome}) async {
    listMovieTrending = await getTrendingHome.callToday();
  }
  Future<void> get2({getTrendingHome}) async {
    listMovieTrendingWeek = await getTrendingHome.callThisWeek();
  }
  Future<void> get3({getTrendingHome}) async {
    listMovieUpcomingTrailer = await getTrendingHome.callTrailer();
  }
}


