import 'dart:math';
import 'package:intl/intl.dart';

class MyHelpers {
  
  static const MaxNumericDigits = 17;
  static final _random = Random();
  static final _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

  int getNumberInt(int digitCount) {
    if (digitCount > MaxNumericDigits || digitCount < 1) throw new RangeError.range(0, 1, MaxNumericDigits, "Digit Count");
    var digit = _random.nextInt(9) + 1;  // first digit must not be a zero
    int n = digit;

    for (var i = 0; i < digitCount - 1; i++) {
      digit = _random.nextInt(10);
      n *= 10;
      n += digit;
    }
    return n;
  }
  String getNumberString(int digitCount) {
    String s = "";
    for (var i = 0; i < digitCount; i++) {
      s += _random.nextInt(10).toString();
    }
    return s;
  }
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(length, (_) => _chars.codeUnitAt(_random.nextInt(_chars.length))));
  List<dynamic> makeKeywords(String title, String category, String place) {
    List<String> keywords = List<String>();
    keywords.addAll(title.toLowerCase().split(""));
    keywords.addAll(title.toUpperCase().split(""));
    keywords.addAll(title.toLowerCase().split(" "));
    keywords.addAll(title.toUpperCase().split(" "));
    keywords.addAll(title.split(" "));
    keywords.addAll(title.capitalizeFirstofEach.split(" "));
    keywords.addAll(title.capitalize.split(" "));

    keywords.addAll(category.toLowerCase().split(""));
    keywords.addAll(category.toUpperCase().split(""));
    keywords.addAll(category.toLowerCase().split(" "));
    keywords.addAll(category.toUpperCase().split(" "));
    keywords.addAll(category.split(" "));
    keywords.addAll(category.capitalizeFirstofEach.split(" "));
    keywords.addAll(category.capitalize.split(" "));


    keywords.addAll(place.toLowerCase().split(""));
    keywords.addAll(place.toUpperCase().split(""));
    keywords.addAll(place.toLowerCase().split(" "));
    keywords.addAll(place.toUpperCase().split(" "));
    keywords.addAll(place.split(" "));
    keywords.addAll(place.capitalizeFirstofEach.split(" "));
    keywords.addAll(place.capitalize.split(" "));

    return keywords;
  }

  convertDateFromString(String strDate){
    DateTime todayDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(strDate);
    return todayDate;
  }
}
extension CapExtension on String {
  String get capitalize => "${this[0].toUpperCase()}${this.substring(1)}";
  String get allInCaps => this.toUpperCase();
  String get capitalizeFirstofEach => this.split(" ").map((str) => str.capitalize).join(" ");
}