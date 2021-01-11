import 'dart:math';
import 'package:intl/intl.dart';
import 'package:comat_apps/ui/constant.dart';

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
    keywords.add(title);

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
  toIndoDay(String day) {
    if(day.contains("Monday")) {
      return "Senin";
    } else if(day.contains("Tuesday")) {
      return "Selasa"; 
    } else if(day.contains("Wednesday")) {
      return "Rabu"; 
    } else if(day.contains("Thursday")) {
      return "Kamis"; 
    } else if(day.contains("Friday")) {
      return "Jum'at"; 
    } else if(day.contains("Saturday")) {
      return "Sabtu"; 
    } else if(day.contains("Sunday")) {
      return "Minggu"; 
    }
  }
  toIndoMonth(String month, bool full) {
    if(month == "01" || month == "1") {
      return full ? "Januari" : "Jan";
    } else if(month == "02" || month == "2") {
      return full ? "Februari" : "Feb"; 
    } else if(month == "03" || month == "3") {
      return full ? "Maret" : "Mar"; 
    } else if(month == "04" || month == "4") {
      return full ? "April" : "Apr"; 
    } else if(month == "05" || month == "5") {
      return full ? "Mei" : "Mei"; 
    } else if(month == "06" || month == "6") {
      return full ? "Juni" : "Jun"; 
    } else if(month == "07" || month == "7") {
      return full ? "Juli" : "Jul"; 
    } else if(month == "08" || month == "8") {
      return full ? "Agustus" : "Ags"; 
    } else if(month == "09" || month == "9") {
      return full ? "September" : "Sep"; 
    } else if(month == "10" || month == "10") {
      return full ? "Oktober" : "Okt"; 
    } else if(month == "11" || month == "11") {
      return full ? "November" : "Nov"; 
    } else if(month == "12" || month == "12") {
      return full ? "Desember" : "Des"; 
    }
  }
  String encryptDecrypt(String input) {
    var output = [];
    
    for(var i = 0; i < input.length; i++) {
      var charCode = input.codeUnitAt(i) ^ key[i % key.length].codeUnitAt(0);
      output.add(new String.fromCharCode(charCode));
    }
    
    return output.join("");
  }
}
extension CapExtension on String {
  String get capitalize => "${this[0].toUpperCase()}${this.substring(1)}";
  String get allInCaps => this.toUpperCase();
  String get capitalizeFirstofEach => this.split(" ").map((str) => str.capitalize).join(" ");
}