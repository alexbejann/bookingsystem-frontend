const getOrganizations = '''
query Organizations {
  organizations {
    id
    name
  }
}
''';

const String workspacesByOfficeId = r'''
query Workspaces($officeId: ID!) {
  workspaces(officeID: $officeId) {
    id
    name
    officeID
  }
}
''';

const String userBookings = r'''
query Query($userId: ID!) {
  userBookings(userID: $userId) {
    id
    title
    from
    to
    workspaceID {
      id
      name
    }
  }
}
''';

const String workspacesByOrg = r'''
query Query($organizationId: ID!) {
  workspacesByOrg(organizationID: $organizationId) {
    id
    name
    officeID {
      id
      name
    }
  }
}
''';

const String officesByOrg = r'''
query Offices($organizationId: ID!) {
  offices(organizationID: $organizationId) {
    id
    name
    organizationID {
      id
      name
    }
  }
}
''';

const String timeslotsByWorkspaceId = r'''
query Query($workspaceId: ID!) {
  workspaceTimeslots(workspaceID: $workspaceId) {
    id
    title
    to
    from
    workspaceID {
      id
      name
    }
  }
}
''';

const String workspaceTimeslots = r'''
query WorkspaceTimeslots($workspaceId: ID!) {
  workspaceTimeslots(workspaceID: $workspaceId) {
    id
    title
    from
    to
    userID
    officeID
  }
}
''';


