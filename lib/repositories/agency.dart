import 'dart:async';

import 'package:dio/dio.dart';
import 'package:link/domain/api_utils/api_service.dart';
import 'package:link/models/agency.dart';

class AgencyRepo {
  static final AgencyRepo _instance = AgencyRepo.__();

  AgencyRepo.__();

  factory AgencyRepo() => _instance;

  ///
  ///
  FutureOr<List<Agency>> fetchAgencies({String? id}) async {
    Response response =
        await ApiService().getRequest("/agencies", queryParameters: {"id": id});
    List<Agency> agencies = [];

    if (response.statusCode == 200) {
      if (id != null) {
        agencies.add(Agency.fromJson(response.data[0]));
      }
      for (var agency in response.data['agencies']) {
        agencies.add(Agency.fromJson(agency as Map<String, dynamic>));
      }
      return agencies;
    } else {
      throw Exception(response.data['message']);
    }
  }
}
