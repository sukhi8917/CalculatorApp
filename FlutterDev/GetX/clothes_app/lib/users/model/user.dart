//main aim of this class is to convert our data to json format
class User
{
  int user_id;
  String user_name;
  String user_email;
  String user_password;

  User(
      this.user_id,
      this.user_name,
      this.user_email,
      this.user_password
      );

  //converting userData json to flutter  or normal form for login screen
  factory User.fromJson(Map<String,dynamic> json) => User(
    int.parse(json["user_id"]),
    json["user_name"],
    json["user_email"],
    json["user_password"],

  );



  //converting into json
  Map<String,dynamic> toJson() =>
      {
        'user_id':user_id.toString(),
        'user_name':user_name,
        'user_email':user_email,
        'user_password':user_password
      };
}