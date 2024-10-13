import 'dart:async';

import 'package:dio/dio.dart';
import 'package:link/domain/api_utils/api_service.dart';
import 'package:link/models/agency.dart';

class AgencyRepo extends ApiService {
  static final AgencyRepo _instance = AgencyRepo.__();

  AgencyRepo.__();

  factory AgencyRepo() => _instance;

  ///
  ///
  FutureOr<List<Agency>> fetchAgencies({String? id}) async {
    Response response =
        // await getRequest("/agencies", queryParameters: {"id": id});
        await postRequest("/agencies", {}, queryParameters: {"agency_id": id});
    List<Agency> agencies = [];
    // Check if the response data and agencies key exist and are valid
    if (response.statusCode == 200 && response.data != null) {
      var agencyList = response.data['data'];

      // Make sure the 'agencies' key exists and is not null
      if (agencyList != null && agencyList is List) {
        if (id != null) {
          // Ensure there's at least one agency before accessing index 0
          if (agencyList.isNotEmpty) {
            agencies
                .add(Agency.fromJson(agencyList[0] as Map<String, dynamic>));
          } else {
            throw Exception("No agencies found with the given ID.");
          }
        } else {
          // Loop through all agencies in the response data
          for (var agency in agencyList) {
            agencies.add(Agency.fromJson(agency as Map<String, dynamic>));
          }
        }
      } else {
        throw Exception("Invalid response: 'agencies' key is missing or null.");
      }

      return agencies;
    } else {
      throw Exception(response.data['message']);
    }
  }
}
