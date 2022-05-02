import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:frontend/add_timeslot/add_timeslot.dart';
import 'package:frontend/bookings/bookings.dart';
import 'package:frontend/chat_admin/chat_admin.dart';
import 'package:frontend/home/home.dart';
import 'package:frontend/login/login.dart';
import 'package:frontend/new_edit_office/new_edit_office.dart';
import 'package:frontend/new_edit_workspace/new_edit_workspace.dart';
import 'package:frontend/timeslots/timeslots.dart';

class BeamerLocations extends BeamLocation<BeamState> {
  BeamerLocations(RouteInformation routeInformation) : super(routeInformation);

  @override
  List<String> get pathPatterns => [
        '/login',
        '/home',
        '/home/timeslots/:workspaceId',
        '/home/addTimeslots/:workspaceId/:from',
        '/home/bookings',
        '/home/chatAdmin',
        '/home/newEditOffice',
        '/home/newEditWorkspace',
      ];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final pages = [
      if (state.uri.pathSegments.contains('login'))
        const BeamPage(
          key: ValueKey('login'),
          child: LoginPage(),
        ),
      if (state.uri.pathSegments.contains('home'))
        const BeamPage(
          key: ValueKey('home'),
          child: HomePage(),
        ),
      if (state.uri.pathSegments.contains('bookings'))
        const BeamPage(
          key: ValueKey('bookings'),
          child: MyBookingsPage(),
        ),
      if (state.uri.pathSegments.contains('chatAdmin'))
        const BeamPage(
          key: ValueKey('chatAdmin'),
          child: ChatAdmin(),
        ),
    ];
    final newEditOfficeQuery = state.queryParameters['isNew'];
    if (state.uri.pathSegments.contains('newEditOffice') &&
        newEditOfficeQuery != null) {
      pages.add(
        BeamPage(
          key: ValueKey('newEditOffice-$newEditOfficeQuery'),
          child: NewEditOfficePage(
            isNewOffice: newEditOfficeQuery.toLowerCase() == 'true',
          ),
        ),
      );
    }

    if (state.uri.pathSegments.contains('newEditWorkspace')) {
      final workspaceIdQuery = state.queryParameters['workspace'];
      pages.add(
        BeamPage(
          key: ValueKey('newEditWorkspace-$workspaceIdQuery'),
          child: NewEditWorkspacePage(
            workspaceId: state.queryParameters['workspace'],
            workspaceName: state.queryParameters['name'],
          ),
        ),
      );
    }

    final fromParameter = state.pathParameters['from'];
    final workspaceIdParameter = state.pathParameters['workspaceId'];
    if (fromParameter != null && workspaceIdParameter != null) {
      pages.add(
        BeamPage(
          fullScreenDialog: true,
          key: ValueKey('addTimeslots-$fromParameter'),
          child: AddTimeslotPage(
            workspaceId: workspaceIdParameter,
            from: DateTime.parse(fromParameter),
            to: DateTime.parse(fromParameter).add(
              const Duration(hours: 1),
            ),
          ),
        ),
      );
    }
    if (workspaceIdParameter != null && fromParameter == null) {
      pages.add(
        BeamPage(
          key: ValueKey('timeslots-$workspaceIdParameter'),
          child: TimeslotsPage(
            workspaceId: workspaceIdParameter,
          ),
        ),
      );
    }
    return pages;
  }
}
