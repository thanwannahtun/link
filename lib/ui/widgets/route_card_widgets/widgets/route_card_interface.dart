import 'package:flutter/material.dart';
import 'package:link/domain/enums/category_type.dart';
import 'package:link/ui/sections/upload/route_array_upload/route_model/route_model.dart';

abstract class RouteCardInterface {
  Widget build(BuildContext context, RouteModel route, CategoryType category,
      {Map<String, dynamic>? arguments});
}
