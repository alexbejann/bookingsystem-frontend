import 'package:frontend/utils/graphql/mutations.dart' as mutations;
import 'package:frontend/utils/graphql/queries.dart' as queries;
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GraphQLService {
  GraphQLService() {
    final httpLink = HttpLink(
      'http://localhost:3000/graphql/',
    );
    Link _link;

    final authLink = AuthLink(
      getToken: () async {
        final prefs = await SharedPreferences.getInstance();
        return 'Bearer ${prefs.get('token') ?? ''}';
      },
    );

    _link = authLink.concat(httpLink);
    _client = GraphQLClient(
      link: _link,
      cache: GraphQLCache(store: InMemoryStore()),
    );
  }

  late GraphQLClient _client;

  Future<QueryResult> performQuery(
    String query, {
    required Map<String, dynamic> variables,
  }) async {
    final options = QueryOptions(document: gql(query), variables: variables);

    final result = await _client.query(options);

    return result;
  }

  Future<QueryResult> performMutation(
    String query, {
    required Map<String, dynamic> variables,
  }) async {
    final options = MutationOptions(document: gql(query), variables: variables);

    final result = await _client.mutate(options);

    print(result);

    return result;
  }

  Future<QueryResult> loginMutation({
    required Map<String, dynamic> variables,
  }) async {
    final options =
        MutationOptions(document: gql(mutations.login), variables: variables);
    final result = await _client.mutate(options);
    return result;
  }
}
