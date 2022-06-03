import 'package:electricity/domain/entities/entities.dart';

class Utils {
  static String formatNumber0Left(int number, int len) {
    String ret = number.toString();
    if (ret.length < len) {
      for (int i = 1; i < len; i++) {
        ret = '0' + ret;
      }
    }

    return ret;
  }

  static String formatDate(DateTime dateTime) {
    return '${dateTime.day}/${formatNumber0Left(dateTime.month, 2)}/${dateTime.year}';
  }

  static List<GeoId> getGeoIds() {
    List<GeoId> geoIds = [];
    GeoId geoId = GeoId(geoId: "8741", description: "Península");
    geoIds.add(geoId);
    geoId = GeoId(geoId: "8742", description: "Canarias");
    geoIds.add(geoId);
    geoId = GeoId(geoId: "8743", description: "Baleares");
    geoIds.add(geoId);
    geoId = GeoId(geoId: "8744", description: "Ceuta");
    geoIds.add(geoId);
    geoId = GeoId(geoId: "8745", description: "Melilla");
    geoIds.add(geoId);

    return geoIds;
  }
}
