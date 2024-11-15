import 'dart:convert';
import 'dart:math';

import 'package:reason_for_art_app/data/data_sources/api_data_sources.dart';
import 'package:reason_for_art_app/data/data_sources/shared_prefs.dart';

import '../model/artwork_model.dart';

class ArtworkRepository {
  final ApiDataSources _apiDataSources;
  final SharedPrefs _sharedPrefs;

  ArtworkRepository({required ApiDataSources apiDataSources, required SharedPrefs sharedPrefs}) : _apiDataSources = apiDataSources, _sharedPrefs = sharedPrefs;



  // Future<void> getRandomArtworkId() async {
  //   final Uri url = Uri.parse('https://api.artic.edu/api/v1/artworks');
  //
  //   final response = await _apiDataSources.get(url);
  //   final List<dynamic> jsonList = jsonDecode(response.body)['data'];
  //   urlList = jsonList.map((e) => e['api_link']).toList();
  //
  //   int totalPage = jsonDecode(response.body)['pagination']['total_pages'];
  //   String? nextUrl = jsonDecode(response.body)['pagination']['next_url'];
  //   print('1 next Url $nextUrl');
  //
  //   for (int i = 1; i < totalPage; i++) {
  //     if (nextUrl != null) {
  //       final Uri url = Uri.parse(nextUrl);
  //       final response = await _apiDataSources.get(url);
  //
  //       final List<dynamic> jsonList = jsonDecode(response.body)['data'];
  //       urlList.addAll(jsonList.map((e) => e['api_link']));
  //       imageList.addAll(jsonList.map((e) => e['image_id']));
  //       print('image List: $imageList');
  //
  //       nextUrl = jsonDecode(response.body)['pagination']['next_url'];
  //       print('2 next Url $nextUrl');
  //     } else {
  //       print('break');
  //       break;
  //     }
  //   }
  // }

  List urlList = [];
  Uri url = Uri.parse('https://api.artic.edu/api/v1/artworks');

  Future<List<ArtworkModel>> getArtworkList() async {
    final response = await _apiDataSources.get(url);
    final List<dynamic> jsonList = jsonDecode(response.body)['data'];
    print('ArtworkRepository getArtworkList: $url');

    url = Uri.parse(jsonDecode(response.body)['pagination']['next_url']);
    print('ArtworkRepository getArtworkList: $url');

    return jsonList.map((e) => ArtworkModel.fromJson(e)).toList();
  }

  Future<void> getRandomArtworkId() async {
    final Uri url = Uri.parse('https://api.artic.edu/api/v1/artworks');

    final response = await _apiDataSources.get(url);
    final List<dynamic> jsonList = jsonDecode(response.body)['data'];
    urlList = jsonList.map((e) => e['api_link']).toList();

    int totalPage = jsonDecode(response.body)['pagination']['total_pages'];
    String? nextUrl = jsonDecode(response.body)['pagination']['next_url'];
    print('ArtworkRepository getRandomArtworkId: 1 next Url $nextUrl');

    for (int i = 1; i < 10; i++) {
      if (nextUrl != null) {
        final Uri url = Uri.parse(nextUrl);
        final response = await _apiDataSources.get(url);

        final List<dynamic> jsonList = jsonDecode(response.body)['data'];
        urlList.addAll(jsonList.map((e) => e['api_link']));

        nextUrl = jsonDecode(response.body)['pagination']['next_url'];
        print('ArtworkRepository getRandomArtworkId: 2 next Url $nextUrl');
      } else {
        print('ArtworkRepository getRandomArtworkId: break');
        break;
      }
    }
  }

  Future<ArtworkModel> getRandomArtworkUrl() async {
    final String randomArtworkUrl = urlList[Random().nextInt(urlList.length)];
    print(urlList);

    return getRandomArtworkModel(randomArtworkUrl: randomArtworkUrl);
  }

  Future<ArtworkModel> getRandomArtworkModel({required String randomArtworkUrl}) async {
    final Uri url = Uri.parse(randomArtworkUrl);
    print('_getRandomArtworkModel url: $url');

    final response = await _apiDataSources.get(url);

    if (response.statusCode == 404) return await getRandomArtworkUrl();
    if (jsonDecode(response.body)['data']['image_id'] == null) return await getRandomArtworkUrl();
    if (jsonDecode(response.body)['data']['description'] == null) return await getRandomArtworkUrl();
    // if (ArtworkModel.fromJson(jsonDecode(response.body)).description == null) return await getRandomArtworkModel();
    print(jsonDecode(response.body)['data']);

    final Map<String, dynamic> jsonMap = jsonDecode(response.body)['data'];
    return ArtworkModel.fromJson(jsonMap);
  }

  // Future<ArtworkModel> getRandomArtworkModel() async {
  //   await _getRandomArtworkId();
  //   final String randomArtworkUrl = urlList[Random().nextInt(urlList.length)];
  //   final Uri url = Uri.parse(randomArtworkUrl);
  //   print('getRandomArtworkModel url: $url');
  //
  //   final response = await _apiDataSources.get(url);
  //
  //   if (response.statusCode == 404) return await getRandomArtworkModel();
  //   if (ArtworkModel.fromJson(jsonDecode(response.body)).imageId == null &&
  //       ArtworkModel.fromJson(jsonDecode(response.body)).description == null) {
  //     return await getRandomArtworkModel();
  //   }
  //   print(jsonDecode(response.body)['data']);
  //
  //   final Map<String, dynamic> jsonMap = jsonDecode(response.body)['data'];
  //   return ArtworkModel.fromJson(jsonMap);
  // }

  // List idList = [];
  //
  // Future<void> getRandomArtworkId() async {
  //   final Uri url = Uri.parse('https://api.artic.edu/api/v1/artworks');
  //
  //   final response = await _apiDataSources.get(url);
  //   final List<dynamic> jsonList = jsonDecode(response.body)['data'];
  //   idList = jsonList.map((e) => e['api_link']).toList();
  //
  //   int totalPage = jsonDecode(response.body)['pagination']['total_pages'];
  //   String? nextUrl = jsonDecode(response.body)['pagination']['next_url'];
  //   print('1 next Url $nextUrl');
  //
  //   for (int i = 1; i < 5; i++) {
  //     if (nextUrl != null) {
  //       final Uri url = Uri.parse(nextUrl);
  //       final response = await _apiDataSources.get(url);
  //
  //       final List<dynamic> jsonList = jsonDecode(response.body)['data'];
  //       idList.addAll(jsonList.map((e) => e['api_link']));
  //
  //       nextUrl = jsonDecode(response.body)['pagination']['next_url'];
  //       print('2 next Url $nextUrl');
  //     }
  //   }
  //
  //   await getRandomArtworkModel();
  // }
  //
  // Future<ArtworkModel> getRandomArtworkModel() async {
  //   final String randomArtworkUrl = idList[Random().nextInt(idList.length)];
  //   final Uri url = Uri.parse(randomArtworkUrl);
  //   print('getRandomArtworkModel url: $url');
  //
  //   final response = await _apiDataSources.get(url);
  //
  //   if (response.statusCode == 404) return await getRandomArtworkModel();
  //   if (ArtworkModel.fromJson(jsonDecode(response.body)).imageId == null && ArtworkModel.fromJson(jsonDecode(response.body)).description == null) return await getRandomArtworkModel();
  //   print(jsonDecode(response.body)['data']);
  //
  //   final Map<String, dynamic> jsonMap = jsonDecode(response.body)['data'];
  //   return ArtworkModel.fromJson(jsonMap);
  // }
}