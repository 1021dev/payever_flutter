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