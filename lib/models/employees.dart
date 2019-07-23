class Employees {
  final List<UserRoles> roles;

//  final List<EmployeeGroup> groups;
  final String id;
  final bool isVerified;
  final String firstName;
  final String lastName;
  final String email;
  final String createdAt;
  final String updatedAt;
  final int v;

//  final List<EmployeePosition> position;
  final String position;
  final String idAgain;

  Employees(
      {this.roles,
      this.id,
      this.isVerified,
      this.firstName,
      this.lastName,
      this.email,
      this.createdAt,
      this.updatedAt,
      this.v,
      this.position,
      this.idAgain});

  factory Employees.fromMap(dynamic obj) {
    var rolesData = obj['roles'] as List;
    List<UserRoles> rolesDataList =
        rolesData.map((data) => UserRoles.fromMap(data)).toList();

    return Employees(
        roles: rolesDataList,
        firstName: obj['first_name'],
        lastName: obj['last_name'],
        position: obj['position'],
        email: obj['email'],
        id: obj['_id']);
  }
}

class EmployeePosition {
  final String businessId;
  final String positionType;

  EmployeePosition({this.businessId, this.positionType});

  factory EmployeePosition.fromMap(dynamic obj) {
    return EmployeePosition(
        businessId: obj['businessId'], positionType: obj['positionType']);
  }
}

enum Positions { Cashier, Sales, Marketing, Staff, Admin, Others }

class UserRoles {
  final List<UserPermissions> permission;
  final String id;
  final RoleType type;

  UserRoles({this.permission, this.id, this.type});

  factory UserRoles.fromMap(role) {
    print("role: $role");

    List<UserPermissions> permissionsDataList = [];
    if (role['permissions'] != []) {
      var permissionsData = role['permissions'] as List;
      permissionsDataList =
          permissionsData.map((data) => UserPermissions.fromMap(data)).toList();
    }

    return UserRoles(
      permission: permissionsDataList,
      id: role['_id'],
      type: RoleType.fromMap(role['type']),
    );
  }
}

class UserPermissions {
  final String id;
  final String businessId;
  final List<Acl> acls;
  final bool hasAcls;
  final int v;

  UserPermissions({this.id, this.businessId, this.acls, this.hasAcls, this.v});

  factory UserPermissions.fromMap(permissions) {
    var aclsData = permissions['acls'] as List;
    List<Acl> aclsDataList = aclsData.map((data) => Acl.fromMap(data)).toList();

    return UserPermissions(
      id: permissions['_id'],
      businessId: permissions['businessId'],
      acls: aclsDataList,
      hasAcls: permissions['hasAcls'] ?? true,
      v: permissions['__v'],
    );
  }
}

class Acl {
  final String microService;
  final bool create;
  final bool read;
  final bool update;
  final bool delete;

  Acl({this.microService, this.create, this.read, this.update, this.delete});

  factory Acl.fromMap(acl) {
    return Acl(
      microService: acl['microservice'],
      create: acl['create'],
      read: acl['read'],
      update: acl['update'],
      delete: acl['delete'],
    );
  }
}

class RoleType {
  final String id;
  final String name;

  RoleType({this.id, this.name});

  factory RoleType.fromMap(roleType) {
    return RoleType(id: roleType['_id'], name: roleType['name']);
  }
}

class EmployeeGroup {
  String name;
  String businessId;
  List<Acl> acls = List<Acl>();
}
