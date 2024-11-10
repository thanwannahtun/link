// categoryType : CategoryType("trending_routes")
// limit : 5
// page : 2

import '../enums/category_type.dart';

class APIQuery {
  final CategoryType? categoryType;
  final int? limit;
  final int? page;
  final String? postId;

  APIQuery({this.categoryType, this.limit, this.page, this.postId});

  APIQuery copyWith(
      {CategoryType? categoryType, int? limit, int? page, String? postId}) {
    return APIQuery(
        categoryType: categoryType ?? this.categoryType,
        limit: limit ?? this.limit,
        postId: postId ?? this.postId,
        page: page ?? this.page);
  }

  factory APIQuery.fromJson(Map<String, dynamic> json) => APIQuery(
      categoryType:
          CategoryType.values.byName(json['categoryType'] ?? "trending_routes"),
      limit: json["limit"],
      postId: json["post_id"],
      page: json["page"]);

  Map<String, dynamic> toJson() => {
        "categoryType": categoryType?.name,
        "limit": limit,
        "page": page,
        "post_id": postId,
      };
}
