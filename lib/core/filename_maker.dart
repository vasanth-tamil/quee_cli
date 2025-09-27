class FilenameMaker {
  String createFileName(String name, {String suffix = ''}) {
    return '${name.toLowerCase()}_$suffix.dart';
  }

  String createModelFileName(String name) =>
      createFileName(name, suffix: 'model');
  String createControllerFileName(String name) =>
      createFileName(name, suffix: 'controller');
  String createServiceFileName(String name) =>
      createFileName(name, suffix: 'service');
  String createRouteFileName(String name) =>
      createFileName(name, suffix: 'route');
  String createDialogFileName(String name) =>
      createFileName(name, suffix: 'dialog');
  String createWidgetFileName(String name) =>
      createFileName(name, suffix: 'widget');
  String createPageFileName(String name) =>
      createFileName(name, suffix: 'page');
}
