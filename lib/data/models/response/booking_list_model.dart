import 'booking_model.dart';
import 'dart:convert';

BookingList bookingListFromJson(String str) =>
    BookingList.fromJson(json.decode(str));

String bookingListToJson(BookingList data) => json.encode(data.toJson());

class BookingList {
  int? currentPage;
  List<BookingModel>? bookingModel;
  String? firstPageUrl;
  int? from;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;

  BookingList({
    this.currentPage,
    this.bookingModel,
    this.firstPageUrl,
    this.from,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
  });

  factory BookingList.fromJson(Map<String, dynamic> json) => BookingList(
        currentPage: json["current_page"],
        bookingModel: json["data"] == null
            ? []
            : List<BookingModel>.from(
                json["data"]!.map((x) => BookingModel.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "BookingModel": bookingModel == null
            ? []
            : List<dynamic>.from(bookingModel!.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
      };
}
