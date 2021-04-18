class Breed {
  String id;
  String name;
  String animal;
  String image;
  String location;

  Breed(
    this.id,
    this.name,
    this.animal,
    this.image,
    this.location,
  );

  Breed.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    animal = json['animal'];
    image = json['image'];
    location = json['location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['animal'] = this.animal;
    data['image'] = this.image;
    data['location'] = this.location;
    return data;
  }
}
