import 'dart:convert';

class RoomModel {
  RoomModel({
    this.images,
    this.status,
    this.devices,
    this.capacity,
    this.booking,
    this.createdTime,
    this.updatedTime,
    this.id,
    this.name,
    this.location,
    this.area,
    this.userCreated,
    this.userUpdated,
    this.v,
  });

  List<dynamic> images;
  String status;
  List<dynamic> devices;
  int capacity;
  List<dynamic> booking;
  int createdTime;
  int updatedTime;
  String id;
  String name;
  dynamic location;
  String area;
  String userCreated;
  String userUpdated;
  int v;

  RoomModel copyWith({
    List<dynamic> images,
    String status,
    List<dynamic> devices,
    int capacity,
    List<dynamic> booking,
    int createdTime,
    int updatedTime,
    String id,
    String name,
    dynamic location,
    String area,
    String userCreated,
    String userUpdated,
    int v,
  }) =>
      RoomModel(
        images: images ?? this.images,
        status: status ?? this.status,
        devices: devices ?? this.devices,
        capacity: capacity ?? this.capacity,
        booking: booking ?? this.booking,
        createdTime: createdTime ?? this.createdTime,
        updatedTime: updatedTime ?? this.updatedTime,
        id: id ?? this.id,
        name: name ?? this.name,
        location: location ?? this.location,
        area: area ?? this.area,
        userCreated: userCreated ?? this.userCreated,
        userUpdated: userUpdated ?? this.userUpdated,
        v: v ?? this.v,
      );

  factory RoomModel.fromRawJson(String str) =>
      RoomModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RoomModel.fromJson(Map<String, dynamic> json) => RoomModel(
        images: json["images"] == null
            ? null
            : List<dynamic>.from(json["images"].map((x) => x)),
        status: json["status"] == null ? null : json["status"],
        devices: json["devices"] == null
            ? null
            : List<dynamic>.from(json["devices"].map((x) => x)),
        capacity: json["capacity"] == null ? null : json["capacity"],
        booking: json["booking"] == null
            ? null
            : List<dynamic>.from(json["booking"].map((x) => x)),
        createdTime: json["created_time"] == null ? null : json["created_time"],
        updatedTime: json["updated_time"] == null ? null : json["updated_time"],
        id: json["_id"] == null ? null : json["_id"],
        name: json["name"] == null ? null : json["name"],
        location: json["location"],
        area: json["area"] == null ? null : json["area"],
        userCreated: json["user_created"] == null ? null : json["user_created"],
        userUpdated: json["user_updated"] == null ? null : json["user_updated"],
        v: json["__v"] == null ? null : json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "images":
            images == null ? null : List<dynamic>.from(images.map((x) => x)),
        "status": status == null ? null : status,
        "devices":
            devices == null ? null : List<dynamic>.from(devices.map((x) => x)),
        "capacity": capacity == null ? null : capacity,
        "booking":
            booking == null ? null : List<dynamic>.from(booking.map((x) => x)),
        "created_time": createdTime == null ? null : createdTime,
        "updated_time": updatedTime == null ? null : updatedTime,
        "_id": id == null ? null : id,
        "name": name == null ? null : name,
        "location": location,
        "area": area == null ? null : area,
        "user_created": userCreated == null ? null : userCreated,
        "user_updated": userUpdated == null ? null : userUpdated,
        "__v": v == null ? null : v,
      };
}
