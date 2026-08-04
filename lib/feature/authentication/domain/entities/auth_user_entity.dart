class AuthUserEntity {
  //it is like the schema of the data that we are going to get from the api
  const AuthUserEntity({required this.id, required this.email});

  final String id;
  final String email;
}
