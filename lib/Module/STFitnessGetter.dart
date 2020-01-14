import 'package:fit_kit/fit_kit.dart';

class STFitnessGetter {
  Future<bool> hasPermission() async{
    return true;
  }
  Future<bool> requestPermission() async{
    return await FitKit.requestPermissions(DataType.values);
  }

  Future<Map<String,dynamic>> read() async {
    print("read");
    final permissions = await FitKit.requestPermissions(DataType.values);
    if (!permissions) {
      print("User declined permissions");
      return {};
    }
    String ret = "";
    Map<String, Map<String,String>> re = new Map<String, Map<String,String>>();
    for (DataType type in DataType.values) {
      final data = await FitKit.read(
        type,
        DateTime.now().subtract(Duration(hours: 10)),
        DateTime.now(),
      );
      String results = "";
      final result = "Type $type = ${data.length} $data";
      results += result;
      // print(result);
      ret += result + "\n";
      String typeName = "$type";
      // String dataValue = "$data[0]";
      re[typeName] = {};
      if (data.length == 0) continue;
      re[typeName] = {"value":data[0].value.toString(), "dateFrom":data[0].dateFrom.toString(), "dateTo":data[0].dateTo.toString()};
      // print(dataValue);
    }
    return re;
  }

  void readAll() async {
    if (await FitKit.requestPermissions(DataType.values)) {
      for (DataType type in DataType.values) {
        final results = await FitKit.read(
          type,
          DateTime.now().subtract(Duration(days: 5)),
          DateTime.now(),
        );
      }
    }
  }

}