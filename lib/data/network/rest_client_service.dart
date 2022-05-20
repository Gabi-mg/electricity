import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:electricity/common/utils/constants.dart';
import 'package:electricity/data/models/price_response.dart';

part "rest_client_service.chopper.dart";

@ChopperApi(baseUrl: apiBaseUrl)
abstract class RestClientService extends ChopperService {
  @Get(
      headers: {'Accept': '*/*'},
      path: '/es/datos/mercados/precios-mercados-tiempo-real?'
          'start_date={startDate}&end_date={endDate}&'
          'time_trunc=hour&geo_ids={geoId}')
  Future<Response> getPrices(
    @Path() String startDate,
    @Path() String endDate,
    @Path() String geoId,
  );

  static RestClientService create(ChopperClient client) {
    return  _$RestClientService(client);
  }
}
