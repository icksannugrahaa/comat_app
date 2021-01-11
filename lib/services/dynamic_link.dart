import 'package:comat_apps/models/event.dart';
import 'package:comat_apps/ui/event/event_argument.dart';
import 'package:comat_apps/ui/event/event_detail.dart';
import 'package:comat_apps/ui/event/event_search.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class DynamicLinkService {
  Future handleDynamicLinks(BuildContext context, List<Event> events) async {
    final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();

    _handleDeepLink(data, context, events);

    FirebaseDynamicLinks.instance.onLink(
      onSuccess: (PendingDynamicLinkData dynamicLinkData) async {
        _handleDeepLink(dynamicLinkData, context, events);
      },
      onError: (OnLinkErrorException e) async {
        print('Dynamic link failed: ${e.message}');
      }
    );
  }
  Future<String> createEventShareLink(String title) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://comat.page.link', 
      link: Uri.parse('https://www.comat-app.com/event?title=$title'),
      androidParameters: AndroidParameters(packageName: 'com.sh.comat.comat_apps'),
      iosParameters: IosParameters(
        bundleId: 'com.sh.comat.comat_apps.ios',
        minimumVersion: '1.0',
        appStoreId: '1234567890'
      ),
      googleAnalyticsParameters: GoogleAnalyticsParameters(
        campaign: 'event-share',
        medium: 'social',
        source: 'orkut'
      ),
      itunesConnectAnalyticsParameters: ItunesConnectAnalyticsParameters(
        providerToken: '123456',
        campaignToken: 'event-share'
      )
    );

    final Uri dynamicUrl =  await parameters.buildUrl();
    return dynamicUrl.toString();
  }
  void _handleDeepLink(PendingDynamicLinkData data, BuildContext context, List <Event> events) {
    final Uri deepLink = data?.link;
    if(deepLink != null) {
      print('_handleDeepLink | deepLink $deepLink');
      print('_events | ${events[0].description}');

      var isEvent = deepLink.pathSegments.contains('event');
      if(isEvent) {
        var title = deepLink.queryParameters['title'];
        bool status = false;
        if(title != null) {
          events.forEach((element) {
            if(element.title.contains(title)) {
              status = true;
              Navigator.pushNamed(
                context,
                EventDetail.routeName,
                arguments: EventArguments(element),
              );
            }
          });
          if(!status) Navigator.pushNamed(context, '/event-not-found');
        }
      }
    }
  }
}