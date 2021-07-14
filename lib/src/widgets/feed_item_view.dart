import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:hacker_news/src/utilities/duration_localization.dart';
import 'package:hacker_news/src/widgets/item_detail_view.dart';
import 'package:hacker_news/src/models/item.dart';

import 'package:url_launcher/url_launcher.dart';

/// [FeedItemView] displays a single Hacker News item
/// in the [Feed].
class FeedItemView extends StatelessWidget {
  /// This view's position in the feed.
  final int position;

  /// The [Item] to display.
  final Item item;

  /// Creates a new [FeedItemView].
  const FeedItemView({Key? key, required this.position, required this.item})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 2.0,
            horizontal: 16.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  text: '$position. ',
                  style: TextStyle(
                    color: Theme.of(context).hintColor,
                  ),
                  children: [
                    TextSpan(
                      text: item.url?.authority.replaceFirst('www.', '') ??
                          'news.ycombinator.com',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          final url = item.url.toString();

                          if (await canLaunch(url)) {
                            launch(url);
                          }
                        },
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ItemDetailView(item: item),
                  ),
                ),
                child: RichText(
                  text: TextSpan(
                    children: [
                      WidgetSpan(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Text(
                            item.title ??
                                AppLocalizations.of(context)!.untitled,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      TextSpan(
                        style: TextStyle(color: Theme.of(context).hintColor),
                        children: [
                          TextSpan(text: '\n'),
                          TextSpan(
                            text: item.by,
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          TextSpan(
                            text: ' • ${localize(item.time)}\n',
                          ),
                          TextSpan(
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).hintColor,
                              height: 1.6,
                            ),
                            children: [
                              WidgetSpan(
                                alignment: PlaceholderAlignment.bottom,
                                child: Icon(
                                  Icons.arrow_upward_rounded,
                                  color: Theme.of(context).hintColor,
                                  size: 16.0,
                                ),
                              ),
                              TextSpan(
                                children: [
                                  TextSpan(text: '${item.score} • '),
                                  TextSpan(
                                    text: AppLocalizations.of(context)!
                                        .commentCount(item.descendants ?? 0),
                                  )
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        Divider(),
      ],
    );
  }
}
