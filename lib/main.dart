import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:hacker_news/src/widgets/feed.dart';

void main() => runApp(HackerNewsApp());

/// Entry point for the application.
class HackerNewsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // The identifier for state restoration.
      restorationScopeId: 'hacker_news',

      // The list of app specific localization delegates.
      localizationsDelegates: const [
        AppLocalizations.delegate,
      ],

      // The list of locales that this app has been localized for.
      supportedLocales: const [
        Locale('en'),
        Locale('de'),
      ],

      // Use AppLocalizations to configure the correct application title
      // depending on the user's locale.
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,

      // Light color scheme.
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.indigo,
        scaffoldBackgroundColor: Colors.white,
      ),

      // Dark color scheme.
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.indigo,
        scaffoldBackgroundColor: Colors.black,
      ),

      // The widget for the default route of the app.
      home: Feed(),

      // Hides the little "DEBUG" banner in the top-right corner.
      debugShowCheckedModeBanner: false,
    );
  }
}
