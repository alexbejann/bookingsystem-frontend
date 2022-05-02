import 'package:equatable/equatable.dart';
import 'package:frontend/app/model/organization.dart';

class Office extends Equatable {
  Office({
    required this.id,
    required this.name,
    this.organization,
  });

  factory Office.fromJson(Map<String, dynamic> json) => Office(
        id: json['id'] as String,
        name: json['name'] as String,
        organization: json['organizationID'] != null
            ? Organization.fromJson(
                json['organizationID'] as Map<String, dynamic>,
              )
            : null,
      );

  String id;
  String name;
  Organization? organization;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    if (organization != null) {
      map['organizationID'] = organization?.toJson();
    }
    return map;
  }

  /// return list of Offices from jsonList
  static List<Office> fromListDynamic(List<dynamic> jsonList) {
    final list = <Office>[];

    for (final element in jsonList) {
      list.add(Office.fromJson(element as Map<String, dynamic>));
    }
    return list;
  }

  @override
  List<Object?> get props => [name];
}
