// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rest_client_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$RestClientService extends RestClientService {
  _$RestClientService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = RestClientService;

  @override
  Future<Response<dynamic>> getPrices(
      String startDate, String endDate, String geoId) {
    final $url =
        'https://apidatos.ree.es/es/datos/mercados/precios-mercados-tiempo-real?start_date=${startDate}&end_date=${endDate}&time_trunc=hour&geo_ids=${geoId}';
    final $headers = {
      'Accept': '*/*',
    };

    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }
}
