
import 'package:comat_apps/ui/about/about.dart';
import 'package:comat_apps/ui/authentication/login.dart';
import 'package:comat_apps/ui/custom_widget/my_splashscreen.dart';
import 'package:comat_apps/ui/event/event_create.dart';
import 'package:comat_apps/ui/event/event_detail.dart';
import 'package:comat_apps/ui/event/event_detail_management.dart';
import 'package:comat_apps/ui/event/event_manage.dart';
import 'package:comat_apps/ui/event/event_not_found.dart';
import 'package:comat_apps/ui/event/event_search.dart';
import 'package:comat_apps/ui/order/order.dart';
import 'package:comat_apps/ui/other/under_construction.dart';
import 'package:comat_apps/ui/setting/password.dart';
import 'package:comat_apps/ui/setting/profile.dart';
import 'package:comat_apps/ui/setting/setting.dart';
import 'package:comat_apps/ui/wrapper.dart';

class MyRoutes {
  var routes = {
    '/home': (_) => Wrapper(),
    '/login': (_) => LoginPage(),
    '/setting': (_) => Setting(),
    '/profile': (_) => SettingProfile(),
    '/reset-password': (_) => SettingPassword(),
    '/about': (_) => About(),
    '/under-construction': (_) => UnderConstruction(),
    '/splashscreen': (_) => SplashScreen(),
    '/event-search': (_) => EventSearch(),
    '/event-create': (_) => EventCreate(),
    // '/event-detail-management': (_) => EventDetailManagement(),
    '/event-manage': (_) => EventManage(),
    '/event-not-found': (_) => EventNotFound(),

    EventDetailManagement.routeName: (_) => EventDetailManagement(),
    OrderPage.routeName: (_) => OrderPage(),
    EventDetail.routeName: (_) => EventDetail(),
  }; 
}