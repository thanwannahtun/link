/// categoryType?:
/// | "sponsored" |
/// "suggested" |
/// "filter_searched_routes" |
/// "trending_routes" |
/// "post_with_routes";

enum CategoryType {
  trendingRoutes("trending_routes"),
  sponsoredRoutes("sponsored_routes"),
  suggestedRoutes("suggested_routes"),
  searchedRoutes("searched_routes"),
  postWithRoutes("post_with_routes");

  final String name;

  const CategoryType(this.name);
}
