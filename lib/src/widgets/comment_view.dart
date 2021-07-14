import 'package:flutter/material.dart';

import 'package:hacker_news/src/utilities/duration_localization.dart';
import 'package:hacker_news/src/models/item.dart';

/// Shows a single comment.
class CommentView extends StatelessWidget {
  /// The comment to show.
  final Item item;

  /// Creates a new [CommentView].
  CommentView({Key? key, required this.item})
      : assert(item.type == ItemType.comment),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 2.0,
          ),
          child: RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyText1,
              children: [
                TextSpan(
                  text: item.by,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                TextSpan(text: ' • ${localize(item.time)}\n'),
                WidgetSpan(
                  child: SizedBox(height: 20.0),
                ),
                TextSpan(text: item.text),
              ],
            ),
          ),
        ),
        Divider()
      ],
    );
  }
}
