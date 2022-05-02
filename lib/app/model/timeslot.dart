import 'package:equatable/equatable.dart';
import 'package:frontend/app/model/workspace.dart';

/// id : "626a806048199416e844e34a"
/// title : "Alex"
/// to : "2022-04-28T12:00:00.000Z"
/// from : "2022-04-28T11:00:00.000Z"
/// workspaceID : {"id":"6268e703a84eee743ad9d477"}

class Timeslot implements Equatable {
  Timeslot({
    required this.id,
    required this.title,
    required this.to,
    required this.from,
    this.workspaceID,
  });

  factory Timeslot.fromJson(Map<String, dynamic> json) => Timeslot(
        id: json['id'] as String,
        title: json['title'] as String,
        to: DateTime.fromMillisecondsSinceEpoch(
          int.parse(json['to'] as String),
        ),
        from: DateTime.fromMillisecondsSinceEpoch(
          int.parse(json['from'] as String),
        ),
        workspaceID: json['workspaceID'] != null
            ? Workspace.fromJson(
                json['workspaceID'] as Map<String, dynamic>,
              )
            : null,
      );

  String id;
  String title;
  DateTime to;
  DateTime from;
  Workspace? workspaceID;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['to'] = to;
    map['from'] = from;
    if (workspaceID != null) {
      map['workspaceID'] = workspaceID?.toJson();
    }
    return map;
  }

  /// return list of Offices from jsonList
  static List<Timeslot> fromListDynamic(List<dynamic> jsonList) {
    final list = <Timeslot>[];

    for (final element in jsonList) {
      list.add(Timeslot.fromJson(element as Map<String, dynamic>));
    }
    return list;
  }

  @override
  List<Object?> get props => [id, title, to, from, workspaceID];

  @override
  bool? get stringify => throw UnimplementedError();
}
