part of 'map_view.dart';

class SearchData {
  late List<Feature> features;

  SearchData.fromJson(Map<String, dynamic> json) {
    features = List.from(json['features'] ?? [])
        .map((e) => Feature.fromJson(e))
        .toList();
  }
}

class Feature {
  late num lat, lng;
  late String name, label;

  Feature.fromJson(Map<String, dynamic> json) {
    lat = json['geometry']['coordinates'][1];
    lng = json['geometry']['coordinates'][0];
    name = json['properties']['name'];
    label = json['properties']['label'];
  }
}
