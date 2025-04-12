import 'dart:async';
import 'package:Freight4u/helpers/values.dart';
import 'package:Freight4u/helpers/api.dart';
import 'package:Freight4u/helpers/get.dart';

class FormatModel extends Api {
  int id;
  String name;

  FormatModel({
    this.id = 0,
    this.name = "",
  });

  List<FormatModel> fromJson(List<dynamic> maps) {
    return maps.map((map) => fromSingleJson(map)).toList();
  }

  FormatModel fromSingleJson(dynamic map) => FormatModel(
        id: dictValidate(map, 'id', 0),
        name: dictValidate(map, 'name', ''),
      );

  Future<dynamic> get() async {
    dynamic rslt = {"ok": 0, "data": [], "message": "", "error": ""};
    try {
      String url = '$api_url/settings/app-sliders/';
      rslt = await getCalling(url, fromJson);
    } on Exception catch (exception) {
      rslt["error"] = "Something went wrong $exception";
    } catch (error) {
      rslt["error"] = "Something went wrong $error";
    } finally {
      // ignore: control_flow_in_finally

      return rslt;
    }
  }
}
