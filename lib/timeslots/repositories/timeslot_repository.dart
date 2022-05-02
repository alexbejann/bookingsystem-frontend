import 'dart:async';

import 'package:frontend/app/model/timeslot.dart';
import 'package:frontend/app/model/user.dart';
import 'package:frontend/utils/graphql/graphql_service.dart';
import 'package:frontend/utils/graphql/mutations.dart' as mutations;
import 'package:frontend/utils/graphql/queries.dart' as queries;
import 'package:graphql_flutter/graphql_flutter.dart';

class TimeslotRepository {
  final graphQLService = GraphQLService();
  String token = '';

  Future<List<Timeslot>> getTimeslots({
    required Map<String, dynamic> variables,
  }) async {
    QueryResult? result = await graphQLService.performQuery(
      queries.timeslotsByWorkspaceId
      variables: variables,
    );

    assert(result.data != null, 'workspaceTimeslots null');
    final resultWorkspaces =
        result.data!['workspaceTimeslots'] as List<dynamic>;
    return Timeslot.fromListDynamic(resultWorkspaces);
  }

  Future<Timeslot> addTimeslot({
    required Map<String, dynamic> variables,
  }) async {
    final user = await User.getUser();
    variables['title'] = user.username;
    variables['userId'] = user.id;
    QueryResult? result = await graphQLService.performQuery(
      mutations.addTimeslot
      variables: variables,
    );
    assert(result.data != null, 'addTimeslot null');
    final resultTimeslots = result.data!['addTimeslot'] as Map<String, dynamic>;
    return Timeslot.fromJson(resultTimeslots);
  }

  Future<List<Timeslot>> getBookings() async {
    final user = await User.getUser();
    QueryResult? result = await graphQLService.performQuery(
      queries.userBookings
      variables: <String, dynamic> {
        'userId': user.id,
      },
    );
    assert(result.data != null, 'userBookings null');
    final resultBookings =
    result.data!['userBookings'] as List<dynamic>;
    return Timeslot.fromListDynamic(resultBookings);
  }
}
