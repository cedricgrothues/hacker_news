import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:hacker_news/src/widgets/feed_item_view.dart';
import 'package:hacker_news/src/models/item.dart';
import 'package:hacker_news/src/repositories/stories.dart';
import 'package:hacker_news/src/repositories/story_type.dart';

/// A [Feed] of top `HackerNews` stories.
class Feed extends StatefulWidget {
  /// Creates a new [Feed].
  const Feed({Key? key}) : super(key: key);

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  var future = StoriesRepository.instance.stories(
    limit: 30,
    type: StoryType.TOP,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Item>>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            // TODO: Log the error using the logging framework.
            print(snapshot.error);
          }

          return CustomScrollView(
            slivers: [
              CupertinoSliverRefreshControl(
                onRefresh: () async {
                  future = StoriesRepository.instance.stories(
                    limit: 10,
                    type: StoryType.TOP,
                  );

                  await future;
                },
              ),

              // Show a loading indicator while the snapshot has neither
              // completed nor failed.
              if (!snapshot.hasData && !snapshot.hasError)
                SliverFillRemaining(
                  child: CircularProgressIndicator.adaptive(),
                ),

              // Show the feed if the snapshot has completed successfully.
              if (snapshot.hasData)
                SliverSafeArea(
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => FeedItemView(
                        position: index + 1,
                        item: snapshot.data![index],
                      ),
                      childCount: snapshot.data!.length,
                    ),
                  ),
                ),

              // Show a localized error message if the snapshot has failed.
              if (snapshot.hasError)
                SliverFillRemaining(
                  child: Text(AppLocalizations.of(context)!.feedLoadingError),
                )
            ],
          );
        },
      ),
    );
  }
}
