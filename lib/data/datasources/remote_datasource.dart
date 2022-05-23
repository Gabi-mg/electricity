import 'dart:convert';
import 'dart:developer';

import 'package:electricity/common/errors/exceptions.dart';
import 'package:electricity/data/models/price_response.dart';
import 'package:electricity/data/network/rest_client_service.dart';

abstract class RemoteDatasource {
  Future<PriceResponse?> getPrices(
    String starDate,
    String endDate,
    String geoId,
  );
}

class RemoteDatasourceImpl extends RemoteDatasource {
  final RestClientService restClientService;

  RemoteDatasourceImpl(this.restClientService);

  @override
  Future<PriceResponse?> getPrices(
    String starDate,
    String endDate,
    String geoId,
  ) async {
    try {
      final response =
          await restClientService.getPrices(starDate, endDate, geoId);

      if (response.isSuccessful) {
        return PriceResponse.fromJson(jsonDecode(response.body));
      }

      throw ServerException();
    } on Exception catch (e) {
      log(e.toString());
      throw ServerException();
    }
  }
}
