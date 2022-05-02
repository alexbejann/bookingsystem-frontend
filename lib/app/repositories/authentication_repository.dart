import 'dart:async';
import 'dart:convert';

import 'package:frontend/utils/graphql/graphql_service.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {
  final _controller = StreamController<AuthenticationStatus>();
  final graphQLService = GraphQLService();
  String token = '';

  Stream<AuthenticationStatus> get status async* {
    final pref = await SharedPreferences.getInstance();
    if (pref.containsKey('userAccount')) {
      // if (JwtDecoder.isExpired(this.token)) {
      //   this.deleteToken();
      //   yield AuthenticationStatus.unauthenticated;
      //   yield* _controller.stream;
      // } else {
      //   var exp = JwtDecoder.getExpirationDate(this.token);
      //   var now = DateTime.now();
      //   print('Preview Dates:  exp = $exp  now = $now');
      //   Duration difference = exp.difference(now);
      //   print('Difference now with exp is ${difference.inMinutes} minutes');
      //   print('Set timer to ${difference.inMinutes - 5} for tocken refresh');
      //   Timer.periodic(Duration(minutes: difference.inMinutes - 5), (timer) {
      //     final nowDT = DateTime.now();
      //     print('''
      //       +-------------------------------------------------------------------
      //       | Preview token expiration before refresh:
      //       +-------------------------------------------------------------------
      //       | [-] current datetime: $nowDT
      //       | [-] token expired at: $exp
      //       | [-] token: ${this.token}
      //       +-------------------------------------------------------------------
      //     ''');
      //     this.refreshToken();
      //   });
      yield AuthenticationStatus.authenticated;
      yield* _controller.stream;
    } else {
      yield AuthenticationStatus.unauthenticated;
      yield* _controller.stream;
    }
  }

  Future<String> login({
    required Map<String, dynamic> variables,
  }) async {
    assert(variables != null);
    QueryResult? result = await graphQLService.loginMutation(
      variables: variables,
    );
    if (result.hasException) {
      _controller.add(AuthenticationStatus.unauthenticated);
    } else {
      token = result.data!['login']['token'].toString();
      await persistData(result.data!['login']);
      _controller.add(AuthenticationStatus.authenticated);
    }
    return token;
  }

  Future<void> logOut() async {
    final result = await deleteToken();
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  Future<void> persistData(dynamic data) async {
    assert(data != null);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', data['token'].toString());
    await prefs.setString(
      'user',
      jsonEncode(
        <String, dynamic>{
          'username': data['username'],
          'organizationID': data['organizationID'],
          'token': data['token'],
          'admin': data['admin'],
          'id': data['id'],
        },
      ),
    );
  }

  Future<bool> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.remove('token');
  }

  void dispose() => _controller.close();
}
