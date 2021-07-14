import 'package:flutter/foundation.dart' show immutable;

import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

/// Users are identified by case-sensitive ids.
///
/// Only users that have public activity (comments or story submissions)
/// on the site are available through the API.
@immutable
@JsonSerializable(createToJson: false)
class User {
  /// The user's unique username. Case-sensitive.
  final String id;

  /// Creation date of the user, in Unix Time.
  final DateTime created;

  /// The user's karma.
  final int karma;

  /// The user's optional self-description. HTML.
  final String? about;

  /// List of the user's stories, polls and comments.
  final List<int>? submitted;

  /// Creates a [User].
  const User(
    this.id,
    this.created,
    this.karma,
    this.about,
    this.submitted,
  );

  /// Creates an [User] from its JSON representation.
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
