import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:valitag/api_services/api_config.dart';
import 'package:valitag/model/routeList_model.dart';

import '../api_services/api_base_helper.dart';
import '../dialog/imageDialogB.dart';
import '../model/demo_model.dart';
import '../model/product_model.dart';
import '../ui/routeList/route_list.dart';
import '../ui/startScanAsset/start_scan_asset.dart';
import '../utils/common_widget.dart';
import '../utils/gox.dart';
import '../utils/navigator_service.dart';

class CommonProvider with ChangeNotifier {

 get context => NavigationService.navigatorKey.currentContext;

 RouteListModel? model;
 ProductModel? modal;
 String routeId = "";

 List<DemoModel> demoRouteList = [
  DemoModel(address: "JP Loft", startTime: "2024-04-16 09:30:00",endTime: "2024-04-16 10:00:00",
      inspectedTime: "", flagVal: 0),

  DemoModel(address: "Cyber City", startTime: "2024-04-16 10:30:00",endTime: "2024-04-16 11:00:00",
      inspectedTime: "2024-04-16 10:40:00", flagVal: 1),

  DemoModel(address: "Cyber Hub", startTime: "2024-04-16 11:00:00",endTime: "2024-04-16 11:30:00",
      inspectedTime: "2024-04-16 10:50:00", flagVal: 2),

  DemoModel(address: "Green Park", startTime: "2024-04-16 11:30:00",endTime: "2024-04-16 12:00:00",
      inspectedTime: "2024-04-16 12:40:00", flagVal: 3),

  DemoModel(address: "Sports Club", startTime: "",endTime: "",
      inspectedTime: "2024-04-16 12:55:00", flagVal: 4),

  DemoModel(address: "Play School", startTime: "",endTime: "",
      inspectedTime: "2024-04-16 13:11:00", flagVal: 5),

  DemoModel(address: "Cafe Hub", startTime: "",endTime: "",
      inspectedTime: "2024-04-16 13:11:00", flagVal: 6),
 ];



 routeListApi() async
 {
  var response = await ApiBaseHelper().getApiCall(routeList,);
  print("Route List Api hit 2:: ${response}");

  model = RouteListModel.fromJson(response);
  // GoX.goPush(const DashboardScreen());
  if (model?.status == true)
  {
     mDialog(context, RouteListDialog(title: "Route List", modeldata: model));
  }
 }

 // selectedRouteList(String? routeId, String? address ,String inspectedTime) async {
 //  String meridiemTime = "am";
 //  String hours = inspectedTime.split(":")[0];
 //
 //  if(int.parse(hours) > 12)
 //   {
 //    meridiemTime = "pm";
 //   }
 //  print("Select Route List API::  $routeId");
 //  var response = await ApiBaseHelper().getApiCall("$product?route_id=$routeId");
 //  print("Select Route List API::  $response");
 //
 //  modal = ProductModel.fromJson(response);
 //
 //  if(modal?.status == true)
 //   {
 //    GoX.goPush(const StartScanAsset());
 //     // mDialog(context, CommonImageDialogB(title: address,
 //     //  inspectedTime: inspectedTime, modal: modal, meridiemTime: meridiemTime,));
 //   }
 //  // mDialog(context, CommonImageDialogB(title: "457 Next Avenue",));
 // }

 String? formatDateTime(String? timeString) {
  print("Time String is :: ${timeString}");

  if((timeString ?? '').isNotEmpty)
   {
    DateTime dateTime = DateTime.parse(timeString!);
    String formattedTime = DateFormat.Hm().format(dateTime);
    print("Format time is :: ${formattedTime}");
    return formattedTime;
   }
  return "";
 }

 startDateTimeConvert(String startTime) {
  if((startTime ?? '').isNotEmpty)
  {
   DateTime dateTime = DateTime.parse(startTime!);
   String formattedTime = DateFormat.Hm().format(dateTime);
   print("Format time is :: ${formattedTime}");
   return formattedTime;
  }
  return "";
 }

 endDateTimeConvert(String endTime) {
  if((endTime ?? '').isNotEmpty)
  {
   DateTime dateTime = DateTime.parse(endTime!);
   String formattedTime = DateFormat.Hm().format(dateTime);
   print("Format time is :: ${formattedTime}");
   return formattedTime;
  }
  return "";
 }

 dateTimeCompare(String startTime, String endTime, String inspectedTime, int flag) {
  // String startDateTimeStr = "2024-04-15T09:00:00";
  // String endDateTimeStr = "2024-04-15T17:00:00";
  // String inspectionDateTimeStr = "2024-04-15T12:00:00";

  // Convert strings to DateTime objects (adjust for local timezone if needed)
  DateTime? startDateTime = startTime.isNotEmpty ? DateTime.parse(startTime).toLocal() : null;
  DateTime? endDateTime = endTime.isNotEmpty ? DateTime.parse(endTime).toLocal() : null;
  DateTime? inspectionDateTime = inspectedTime.isNotEmpty ? DateTime.parse(inspectedTime).toLocal() : null;

  // Determine the status based on the comparison
  String status;
  if(flag == 6)
   {
    status = "Duplicate";
    return status;
   }
  else if (startDateTime == null && endDateTime == null) {
   status = "Unscheduled";
   return status;
  } else if (inspectionDateTime == null) {
   status = "Scheduled";
   return status;
  } else {
   if (inspectionDateTime.isAfter(startDateTime!) && inspectionDateTime.isBefore(endDateTime!)) {
    status = "Inspected";
    return status;
   } else if (inspectionDateTime.isAfter(endDateTime!)) {
    status = "Late";
    return status;
   } else if (inspectionDateTime.isBefore(startDateTime)) {
    status = "Early";
    return status;
   }
   else
    {
     status = "Duplicate";
     return status;
    }
  }

 }

 meridianTimeFunc(String inspectedTime) {
  print("Inspected time is :: $inspectedTime");

    String meridiemTime = "am";
    String hours = inspectedTime.split(":")[0];

    if(int.parse(hours) > 12)
    {
     return meridiemTime = "pm";
    }

    return meridiemTime;
 }

}