import 'package:yaml/yaml.dart';

class QueeCliConfig {
  String? name;
  String? version;
  Settings? settings;

  QueeCliConfig({this.name, this.version, this.settings});

  QueeCliConfig.fromJson(YamlMap json) {
    name = json['name'];
    version = json['version'];
    settings =
        json['settings'] != null ? Settings.fromJson(json['settings']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['version'] = version;
    if (settings != null) {
      data['settings'] = settings!.toJson();
    }
    return data;
  }
}

class Settings {
  String? route;
  String? page;
  String? controller;
  String? service;
  String? jsonFolder;
  List<String>? model;

  Settings({
    this.route,
    this.page,
    this.controller,
    this.service,
    this.jsonFolder,
    this.model,
  });

  Settings.fromJson(YamlMap json) {
    route = json['route'];
    page = json['page'];
    controller = json['controller'];
    service = json['service'];
    jsonFolder = json['json'];
    model = json['model'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['route'] = route;
    data['page'] = page;
    data['controller'] = controller;
    data['service'] = service;
    data['json'] = jsonFolder;
    data['model'] = model;
    return data;
  }
}
