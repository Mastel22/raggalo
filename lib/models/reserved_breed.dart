class ReservedBreed {
  String id;
  String name;
  String image;
  String animal;
  String uid;
  String createAt;

  ReservedBreed(
    this.id,
    this.name,
    this.image,
    this.animal,
    this.uid,
    this.createAt,
  );

  ReservedBreed.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    animal = json['animal'];
    uid = json['uid'];
    createAt = json['createAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['animal'] = this.animal;
    data['uid'] = this.uid;
    data['createAt'] = this.createAt;
    return data;
  }
}
