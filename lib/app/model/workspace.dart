import 'package:equatable/equatable.dart';
import 'package:frontend/app/model/office.dart';

class Workspace extends Equatable {
  Workspace({
    required this.id,
    required this.name,
    required this.office,
  });

  String id;
  String? name;
  Office? office;

  factory Workspace.fromJson(Map<String, dynamic> json) => Workspace(
        id: json['id'] as String,
        name: json['name'] != null? json['name'] as String : null,
        office: json['officeID'] != null ?
          Office.fromJson(json['officeID'] as Map<String, dynamic>) : null,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    if (office != null) {
      map['officeID'] = office?.toJson();
    }
    return map;
  }

  /// return list of Workspaces from jsonList
  static List<Workspace> fromListDynamic(List<dynamic> jsonList) {
    final list = <Workspace>[];

    for (final element in jsonList) {
      list.add(Workspace.fromJson(element as Map<String, dynamic>));
    }
    return list;
  }

  @override
  List<Object?> get props => [name];
}
