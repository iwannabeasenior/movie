

import 'package:flutter/material.dart';
import 'package:movie/features/domain/entity/movie_detail.dart';
import 'package:movie/features/presentation/pages/movie/detail_movie_state.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../domain/usecase/get_trending_home.dart';
import '../people/detail_people.dart';

class DetailMovie extends StatelessWidget {
  final int id;
  final String type;
  const DetailMovie({super.key, required this.id, required this.type});

  @override
  Widget build(BuildContext context) {

    var api = context.read<GetTrendingHome>();
    return FutureProvider(
        create: (_) => DetailMovieState(api: api, id: id, type: type).fetch(),
        initialData: MovieDetail(),
        child: Consumer<MovieDetail> (
          builder: (context, value, child) {
            if (value == MovieDetail()) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return DetailPage(id: id, type: type);
            }
          },
        )
    );
  }
}

class DetailPage extends StatefulWidget {
  final int id;
  final String type;
  const DetailPage({super.key, required this.id, required this.type});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int _maxLine = 6;
  @override
  Widget build(BuildContext context) {

    var controller = context.watch<MovieDetail>();
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: Container(
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              SizedBox(
                height: height * .7,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network('http://image.tmdb.org/t/p/w500/${controller.postPath!}', fit: BoxFit.cover),
                    Container(
                      color: Colors.lightBlueAccent.withOpacity(0.6),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: SizedBox(
                                  height: height * 0.25,
                                  width: width * 0.3,
                                  child: Image.network('http://image.tmdb.org/t/p/w500/${controller.postPath!}', fit: BoxFit.fill),
                                ),
                              ),
                              SizedBox(width: width*0.1),
                              Expanded(
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(controller.title!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold , fontSize: 20, decoration: TextDecoration.none),),
                                      const SizedBox(height: 20),
                                      SizedBox(
                                        width: width * 0.4,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              height: 50,
                                              width: 50,
                                              decoration: const BoxDecoration(
                                                color: Colors.green,
                                                shape: BoxShape.circle
                                              ),
                                              child: Center(child: Text('${(controller.vote! * 10).toInt()}%', style: const TextStyle(fontSize: 20, decoration: TextDecoration.none),))
                                            ),
                                            Container(
                                              height: 50,
                                              width: 50,
                                              decoration: const BoxDecoration(
                                                  color: Colors.purple,
                                                  shape: BoxShape.circle
                                              ),
                                              child: const Icon(Icons.heart_broken)
                                            ),Container(
                                              height: 50,
                                              width: 50,
                                              decoration: const BoxDecoration(
                                                  color: Colors.purple,
                                                  shape: BoxShape.circle
                                              ),
                                              child: const Icon(Icons.battery_saver_sharp)
                                            )
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          // IconButton(icon: Icon(Icons.play_arrow), iconSize: 10, onPressed: () {},  ),
                                          InkWell(
                                              child: const Icon(Icons.play_arrow, size: 40, color: Colors.white,),
                                            onTap: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    var controllerWebView = WebViewController()
                                                      ..setJavaScriptMode(JavaScriptMode.unrestricted)
                                                      ..setBackgroundColor(const Color(0x00000000))
                                                      ..setNavigationDelegate(
                                                        NavigationDelegate(
                                                          onProgress: (int progress) {
                                                            // Update loading bar.
                                                          },
                                                          onPageStarted: (String url) {},
                                                          onPageFinished: (String url) {},
                                                          onWebResourceError: (WebResourceError error) {},
                                                          onNavigationRequest: (NavigationRequest request) {
                                                            if (request.url.startsWith('https://www.youtube.com/')) {
                                                              return NavigationDecision.prevent;
                                                            }
                                                            return NavigationDecision.navigate;
                                                          },
                                                        ),
                                                      )
                                                      ..loadRequest(Uri.parse('https://www.youtube.com/watch?v=${controller.trailer}'));
                                                    return FractionallySizedBox(
                                                        alignment: Alignment.center,
                                                        heightFactor: 0.3,
                                                        widthFactor: 1,
                                                        child: WebViewWidget(
                                                          controller: controllerWebView,
                                                        )
                                                    );
                                                  }
                                              );
                                            },
                                          ),
                                          const Text('Play Trailer', style: TextStyle(color: Colors.white, fontSize: 20, decoration: TextDecoration.none, fontWeight: FontWeight.w500),)
                                        ],
                                      ),
                                      widget.type == 'movie' ? Text('PG-13, ${controller.releaseDate}\n${controller.genres}\n${controller.runTime} min', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15, decoration: TextDecoration.none, color: Colors.red),)
                                      : Text('PG-13, ${controller.releaseDate}\n${controller.genres}', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15, decoration: TextDecoration.none, color: Colors.red),)
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: height * .05),
                          Text(controller.tagLine!, style: const TextStyle(fontSize: 15, decoration: TextDecoration.none, color: Colors.white, fontStyle: FontStyle.italic),),
                          const SizedBox(height: 25),
                          const Text('Overview', style: TextStyle(color: Colors.white, fontSize: 25, decoration: TextDecoration.none, fontWeight: FontWeight.w500),),
                          const SizedBox(height: 10),
                          Text(controller.overview!, style: const TextStyle(decoration: TextDecoration.none, fontSize: 16, color: Colors.white), overflow: TextOverflow.ellipsis, maxLines: _maxLine,),
                          TextButton(onPressed: () {
                            setState(() {
                              _maxLine = _maxLine == 6 ? 10000 : 6;
                            });
                          },child: Text(_maxLine == 6 ? 'Read More' : 'Collapse', style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.purple, fontWeight: FontWeight.bold))),
                          const SizedBox(height: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.type == 'movie' ? 'Director' : 'Creator', style: TextStyle(fontSize: 15, decoration: TextDecoration.none, color: Colors.white, fontWeight: FontWeight.bold),),
                              Text(controller.director!, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, decoration: TextDecoration.none, color: Colors.white),)
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                )
              ),

              // top billed cast
              Container(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 5),
                height: height * 0.35,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Top Billed Cast', style: TextStyle(color: Colors.black, fontSize: 20, decoration: TextDecoration.none),),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.casts!.length,
                        itemBuilder: (context, index) {
                          return LayoutBuilder(
                            builder: (BuildContext context, BoxConstraints constraints) {
                              return Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: const [BoxShadow(color: Colors.grey, spreadRadius: 1, blurRadius: 1, offset: Offset(0, 0))],
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPeoplePage(id: controller.casts![index].id!, type: 'cast'),));
                                      },
                                      child: AspectRatio(
                                          aspectRatio: 0.5,
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                // alignment: Alignment.center,
                                                height: constraints.maxHeight * 0.65,
                                                width: double.infinity,
                                                child: ClipRRect(
                                                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                                                  child: Image.network('http://image.tmdb.org/t/p/w500/${controller.casts![index].image!}', fit: BoxFit.cover,),
                                                )
                                              ),
                                              SizedBox(height: constraints.maxHeight * 0.03),
                                              Center(
                                                child: Text(controller.casts![index].name!, style: const TextStyle(color: Colors.black,fontSize: 15, decoration: TextDecoration.none, fontWeight: FontWeight.bold)),
                                              ),
                                              SizedBox(height: constraints.maxHeight * 0.02),
                                              Center(child: Text(controller.casts![index].character!, style: const TextStyle(color: Colors.grey,fontSize: 15, decoration: TextDecoration.none)))
                                            ],
                                          )
                                      ),
                                    )
                                ),
                              );
                            },

                          );
                        },
                      ),
                    ),
                  ],
                )
              ),
              const SizedBox(height: 10),

              //video
              Container(
                color: Colors.black.withOpacity(0.8),
                padding: const EdgeInsets.only(right: 10, left: 10, bottom: 15, top: 5),
                height: height * 0.15,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Video', style: TextStyle(color: Colors.white, decoration: TextDecoration.none, fontSize: 20),),
                    const SizedBox(height: 15,),
                    Expanded(
                      child: ListView.builder(
                        itemCount: controller.videos!.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: AspectRatio(
                              aspectRatio: 2.3,
                              child: Stack(
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Container(
                                        constraints: const BoxConstraints.expand(),
                                          child: Image.network('http://image.tmdb.org/t/p/w500/${controller.videos![index].path}', fit: BoxFit.cover,))),
                                  Center(
                                      child: IconButton(
                                        icon: const Icon(Icons.play_arrow),
                                        iconSize: 40,
                                        color: Colors.white,
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                var controllerWebView = WebViewController()
                                                  ..setJavaScriptMode(JavaScriptMode.unrestricted)
                                                  ..setBackgroundColor(const Color(0x00000000))
                                                  ..setNavigationDelegate(
                                                    NavigationDelegate(
                                                      onProgress: (int progress) {
                                                        // Update loading bar.
                                                      },
                                                      onPageStarted: (String url) {},
                                                      onPageFinished: (String url) {},
                                                      onWebResourceError: (WebResourceError error) {},
                                                      onNavigationRequest: (NavigationRequest request) {
                                                        if (request.url.startsWith('https://www.youtube.com/')) {
                                                          return NavigationDecision.prevent;
                                                        }
                                                        return NavigationDecision.navigate;
                                                      },
                                                    ),
                                                  )
                                                  ..loadRequest(Uri.parse('https://www.youtube.com/watch?v=${controller.videos![index].key}'));
                                                return FractionallySizedBox(
                                                    alignment: Alignment.center,
                                                    heightFactor: 0.3,
                                                    widthFactor: 1,
                                                    child: WebViewWidget(
                                                      controller: controllerWebView,
                                                    )
                                                );
                                              }
                                          );
                                        },
                                      )
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.only(bottom: 20, top: 20),
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Describe(name: 'Status', status: controller.status!),
                        SizedBox(width: width * 0.3, child: const Divider(color: Colors.black)),
                        Describe(name: 'Ori-Language', status: controller.originalLanguage!),
                      ],
                    ),
                    const SizedBox(
                      height: 100,
                      child: VerticalDivider(color: Colors.black,)
                    ),
                    widget.type == 'movie' ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Describe(name: 'Budget', status: '\$${controller.budget}'),
                        SizedBox(width: width * 0.3, child: const Divider(color: Colors.black)),
                        Describe(name: 'Revenue', status: '\$${controller.revenue}')
                      ],
                    ) : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Describe(name: 'Type', status: '${controller.type}'),
                        SizedBox(width: width * 0.3, child: const Divider(color: Colors.black)),
                        Row(
                          children: [
                            // Container(
                            //   height: 30,
                            //     width: 30,
                            //     child: Image.network('http://image.tmdb.org/t/p/w500/${controller.pathNetwork}')),
                            Describe(name: 'Network', status: '${controller.network}'),
                          ],
                        )
                      ],
                    ),
                  ]
                )
              )
            ]
          )
        ),
      ),
    );
  }
}
class Describe extends StatelessWidget {
  final String name;
  final String status;
  const Describe({super.key, required this.name, required this.status});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, decoration: TextDecoration.none, color: Colors.black),),
        const SizedBox(height: 5,),
        Text(status, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, decoration: TextDecoration.none, color: Colors.red),)
      ],
    );
  }
}

