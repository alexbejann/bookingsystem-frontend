const String login = r'''
mutation Mutation($username: String!, $password: String!) {
  login(username: $username, password: $password) {
    username
    admin
    token
    id
    organizationID
  }
}
''';

const String addOffice = r'''
mutation Mutation($name: String!, $organizationId: ID!) {
  addOffice(name: $name, organizationID: $organizationId) {
    id
    name
  }
}
''';

const String renameOffice = r'''
mutation Mutation($newName: String!, $officeId: ID!) {
  renameOffice(newName: $newName, officeID: $officeId) {
    id
    name
  }
}
''';

const String deleteOffice = r'''
mutation Mutation($deleteOfficeId: ID!) {
  deleteOffice(id: $deleteOfficeId) {
    id
  }
}
''';

const String addTimeslot = r'''
mutation Mutation($title: String!, $from: String!, $to: String!, $userId: ID!, $workspaceId: ID!) {
  addTimeslot(title: $title, from: $from, to: $to, userID: $userId, workspaceID: $workspaceId) {
    id
    title
    from
    to
  }
}
''';

const String removeTimeslot = r'''
mutation Mutation($timeslotId: ID!) {
  removeTimeslot(timeslotID: $timeslotId) {
    id
  }
}
''';

const String addWorkspace = r'''
mutation Mutation($name: String!, $officeId: ID!) {
  addWorkspace(name: $name, officeID: $officeId) {
    id
    name
  }
}
''';

const String renameWorkspace = r'''
mutation Mutation($newName: String!, $workspaceId: ID!) {
  renameWorkspace(newName: $newName, workspaceID: $workspaceId) {
    id
    name
  }
}
''';

const String deleteWorkspace = r'''
mutation Mutation($deleteWorkspaceId: ID!) {
  deleteWorkspace(id: $deleteWorkspaceId) {
    id
    name
  }
}
''';
