class ReservedFeedstuff {
  String id;
  String idFeedstuff;
  String name;
  String image;
  double quantity;
  String animal;
  String uid;
  String createAt;

  ReservedFeedstuff(
    this.id,
    this.idFeedstuff,
    this.name,
    this.image,
    this.quantity,
    this.animal,
    this.uid,
    this.createAt,
  );

  ReservedFeedstuff.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idFeedstuff = json['idFeedstuff'];
    name = json['name'];
    image = json['image'];
    quantity = json['quantity'];
    animal = json['animal'];
    uid = json['uid'];
    createAt = json['createAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['idFeedstuff'] = this.idFeedstuff;
    data['name'] = this.name;
    data['image'] = this.image;
    data['quantity'] = this.quantity;
    data['animal'] = this.animal;
    data['uid'] = this.uid;
    data['createAt'] = this.createAt;
    return data;
  }
}
