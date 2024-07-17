class Agency {
  Agency({
    this.id,
    this.userId,
    this.name,
    this.description,
    this.logo,
    this.contactInfo,
    this.address,
    this.createdAt,
  });

  final int? id;
  final int? userId;
  final String? name;
  final String? description;
  final String? logo;
  final String? contactInfo;
  final String? address;
  final String? createdAt;

  Agency copyWith({
    int? id,
    int? userId,
    String? name,
    String? description,
    String? logo,
    String? contactInfo,
    String? address,
    String? createdAt,
  }) {
    return Agency(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      logo: logo ?? this.logo,
      contactInfo: contactInfo ?? this.contactInfo,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userId": userId,
      "name": name,
      "description": description,
      "logo": logo,
      "contactInfo": contactInfo,
      "address": address,
      "createdAt": createdAt,
    };
  }

  factory Agency.fromJson(Map<String, dynamic> json) {
    return Agency(
      id: json['id'],
      userId: json['userId'],
      name: json['name'],
      description: json['description'],
      logo: json['logo'],
      contactInfo: json['contactInfo'],
      address: json['address'],
      createdAt: json['createdAt'],
    );
  }

  @override
  String toString() {
    return 'Agency{id=$id, userId=$userId, name=$name, description=$description, logo=$logo, contactInfo=$contactInfo, address=$address, createdAt=$createdAt}';
  }
}
