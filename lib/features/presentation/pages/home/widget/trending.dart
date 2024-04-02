import 'package:flutter/material.dart';
import 'package:movie/features/presentation/pages/movie/detail_movie.dart';

class Trending extends StatelessWidget {
  final int id;
  final String type;
  final String postPath;
  final String title;
  final String releaseDate;
  final double rating;
  const Trending({
    super.key,
    required this.type,
    required this.id,
    required this.title,
    required this.releaseDate,
    required this.rating,
    required this.postPath,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          margin: const EdgeInsets.only(right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: constraints.maxHeight * 0.7,
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return DetailMovie(id: id, type: type);
                    }));
                  },
                  child: AspectRatio(
                    aspectRatio: 0.6,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        children: [
                          Container(
                            constraints: const BoxConstraints.expand(),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network('http://image.tmdb.org/t/p/w500/$postPath', fit: BoxFit.cover,),
                            ),
                          ),
                          Baseline(
                            baseline: constraints.maxHeight * 0.7 + 3,
                            baselineType: TextBaseline.alphabetic,
                            child: Container(
                              margin: const EdgeInsets.only(left: 10),
                              height: 20,
                              width: 20,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green,
                              ),
                              child: Center(
                                  child: Text('${(rating*10).toInt()}%', style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w500, fontSize: 10),)
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Flexible(
                child: SizedBox(
                  width: constraints.maxHeight * 0.45,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold,color: Colors.black),),
                      const SizedBox(height: 3),
                      Text(releaseDate, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black.withOpacity(0.8)),)
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
