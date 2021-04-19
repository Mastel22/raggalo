class User {
  String id;
  String uid;
  String names;
  String role;
  String email;
  String phone;
  String image;
  String bio;
  double fee;
  double followupFee;
  int requests;

  User(
    this.id,
    this.uid,
    this.names,
    this.role,
    this.email,
    this.phone,
    this.image,
    this.bio,
    this.fee,
    this.followupFee, {
    this.requests = 0,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'];
    names = json['names'];
    role = json['role'];
    email = json['email'];
    phone = json['phone'];
    image = json['image'];
    bio = json['bio'];
    fee = json['fee'];
    followupFee = json['followupFee'];
    requests = json['requests'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uid'] = this.uid;
    data['names'] = this.names;
    data['role'] = this.role;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['image'] = this.image;
    data['bio'] = this.bio;
    data['fee'] = this.fee;
    data['followupFee'] = this.followupFee;
    data['requests'] = this.requests;
    return data;
  }
}
