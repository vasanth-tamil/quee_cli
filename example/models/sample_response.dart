class SampleResponse {
  String? name;
  String? email;
  String? phone;
  String? company;
  String? position;
  Address? address;
  SampleResponse({this.name, this.email, this.phone, this.company, this.position, this.address, });

  SampleResponse.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    company = json['company'];
    position = json['position'];
    address = json['address'] != null ? Address.fromJson(json['address']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (name != null) {
      data['name'] = name;
    }
    if (email != null) {
      data['email'] = email;
    }
    if (phone != null) {
      data['phone'] = phone;
    }
    if (company != null) {
      data['company'] = company;
    }
    if (position != null) {
      data['position'] = position;
    }
    if (address != null) {
      data['address'] = address!.toJson();
    }
    return data;
  }
}

class Address {
  String? street;
  String? city;
  String? state;
  String? zip;
  Address({this.street, this.city, this.state, this.zip, });

  Address.fromJson(Map<String, dynamic> json) {
    street = json['street'];
    city = json['city'];
    state = json['state'];
    zip = json['zip'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (street != null) {
      data['street'] = street;
    }
    if (city != null) {
      data['city'] = city;
    }
    if (state != null) {
      data['state'] = state;
    }
    if (zip != null) {
      data['zip'] = zip;
    }
    return data;
  }
}