import 'dart:async';

import 'package:frontend/app/model/user.dart';
import 'package:frontend/app/model/workspace.dart';
import 'package:frontend/utils/graphql/graphql_service.dart';
import 'package:frontend/utils/graphql/mutations.dart' as mutations;
import 'package:frontend/utils/graphql/queries.dart' as queries;
import 'package:graphql_flutter/graphql_flutter.dart';

class WorkspaceRepository {
  final graphQLService = GraphQLService();
  String token = '';

  Future<List<Workspace>> getWorkspaces() async {
    final user = await User.getUser();
    QueryResult? result = await graphQLService.performQuery(
      queries.workspacesByOrg
      variables: <String, dynamic>{
        'organizationId': user.organizationID,
      },
    );
    assert(result.data != null, 'getWorkspaces null');
    final resultWorkspaces = result.data!['workspacesByOrg'] as List<dynamic>;
    return Workspace.fromListDynamic(resultWorkspaces);
  }

  Future<Workspace> renameWorkspace({
    required String workspaceId,
    required String workspaceName,
  }) async {
    QueryResult? result = await graphQLService.performMutation(
      mutations.renameWorkspace,
      variables: <String, dynamic>{
        'newName': workspaceName,
        'workspaceId': workspaceId,
      },
    );
    assert(result.data != null, 'renameWorkspace null');
    final resultWorkspaces =
        result.data!['renameWorkspace'] as Map<String, dynamic>;
    return Workspace.fromJson(resultWorkspaces);
  }

  Future<Workspace> createWorkspace({
    required String officeId,
    required String workspaceName,
  }) async {
    QueryResult? result = await graphQLService.performMutation(
      mutations.addWorkspace,
      variables: <String, dynamic>{'name': workspaceName, 'officeId': officeId},
    );
    assert(result.data != null, 'createWorkspace null');
    final resultWorkspaces =
        result.data!['addWorkspace'] as Map<String, dynamic>;
    return Workspace.fromJson(resultWorkspaces);
  }

  Future<Workspace> deleteWorkspace({
    required String workspaceId,
  }) async {
    QueryResult? result = await graphQLService.performMutation(
      mutations.deleteWorkspace,
      variables: <String, dynamic>{'deleteWorkspaceId': workspaceId},
    );
    print(result.data);
    assert(result.data != null, 'deleteWorkspace null');
    final resultWorkspaces =
    result.data!['deleteWorkspace'] as Map<String, dynamic>;
    return Workspace.fromJson(resultWorkspaces);
  }
}
