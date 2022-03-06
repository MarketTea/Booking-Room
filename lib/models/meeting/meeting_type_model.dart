import 'dart:convert';

class MeetingTypeApi {
  MeetingTypeApi({
    this.data,
    this.metaData,
  });

  List<MeetingTypeModel> data;
  MetaData metaData;

  MeetingTypeApi copyWith({
    List<MeetingTypeModel> data,
    MetaData metaData,
  }) =>
      MeetingTypeApi(
        data: data ?? this.data,
        metaData: metaData ?? this.metaData,
      );

  factory MeetingTypeApi.fromRawJson(String str) =>
      MeetingTypeApi.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MeetingTypeApi.fromJson(Map<String, dynamic> json) => MeetingTypeApi(
        data: json["data"] == null
            ? null
            : List<MeetingTypeModel>.from(
                json["data"].map((x) => MeetingTypeModel.fromJson(x))),
        metaData: json["meta_data"] == null
            ? null
            : MetaData.fromJson(json["meta_data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? null
            : List<dynamic>.from(data.map((x) => x.toJson())),
        "meta_data": metaData == null ? null : metaData.toJson(),
      };
}

class MeetingTypeModel {
  MeetingTypeModel({
    this.createdTime,
    this.updatedTime,
    this.id,
    this.name,
    this.cestronActionId,
    this.description,
    this.v,
  });

  int createdTime;
  int updatedTime;
  String id;
  String name;
  String cestronActionId;
  String description;
  int v;

  MeetingTypeModel copyWith({
    int createdTime,
    int updatedTime,
    String id,
    String name,
    String cestronActionId,
    String description,
    int v,
  }) =>
      MeetingTypeModel(
        createdTime: createdTime ?? this.createdTime,
        updatedTime: updatedTime ?? this.updatedTime,
        id: id ?? this.id,
        name: name ?? this.name,
        cestronActionId: cestronActionId ?? this.cestronActionId,
        description: description ?? this.description,
        v: v ?? this.v,
      );

  factory MeetingTypeModel.fromRawJson(String str) =>
      MeetingTypeModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MeetingTypeModel.fromJson(Map<String, dynamic> json) =>
      MeetingTypeModel(
        createdTime: json["created_time"] == null ? null : json["created_time"],
        updatedTime: json["updated_time"] == null ? null : json["updated_time"],
        id: json["_id"] == null ? null : json["_id"],
        name: json["name"] == null ? null : json["name"],
        cestronActionId: json["cestron_action_id"] == null
            ? null
            : json["cestron_action_id"],
        description: json["description"] == null ? null : json["description"],
        v: json["__v"] == null ? null : json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "created_time": createdTime == null ? null : createdTime,
        "updated_time": updatedTime == null ? null : updatedTime,
        "_id": id == null ? null : id,
        "name": name == null ? null : name,
        "cestron_action_id": cestronActionId == null ? null : cestronActionId,
        "description": description == null ? null : description,
        "__v": v == null ? null : v,
      };
}

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
