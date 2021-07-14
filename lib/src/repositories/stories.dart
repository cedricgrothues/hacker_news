import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:hacker_news/src/utilities/cache.dart';
import 'package:hacker_news/src/models/item.dart';
import 'package:hacker_news/src/models/user.dart';
import 'package:hacker_news/src/repositories/story_type.dart';

import 'package:http/http.dart';

/// The [StoriesRepository] manages loading and caching of
/// Hacker News items and users.
@immutable
class StoriesRepository {
  final Client _client;

  final Cache<int, Item> _itemCache;
  final Cache<String, User> _userCache;

  /// Creates a [StoriesRepository] with an optional [Client]
  /// and [maximumCacheSize], which defaults to `500`.
  StoriesRepository([Client? client, int maximumCacheSize = 500])
      : _client = client ?? Client(),
        _itemCache = Cache()..maximumSize = maximumCacheSize,
        _userCache = Cache()..maximumSize = maximumCacheSize;

  /// Returns a static instance of [StoriesRepository].
  static StoriesRepository instance = StoriesRepository();

  static const _authority = 'hacker-news.firebaseio.com';

  /// Retrieves [limit] stories for [type] from the Hacker News API.
  Future<List<Item>> stories(
      {int limit = 40, StoryType type = StoryType.TOP}) async {
    final response =
        await _client.get(Uri.https(_authority, '/v0/${type.endpoint}.json'));

    if (response.statusCode < 200 || response.statusCode >= 300)
      throw StateError('Invalid Status Code (${response.statusCode})');

    return Future.wait(
      List.castFrom<dynamic, int>(json.decode(response.body))
          .take(limit)
          .map(item),
    );
  }

  /// Returns the item with the given [id].
  Future<Item> item(int id) => _itemCache.putIfAbsent(
        id,
        () => _client.get(Uri.https(_authority, '/v0/item/$id.json')).then(
          (response) {
            if (response.statusCode < 200 || response.statusCode >= 300)
              throw StateError('Invalid Status Code (${response.statusCode})');

            return Item.fromJson(json.decode(response.body));
          },
        ),
      );

  /// Returns the user with the given [id].
  Future<User> user(String id) => _userCache.putIfAbsent(
        id,
        () => _client.get(Uri.https(_authority, '/v0/user/$id.json')).then(
          (response) {
            if (response.statusCode < 200 || response.statusCode >= 300)
              throw StateError('Invalid Status Code (${response.statusCode})');

            return User.fromJson(json.decode(response.body));
          },
        ),
      );
}
