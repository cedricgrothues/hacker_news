import 'package:flutter/foundation.dart';

/// The type of stories to load.
@immutable
class StoryType {
  /// Newest stories.
  static const StoryType NEW = StoryType._('newstories');

  /// Top stories.
  static const StoryType TOP = StoryType._('topstories');

  /// Best stories.
  static const StoryType BEST = StoryType._('beststories');

  /// All possible values for [StoryType].
  static const List<StoryType> values = [NEW, TOP, BEST];

  /// The endpoint URL for this story type.
  final String endpoint;

  /// Creates a new [StoryType].
  const StoryType._(this.endpoint);
}
