import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:movie/features/data/repositories/movie_repo_impl.dart';
import 'package:movie/features/data/source/api/data_api.dart';
import 'package:movie/features/domain/usecase/get_trending_home.dart';
import 'package:movie/features/presentation/pages/movie/movie_page.dart';
import 'package:movie/features/presentation/pages/people/people_page.dart';
import 'package:movie/features/presentation/pages/profile/profile_page.dart';
import 'package:provider/provider.dart';

import 'home/home_page.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {

  int _bottomNavIndex = 0;

  List<IconData> iconList = [
    Icons.home,
    Icons.movie,
    Icons.live_tv_rounded,
    Icons.people,
    Icons.person,
  ];
  List<Widget> pages = [
    const HomePage(),
    const MoviePageFather(type: 'movie'),
    const MoviePageFather(type: 'tv'),
    const PeoplePageFather(),
    const ProfilePage(),

  ];
  List<String> titleList = [
    'Home',
    'Movies',
    'TV Shows',
    'Popular People',
    'Profile'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IndexedStack(
          index: _bottomNavIndex,
          children: pages,
        ),
        bottomNavigationBar: AnimatedBottomNavigationBar(
          onTap: (index) {
            setState(() {
              _bottomNavIndex = index;
            });
          },
          splashColor: Colors.green,
          backgroundColor: const Color.fromRGBO(138, 91, 214, 1),
          activeIndex: _bottomNavIndex,
          icons: iconList,
          inactiveColor: Colors.black.withOpacity(0.5),
          activeColor: Colors.green,
          gapLocation: GapLocation.none,
          notchSmoothness: NotchSmoothness.softEdge,
        )
    );
  }
}

void main() {
  MovieApiImpl api = MovieApiImpl();
  MovieRepoImpl repo = MovieRepoImpl(api: api);
  GetTrendingHome getTrendingHome = GetTrendingHome(repo: repo);
  runApp(
    MultiProvider(
        providers: [
          Provider.value(
            value: getTrendingHome),
        ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Root(),
      ),
    ),
  );
}