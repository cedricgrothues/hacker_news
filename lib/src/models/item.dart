import 'package:flutter/foundation.dart' show immutable;

import 'package:json_annotation/json_annotation.dart';

part 'item.g.dart';

/// Stories, comments, jobs, Ask HNs and even polls are just [Item]s.
///
/// They're identified by their ids, which are unique integers.
@immutable
@JsonSerializable(createToJson: false)
class Item {
  /// The item's unique id.
  final int id;

  /// `true` if the item is deleted.
  @JsonKey(defaultValue: false)
  final bool? deleted;

  /// The type of item.
  final ItemType type;

  /// The username of the item's author.
  final String? by;

  /// Creation date of the item, in Unix Time.
  @JsonKey(fromJson: _unixTime)
  final DateTime time;

  /// The comment, story or poll text. HTML.
  final String? text;

  /// `true` if the item is dead.
  @JsonKey(defaultValue: false)
  final bool? dead;

  /// The comment's parent: either another
  /// comment or the relevant story.
  final int? parent;

  /// The pollopt's associated poll.
  final int? poll;

  /// The ids of the item's comments, in
  /// ranked display order.
  final List<int>? kids;

  /// The URL of the story.
  final Uri? url;

  /// The story's score, or the votes for a pollopt.
  final int? score;

  /// The title of the story, poll or job. HTML.
  final String? title;

  /// A list of related pollopts, in display order.
  final List<int>? parts;

  /// In the case of stories or polls, the total
  /// comment count.
  final int? descendants;

  /// Creates an [Item].
  const Item(
    this.id,
    this.deleted,
    this.type,
    this.by,
    this.time,
    this.text,
    this.dead,
    this.parent,
    this.poll,
    this.kids,
    this.url,
    this.score,
    this.title,
    this.parts,
    this.descendants,
  );

  /// Creates an [Item] from its JSON representation.
  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
}

/// Converts a Unix Time integer to a [DateTime] object.
DateTime _unixTime(int time) =>
    DateTime.fromMillisecondsSinceEpoch(time * 1000);

/// The type of an item.
enum ItemType { job, story, comment, pool, pollopt }
