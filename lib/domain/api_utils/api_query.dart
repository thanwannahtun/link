// categoryType : "trending_routes"
// limit : 5
// page : 2

class APIQuery {
  final String? categoryType;
  final int? limit;
  final int? page;

  APIQuery({this.categoryType, this.limit, this.page});

  APIQuery copyWith({String? categoryType, int? limit, int? page}) {
    return APIQuery(
        categoryType: categoryType ?? this.categoryType,
        limit: limit ?? this.limit,
        page: page ?? this.page);
  }

  factory APIQuery.fromJson(Map<String, dynamic> json) => APIQuery(
      categoryType: json['categoryType'],
      limit: json["limit"],
      page: json["page"]);

  Map<String, dynamic> toJson() => {
        "categoryType": categoryType,
        "limit": limit,
        "page": page,
      };
}
