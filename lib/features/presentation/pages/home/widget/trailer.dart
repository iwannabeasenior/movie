import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Trailer extends StatelessWidget {
  final String path;
  final String title;
  final String titleTrailer;
  final String url;

  const Trailer({
    super.key,
    required this.path,
    required this.title,
    required this.titleTrailer,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          margin: const EdgeInsets.only(right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: constraints.maxHeight * 0.7,
                child: AspectRatio(
                  aspectRatio: 1.6,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          constraints: const BoxConstraints.expand(),
                          child: Image.network('http://image.tmdb.org/t/p/w500/$path', fit: BoxFit.cover,),
                        ),
                      ),
                      Center(
                          child: InkWell(
                              onTap: () async {
                                print('url is $url');
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
                                        ..loadRequest(Uri.parse('https://www.youtube.com/watch?v=$url'));
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
                              child: const Icon(Icons.play_arrow, color: Colors.white, size: 35)
                          )
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: constraints.maxHeight * 0.7 * 1.6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold,color: Colors.white), overflow: TextOverflow.ellipsis,),
                    const SizedBox(height: 5,),
                    Text(titleTrailer, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w300,color: Colors.white), overflow: TextOverflow.ellipsis,)
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
