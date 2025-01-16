// categoryType : CategoryType("trending_routes")
// limit : 5
// page : 2

import 'package:link/domain/api_utils/search_routes_query.dart';

import '../enums/category_type.dart';

class APIQuery {
  final CategoryType? categoryType;
  final int? limit;
  final int? page;
  final String? postId;
  final SearchRoutesQuery? searchedRouteQuery;

  APIQuery(
      {this.categoryType,
      this.limit = 5,
      this.page,
      this.postId,
      this.searchedRouteQuery});

  APIQuery copyWith(
      {CategoryType? categoryType,
      int? limit,
      int? page,
      String? postId,
      SearchRoutesQuery? searchedRouteQuery}) {
    return APIQuery(
      categoryType: categoryType ?? this.categoryType,
      limit: limit ?? this.limit,
      postId: postId ?? this.postId,
      page: page ?? this.page,
      searchedRouteQuery: searchedRouteQuery ?? this.searchedRouteQuery,
    );
  }

  factory APIQuery.fromJson(Map<String, dynamic> json) => APIQuery(
      categoryType:
          CategoryType.values.byName(json['categoryType'] ?? "trending_routes"),
      limit: json["limit"],
      postId: json["post_id"],
      page: json["page"]);

  Map<String, dynamic> toJson() {
    var searchedQuery = searchedRouteQuery?.toJson();
    return {
      "categoryType": categoryType?.name,
      "limit": limit,
      "page": page,
      "post_id": postId,

      /// for searchedRouteQuery query
      if (searchedQuery != null) ...searchedQuery,
      // Spread searchedQuery if not null
    };
  }
}
