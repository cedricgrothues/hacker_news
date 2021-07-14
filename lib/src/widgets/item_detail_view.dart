import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:hacker_news/src/widgets/comment_view.dart';
import 'package:hacker_news/src/models/item.dart';
import 'package:hacker_news/src/repositories/stories.dart';

import 'package:intl/intl.dart';

/// An [ItemDetailView] displays an individual Hacker News story
/// and it's descendent comments.
class ItemDetailView extends StatefulWidget {
  /// The item that is being displayed.
  final Item item;

  /// Creates a new [ItemDetailView] with the given item.
  const ItemDetailView({Key? key, required this.item}) : super(key: key);

  @override
  _ItemDetailViewState createState() => _ItemDetailViewState();
}

class _ItemDetailViewState extends State<ItemDetailView> {
  late var future = Future.wait<Item>(
    widget.item.kids?.take(10).map(StoriesRepository.instance.item) ?? [],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Item>>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
          }

          return CustomScrollView(
            slivers: [
              CupertinoSliverRefreshControl(
                onRefresh: () async {
                  future = Future.wait<Item>(
                    widget.item.kids
                            ?.take(10)
                            .map(StoriesRepository.instance.item) ??
                        [],
                  );

                  await future;
                },
              ),

              SliverSafeArea(
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 2.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.item.title ??
                                  AppLocalizations.of(context)!.untitled,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              widget.item.url?.authority
                                      .replaceFirst('www.', '') ??
                                  'news.ycombinator.com',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  color: Theme.of(context).hintColor,
                                ),
                                children: [
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    child: Icon(
                                      Icons.arrow_upward_rounded,
                                      color: Theme.of(context).hintColor,
                                      size: 16.0,
                                    ),
                                  ),
                                  TextSpan(
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context).hintColor,
                                      height: 1.6,
                                    ),
                                    children: [
                                      TextSpan(text: '${widget.item.score} • '),
                                      TextSpan(text: widget.item.by),
                                    ],
                                  ),
                                  TextSpan(
                                    text:
                                        ' • ${DateFormat.jm().format(widget.item.time)} • ${DateFormat.yMMMMd().format(widget.item.time)}\n',
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Divider(),
                    ],
                  ),
                ),
              ),

              // Show a loading indicator while the snapshot has neither
              // completed nor failed.
              if (!snapshot.hasData && !snapshot.hasError)
                SliverFillRemaining(
                  child: CircularProgressIndicator.adaptive(),
                ),

              // Show the comments if the snapshot has completed successfully.
              if (snapshot.hasData)
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => CommentView(
                      item: snapshot.data![index],
                    ),
                    childCount: snapshot.data!.length,
                  ),
                ),

              // Show a localized error message if the snapshot has failed.
              if (snapshot.hasError)
                Text(AppLocalizations.of(context)!.itemLoadingError)
            ],
          );
        },
      ),
    );
  }
}
