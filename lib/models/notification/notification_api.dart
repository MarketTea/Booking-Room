import 'dart:convert';

class NotificationApi {
  NotificationApi({
    this.data,
    this.metaData,
  });

  factory NotificationApi.fromJson(Map<String, dynamic> json) =>
      NotificationApi(
        data: json["data"] == null
            ? null
            : List<NotificationModel>.from(
                json["data"].map((x) => NotificationModel.fromJson(x))),
        metaData: json["meta_data"] == null
            ? null
            : MetaData.fromJson(json["meta_data"]),
      );

  factory NotificationApi.fromRawJson(String str) =>
      NotificationApi.fromJson(json.decode(str));

  List<NotificationModel> data;
  MetaData metaData;

  NotificationApi copyWith({
    List<NotificationModel> data,
    MetaData metaData,
  }) =>
      NotificationApi(
        data: data ?? this.data,
        metaData: metaData ?? this.metaData,
      );

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? null
            : List<dynamic>.from(data.map((x) => x.toJson())),
        "meta_data": metaData == null ? null : metaData.toJson(),
      };
}

class NotificationModel {
  NotificationModel({
    this.data,
    this.createdTime,
    this.id,
    this.title,
    this.body,
    this.user,
    this.v,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        createdTime: json["created_time"] == null ? null : json["created_time"],
        id: json["_id"] == null ? null : json["_id"],
        title: json["title"] == null ? null : json["title"],
        body: json["body"] == null ? null : json["body"],
        user: json["user"] == null ? null : json["user"],
        v: json["__v"] == null ? null : json["__v"],
      );

  factory NotificationModel.fromRawJson(String str) =>
      NotificationModel.fromJson(json.decode(str));

  String body;
  int createdTime;
  Data data;
  String id;
  String title;
  String user;
  int v;

  NotificationModel copyWith({
    Data data,
    int createdTime,
    String id,
    String title,
    String body,
    String user,
    int v,
  }) =>
      NotificationModel(
        data: data ?? this.data,
        createdTime: createdTime ?? this.createdTime,
        id: id ?? this.id,
        title: title ?? this.title,
        body: body ?? this.body,
        user: user ?? this.user,
        v: v ?? this.v,
      );

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        "data": data == null ? null : data.toJson(),
        "created_time": createdTime == null ? null : createdTime,
        "_id": id == null ? null : id,
        "title": title == null ? null : title,
        "body": body == null ? null : body,
        "user": user == null ? null : user,
        "__v": v == null ? null : v,
      };
}

class Data {
  Data({
    this.meetingId,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        meetingId: json["meeting_id"] == null ? null : json["meeting_id"],
      );

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String meetingId;

  Data copyWith({
    String meetingId,
  }) =>
      Data(
        meetingId: meetingId ?? this.meetingId,
      );

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        "meeting_id": meetingId == null ? null : meetingId,
      };
}

class MetaData {
  MetaData({
    this.totalRecords,
    this.limit,
    this.page,
    this.totalPage,
  });

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

  factory MetaData.fromRawJson(String str) =>
      MetaData.fromJson(json.decode(str));

  int limit;
  int page;
  int totalPage;
  int totalRecords;

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

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        "total_records": totalRecords == null ? null : totalRecords,
        "limit": limit == null ? null : limit,
        "page": page == null ? null : page,
        "total_page": totalPage == null ? null : totalPage,
      };
}
