class Feedstuff {
  String id;
  String name;
  String expDate;
  String image;
  String ingredients;
  double quantity;
  String animal;
  String location;

  Feedstuff(
    this.id,
    this.name,
    this.expDate,
    this.image,
    this.ingredients,
    this.quantity,
    this.animal,
    this.location,
  );

  Feedstuff.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    expDate = json['expDate'];
    image = json['image'];
    ingredients = json['ingredients'];
    quantity = double.parse(json['quantity'].toString());
    animal = json['animal'];
    location = json['location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['expDate'] = this.expDate;
    data['image'] = this.image;
    data['ingredients'] = this.ingredients;
    data['quantity'] = this.quantity;
    data['animal'] = this.animal;
    data['location'] = this.location;
    return data;
  }
}
