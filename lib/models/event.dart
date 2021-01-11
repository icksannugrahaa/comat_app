class Event {
  final String eid;
  final String userCreated;
  final String committeeCode; 
  final String title;
  final String description;
  final String place;
  final String date;
  final String timeStart;
  final String timeEnd;
  final String image;
  final String obtained;
  final String organizer;
  final String rundown;
  final String category;
  final String shareUrl;
  final List<String> keywords;
  final int limit;
  final int price;
  final int remains;
  final bool status;

  Event({
    this.title, 
    this.description, 
    this.timeStart, 
    this.timeEnd, 
    this.image, 
    this.limit, 
    this.remains, 
    this.status, 
    this.userCreated,
    this.committeeCode, 
    this.eid, 
    this.obtained, 
    this.organizer, 
    this.price, 
    this.keywords, 
    this.rundown, 
    this.category,
    this.place,
    this.date,
    this.shareUrl
  });
}