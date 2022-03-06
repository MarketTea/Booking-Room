import 'dart:convert';

class MetaData {
  MetaData({
    this.totalRecords,
    this.limit,
    this.page,
    this.totalPage,
  });

  int totalRecords;
  int limit;
  int page;
  int totalPage;

  MetaData copyWith({
    int totalRecords,
    String limit,
    String page,
    int totalPage,
  }) =>
      MetaData(
        totalRecords: totalRecords ?? this.totalRecords,
        limit: limit ?? this.limit,
        page: page ?? this.page,
        totalPage: totalPage ?? this.totalPage,
      );

  factory MetaData.fromRawJson(String str) =>
      MetaData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MetaData.fromJson(Map<String, dynamic> json) => MetaData(
        totalRecords: json["total_records"] == null
            ? null
            : int.tryParse(json["total_records"].toString()),
        limit: json["limit"] == null
            ? null
            : int.tryParse(json["limit"].toString()),
        page:
            json["page"] == null ? null : int.tryParse(json["page"].toString()),
        totalPage: json["total_page"] == null
            ? null
            : int.tryParse(json["total_page"].toString()),
      );

  Map<String, dynamic> toJson() => {
        "total_records": totalRecords == null ? null : totalRecords,
        "limit": limit == null ? null : limit,
        "page": page == null ? null : page,
        "total_page": totalPage == null ? null : totalPage,
      };
}
