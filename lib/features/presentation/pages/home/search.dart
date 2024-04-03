import 'package:flutter/material.dart';
import 'package:movie/features/domain/usecase/get_trending_home.dart';
import 'package:movie/features/presentation/pages/home/search_state.dart';
import 'package:movie/features/presentation/pages/movie/detail_movie.dart';
import 'package:movie/features/presentation/pages/people/detail_people.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
class SearchPageFather extends StatelessWidget {
  final String keyword;
  const SearchPageFather({super.key, required this.keyword});

  @override
  Widget build(BuildContext context) {
    var api = context.read<GetTrendingHome>();
    return ChangeNotifierProvider(
        create: (_) => SearchState(api: api, keyword: keyword),
        child: SearchPage(keyword: keyword,),
    );
  }
}

class SearchPage extends StatefulWidget {
  final String keyword;
  const SearchPage({super.key, required this.keyword});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _controller = TextEditingController(text: widget.keyword);
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SearchState>().search(keyword: widget.keyword);
    });
  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var api = context.watch<SearchState>();

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 10, left: 10, right: 10),
              height: height * 0.25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius. circular(20)),
                color: Color.fromRGBO(138, 91, 214, 1),
              ),
              child: Column(
                children: [
                  // SizedBox(height: 100,),
                  Row(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.pink,
                        ),
                        child: Center(
                          child: IconButton(onPressed: () {
                            Navigator.pop(context);
                          }, icon: Icon(Icons.backspace)),
                        ),
                      ),
                      SizedBox(width: width * 0.15,),
                      Text('Search Results', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),),
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.only(left: 10, bottom: 15),
                    height:50,
                    decoration: BoxDecoration(
                      color: Colors.lightBlueAccent,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.search, size: 50, ),
                        Expanded(
                          child: TextFormField(
                            controller: _controller,
                            onFieldSubmitted: (value) {
                              var newValue = value.trim();
                              if (newValue != '') {
                                api.search(keyword: newValue);
                              }
                            },
                            style: TextStyle(
                              fontSize: 24,
                            ),
                            cursorHeight: 30,
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                                // prefixIcon : Icon(Icons.search, size: 30),
                                // prefixIconColor: Colors.black,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(30),
                                )
                            ),
                          ),
                        ),
                      ],
                    )
                  ),
                  SizedBox(height: 30,),
                  Center(
                      child: Container(
                        height: 50,
                        width: width * 0.7,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    if (api.state != Type.Movie) {
                                      api.changeState(Type.Movie);
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(30), bottomLeft: Radius.circular(30)),
                                      color: api.state == Type.Movie ? Colors.black : Colors.white,
                                    ),
                                    child: Center(
                                        child: Text('Movie', style: TextStyle(color: api.state == Type.Movie ? Colors.white : Colors.black,),),
                                    ),
                                  ),
                                )
                            ),
                            Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    if (api.state != Type.TVShows) {
                                      api.changeState(Type.TVShows);
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: api.state == Type.TVShows ? Colors.black : Colors.white,
                                    ),
                                    child: Center(
                                      child: Text('TV Shows', style: TextStyle(color: api.state == Type.TVShows ? Colors.white : Colors.black,)),
                                    ),
                                  ),
                                )),
                            Expanded(flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    if (api.state != Type.People) {
                                      api.changeState(Type.People);
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(topRight: Radius.circular(30), bottomRight: Radius.circular(30)),
                                      color: api.state == Type.People ? Colors.black : Colors.white,
                                    ),
                                    child: Center(
                                      child: Text('People',style: TextStyle(color: api.state == Type.People ? Colors.white : Colors.black,))
                                    ),
                                  ),
                                )
                            )
                          ],
                        ),
                      )
                  )
                ],
              )
            ),
            SizedBox(height: height * 0.03),
            Expanded(
                child: Container(
                  child: call(type: api.state, api: api),
                ),
            ),
          ],
        )
      ),
    );

  }
  Widget call({type, api}) {
    if (type == Type.People) {
      return ListView.builder(
          itemCount: api.people.length,
          itemBuilder: (context, index) {
            return Container(
              height: 120,
              margin: index != 0 ? EdgeInsets.only(bottom: 10, left: 10, right: 10) : EdgeInsets.only(bottom: 10, left: 10, right: 10, top: 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 2, spreadRadius: 2)]
              ),
              child: Row(
                children: [
                  AspectRatio(
                    aspectRatio: 0.75,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), topLeft: Radius.circular(10)),
                      child: Image.network('http://image.tmdb.org/t/p/w500/${api.people[index].image}', fit: BoxFit.cover,),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                              onTap: () {
                                Navigator.push(context, PageTransition(child: DetailPeoplePage(id: api.people[index].id, type: 'cast'), type: PageTransitionType.leftToRight));
                              },
                              child: Text(api.people[index].name,style: TextStyle( color: Colors.red,fontSize: 20,fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis)
                          ),
                          Text(api.people[index].job, style: TextStyle(color: Colors.grey),),
                          Text(api.people[index].knownFilm, style: TextStyle(fontSize: 15), maxLines: 2, overflow: TextOverflow.ellipsis,)
                        ],
                      ),
                      padding: EdgeInsets.all(10),
                    ),
                  ),
                ],
              ),
            );
          });
    } else if (type == Type.TVShows) {
      return ListView.builder(
          itemCount: api.tv.length,
          itemBuilder: (context, index) {
            return Container(
              height: 120,
              margin: index != 0 ? EdgeInsets.only(bottom: 10, left: 10, right: 10) : EdgeInsets.only(bottom: 10, left: 10, right: 10, top: 10),

              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 2, spreadRadius: 2)]
              ),
              child: Row(
                children: [
                  AspectRatio(
                    aspectRatio: 0.75,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), topLeft: Radius.circular(10)),
                      child: Image.network('http://image.tmdb.org/t/p/w500/${api.tv[index].posterPath}', fit: BoxFit.cover,),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                              onTap: () {
                                Navigator.push(context, PageTransition(child: DetailMovie(id: api.tv[index].id, type: 'tv'), type: PageTransitionType.leftToRight));
                              },
                              child: Text(api.tv[index].title,style: TextStyle( color: Colors.red,fontSize: 20,fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis)
                          ),
                          Text(api.tv[index].releaseDate, style: TextStyle(color: Colors.grey, fontSize: 15),),
                          Text(api.tv[index].overview, style: TextStyle(fontSize: 15), maxLines: 2, overflow: TextOverflow.ellipsis,)
                        ],
                      ),
                      padding: EdgeInsets.all(10),
                    ),
                  ),
                ],
              ),
            );
          });
    } else {
      return ListView.builder(
          itemCount: api.movie.length,
          itemBuilder: (context, index) {
            return Container(
              height: 120,
              margin: index != 0 ? EdgeInsets.only(bottom: 10, left: 10, right: 10) : EdgeInsets.only(bottom: 10, left: 10, right: 10, top: 10),

              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 2, spreadRadius: 2)]
              ),
              child: Row(
                children: [
                  AspectRatio(
                    aspectRatio: 0.75,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), topLeft: Radius.circular(10)),
                      child: Image.network('http://image.tmdb.org/t/p/w500/${api.movie[index].posterPath}', fit: BoxFit.cover,),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(context, PageTransition(child: DetailMovie(id: api.movie[index].id, type: 'movie'), type: PageTransitionType.leftToRight));
                            },
                              child: Text(api.movie[index].title,style: TextStyle( color: Colors.red,fontSize: 20,fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis,)
                          ),
                          Text(api.movie[index].releaseDate, style: TextStyle(color: Colors.grey, fontSize: 15),),
                          Text(api.movie[index].overview, style: TextStyle(fontSize: 15), maxLines: 2, overflow: TextOverflow.ellipsis,)
                        ],
                      ),
                      padding: EdgeInsets.all(10),
                    ),
                  ),
                ],
              ),
            );
          });
    }
    return Text('error');
  }
}

