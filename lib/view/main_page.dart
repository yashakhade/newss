import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newss/model/news_channel_model.dart';
import 'package:newss/view/news_detail_screen.dart';
import 'package:newss/view_model/view_model.dart';
import 'package:provider/provider.dart';

import '../model/theme_model.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  startTimer() {
    Future.delayed(const Duration(seconds: 3), () {
      isLoading = true;
      setState(() {});
    });
  }

  NewsViewModel newsViewModel = NewsViewModel();
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.sizeOf(context).height;
    final w = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Flash'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Yash Khade'),
                  SizedBox(
                    height: 10,
                  ),
                  CircleAvatar(
                    radius: 35,
                    child: Icon(
                      Icons.person,
                      size: 30,
                    ),
                  )
                ],
              ),
            ),
            ListTile(
              title: const Text('Change Theme'),
              trailing: Switch(
                value: context.read<ThemeModel>().isDarkMode,
                onChanged: (value) {
                  context.read<ThemeModel>().toggleTheme();
                },
              ),
            ),
          ],
        ),
      ),
      body: !isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
                SizedBox(
                  height: h * 0.55,
                  width: w,
                  child: FutureBuilder<NewsChannelsHeadlinesModel>(
                    future:
                        newsViewModel.fetchNewsChannelHeadlinesApi('bbc-news'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return ListView.builder(
                            itemCount: snapshot.data?.articles?.length ?? 0,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              DateTime dateTime = DateTime.parse(snapshot
                                  .data!.articles![index].publishedAt
                                  .toString());

                              final article = snapshot.data?.articles?[index];
                              if (article != null) {
                                return InkWell(
                                  onTap: () {
                                    String newsImage = snapshot
                                        .data!.articles![index].urlToImage!;
                                    String newsTitle =
                                        snapshot.data!.articles![index].title!;
                                    String newsDate = snapshot
                                        .data!.articles![index].publishedAt!;
                                    String newsAuthor =
                                        snapshot.data!.articles![index].author!;
                                    String newsDesc = snapshot
                                        .data!.articles![index].description!;
                                    String newsContent = snapshot
                                        .data!.articles![index].content!;
                                    String newsSource = snapshot
                                        .data!.articles![index].source!.name!;
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                NewsDetailScreen(
                                                    newsImage,
                                                    newsTitle,
                                                    newsDate,
                                                    newsAuthor,
                                                    newsDesc,
                                                    newsContent,
                                                    newsSource)));
                                  },
                                  child: Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      Container(
                                        padding:
                                            EdgeInsets.only(right: w * 0.03),
                                        height: h,
                                        width: w * 0.7,
                                        // decoration: Bor,
                                        child: CachedNetworkImage(
                                          imageUrl: snapshot
                                              .data!.articles![index].urlToImage
                                              .toString(),
                                          fit: BoxFit.cover,
                                          // placeholder: (context, url) => const Center(
                                          //     child: CircularProgressIndicator()),
                                          errorWidget: (context, url, error) =>
                                              const Icon(
                                            Icons.error_outline,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                      Card(
                                        margin: const EdgeInsets.only(
                                            right: 10, bottom: 10),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Container(
                                          alignment: Alignment.bottomCenter,
                                          height: h * .13,
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Center(
                                                child: SizedBox(
                                                  width: w * 0.5,
                                                  child: Text(
                                                    snapshot.data!
                                                        .articles![index].title
                                                        .toString(),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                              const Spacer(),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    snapshot
                                                        .data!
                                                        .articles![index]
                                                        .source!
                                                        .name
                                                        .toString(),
                                                    style: const TextStyle(
                                                      fontSize: 11,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: w * 0.2,
                                                  ),
                                                  Text(
                                                    DateFormat('MMM dd, yyyy')
                                                        .format(dateTime),
                                                    style: const TextStyle(
                                                        fontSize: 11,
                                                        color: Colors.blue),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              } else {
                                // Handle the case where there are no articles
                                return const Text('No articles found');
                              }
                            });
                      }
                    },
                  ),
                ),
                FutureBuilder<NewsChannelsHeadlinesModel>(
                  future: newsViewModel.fetchNewsChannelHeadlinesApi('CNN'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return ListView.builder(
                          itemCount: snapshot.data?.articles?.length ?? 0,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            DateTime dateTime = DateTime.parse(snapshot
                                .data!.articles![index].publishedAt
                                .toString());
                            final article = snapshot.data?.articles?[index];
                            if (article != null) {
                              return InkWell(
                                onTap: () {
                                  String newsImage = snapshot
                                      .data!.articles![index].urlToImage!;
                                  String newsTitle =
                                      snapshot.data!.articles![index].title!;
                                  String newsDate = snapshot
                                      .data!.articles![index].publishedAt!;
                                  String newsAuthor =
                                      snapshot.data!.articles![index].author!;
                                  String newsDesc = snapshot
                                      .data!.articles![index].description!;
                                  String newsContent =
                                      snapshot.data!.articles![index].content!;
                                  String newsSource = snapshot
                                      .data!.articles![index].source!.name!;
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              NewsDetailScreen(
                                                  newsImage,
                                                  newsTitle,
                                                  newsDate,
                                                  newsAuthor,
                                                  newsDesc,
                                                  newsContent,
                                                  newsSource)));
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Container(
                                    alignment: Alignment.bottomCenter,
                                    height: h * .15,
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          height: h * 0.13,
                                          width: w * 0.2,
                                          // decoration: Bor,
                                          child: CachedNetworkImage(
                                            imageUrl: snapshot.data!
                                                .articles![index].urlToImage
                                                .toString(),
                                            fit: BoxFit.cover,
                                            // placeholder: (context, url) => const Center(
                                            //     child: CircularProgressIndicator()),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(
                                              Icons.error_outline,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: w * 0.65,
                                              child: Text(
                                                snapshot.data!.articles![index]
                                                    .title
                                                    .toString(),
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                ),
                                              ),
                                            ),
                                            const Spacer(),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  snapshot
                                                      .data!
                                                      .articles![index]
                                                      .source!
                                                      .name
                                                      .toString(),
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: w * 0.4,
                                                ),
                                                Text(
                                                  DateFormat('MMM dd, yyyy')
                                                      .format(dateTime),
                                                  style: const TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.blue),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              // Handle the case where there are no articles
                              return const Text('No articles found');
                            }
                          });
                    }
                  },
                )
              ],
            ),
    );
  }
}
