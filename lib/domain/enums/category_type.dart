/// categoryType?:
/// | "sponsored" |
/// "suggested" |
/// "filter_searched_routes" |
/// "trending_routes" |
/// "post_with_routes";

enum CategoryType {
  trendingRoutes("trending_routes", "Trending"),
  sponsoredRoutes("sponsored_routes", "Sponsored"),
  suggestedRoutes("suggested_routes", "Suggested For You"),
  searchedRoutes("searched_routes", "Available Routes"),
  postWithRoutes("post_with_routes", "Available Posts");

  final String name;
  final String title;

  const CategoryType(this.name, this.title);
}
