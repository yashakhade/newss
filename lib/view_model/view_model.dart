import 'package:newss/repository/news_repository.dart';

import '../model/news_channel_model.dart';

class NewsViewModel {
  final _rep = NewsRepository();

  Future<NewsChannelsHeadlinesModel> fetchNewsChannelHeadlinesApi(
      String type) async {
    final response = await _rep.fetchNewsChannelHeadlinesApi(type);
    return response;
  }
}
