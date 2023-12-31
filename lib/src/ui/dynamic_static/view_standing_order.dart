// ignore_for_file: must_be_immutable, unnecessary_const

import 'dart:convert';

import 'package:blur/blur.dart';
import 'package:craft_dynamic/antochanges/so.dart';
import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:craft_dynamic/src/network/dynamic_request.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:pinput/pinput.dart';

final _dynamicRequest = DynamicFormRequest();
final _sharedPrefs = CommonSharedPref();
final _apiService = APIService();

class ViewStandingOrder extends StatefulWidget {
  final ModuleItem moduleItem;

  const ViewStandingOrder({required this.moduleItem, super.key});

  @override
  State<StatefulWidget> createState() => _ViewStandingOrderState();
}

class _ViewStandingOrderState extends State<ViewStandingOrder> {
  List<StandingOrder> standingOrderList = [];

  @override
  void initState() {
    // _apiService.fetchStandingOrder();
    super.initState();
  }

  getStandingOrder() => _dynamicRequest.dynamicRequest(widget.moduleItem,
      dataObj: DynamicInput.formInputValues,
      encryptedField: DynamicInput.encryptedField,
      context: context,
      listType: ListType.ViewOrderList);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: (() {
              Navigator.of(context).pop();
            }),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          title: Text(widget.moduleItem.moduleName),
        ),
        body: Stack(
          children: [
            FutureBuilder<SO>(
                future: _apiService.fetchStandingOrder(),
                builder: (BuildContext context, AsyncSnapshot<SO> snapshot) {
                  Widget child = Center(
                    child: LoadUtil(),
                  );
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      // var list = snapshot.data;
                      SO? dy = snapshot.data;
                      List<SILIST>? st = dy!.sILIST;

                      print('>>>>>Order>>>$st');
                      if (st != null && st.isNotEmpty) {
                        child = ListView.builder(
                          itemCount: st?.length,
                          itemBuilder: (context, index) {
                            return StandingOrderItem(
                              standingOrder: st[index],
                              moduleItem: widget.moduleItem,
                              refreshParent: refresh,
                            );
                          },
                        );
                      } else {
                        child = Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.warning_amber_rounded,
                                size: 122,
                                color:
                                    APIService.appPrimaryColor.withOpacity(.4),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              const Text("Nothing here!")
                            ],
                          ),
                        );
                      }
                    }
                  }
                  return child;
                }),
            Obx(() => isDeletingStandingOrder.value
                ? LoadUtil().frosted(
                    blur: 2,
                  )
                : const SizedBox())
          ],
        ));
  }

  Future<List<StandingOrder>?> _viewStandingOrder() async {
    List<StandingOrder>? orders = [];

    DynamicInput.formInputValues.clear();
    DynamicInput.formInputValues.addAll({"MerchantID": 'GETSILIST'});
    DynamicInput.formInputValues
        .addAll({"ModuleID": 'STANDINGORDERVIEWDETAILS'});
    DynamicInput.formInputValues.addAll({"HEADER": "VIEWSTANDINGORDER"});
    // DynamicInput.formInputValues.add({"INFOFIELD1": "TRANSFER"});
    var results = await _dynamicRequest.dynamicRequest(widget.moduleItem,
        dataObj: DynamicInput.formInputValues,
        context: context,
        listType: ListType.ViewOrderList);

    if (results?.status == StatusCode.success.statusCode) {
      var list = results?.dynamicList;
      AppLogger.appLogD(tag: "Standing orders", message: list);
      if (list != []) {
        list?.forEach((order) {
          try {
            Map<String, dynamic> orderJson = order;
            orders.add(StandingOrder.fromJson(orderJson));
          } catch (e) {
            AppLogger.appLogE(
                tag: "Add standing order error", message: e.toString());
          }
        });
      }
    }

    return orders;
  }

  void refresh() {
    setState(() {});
  }
}

class StandingOrderItem extends StatefulWidget {
  SILIST standingOrder;
  ModuleItem moduleItem;
  Function() refreshParent;

  StandingOrderItem(
      {Key? key,
      required this.standingOrder,
      required this.moduleItem,
      required this.refreshParent})
      : super(key: key);

  @override
  State<StandingOrderItem> createState() => _StandingOrderItemState();
}

class _StandingOrderItemState extends State<StandingOrderItem> {
  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        margin: const EdgeInsets.only(bottom: 8.0, top: 4),
        child: Material(
            elevation: 1,
            borderRadius: BorderRadius.circular(8.0),
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: IntrinsicHeight(
                    child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RowItem(
                          title: "Effective date",
                          value: widget.standingOrder.firstExecutionDate,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        RowItem(
                          title: "Debit Account",
                          value: widget.standingOrder.creditAccountID,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        RowItem(
                          title: "Amount",
                          value: widget.standingOrder.amount.toString(),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        // RowItem(
                        //   title: "Narration",
                        //   value: widget.standingOrder.narration,
                        // ),
                        const SizedBox(
                          height: 12,
                        ),
                        RowItem(
                          title: "Frequency",
                          value: widget.standingOrder.frequency,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        RowItem(
                          title: "Executions",
                          value: widget.standingOrder.noOfExecutions.toString(),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        IconButton(
                            onPressed: () {
                              _confirmDeleteAction(
                                      context,
                                      widget.standingOrder,
                                      _textEditingController)
                                  .then((value) {
                                if (value) {
                                  // isDeletingStandingOrder.value = true;
                                  // _deleteStandingOrder(,
                                  //     widget.moduleItem, context);
                                }
                              });
                            },
                            style: ButtonStyle(
                                minimumSize: MaterialStateProperty.all(
                                    const Size.fromHeight(40))),
                            icon: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.delete_outline_rounded,
                                    color: APIService.appPrimaryColor,
                                    size: 34,
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  const Text(
                                    "Terminate Order",
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 18),
                                  )
                                ]))
                      ],
                    ))
                  ],
                )))));
  }

  // _deleteStandingOrder(
  //     SILIST standingOrder, ModuleItem moduleItem, context) async {
  //   DynamicInput.formInputValues.clear();
  //   DynamicInput.formInputValues
  //       .addAll({"INFOFIELD1": standingOrder.standingOrderID});
  //   DynamicInput.formInputValues
  //       .addAll({RequestParam.MerchantID.name: moduleItem.merchantID});
  //   DynamicInput.formInputValues
  //       .addAll({RequestParam.HEADER.name: "DELETESTANDINGORDER"});
  //
  //   await _dynamicRequest
  //       .dynamicRequest(moduleItem,
  //           dataObj: DynamicInput.formInputValues,
  //           context: context,
  //           listType: ListType.ViewOrderList)
  //       .then((value) {
  //     isDeletingStandingOrder.value = false;
  //     if (value?.status == StatusCode.success.statusCode) {
  //       CommonUtils.showToast("Standing order hidden successfully");
  //       widget.refreshParent();
  //     } else {
  //       AlertUtil.showAlertDialog(
  //         context,
  //         value?.message ?? "Unable to hide standing Order",
  //       );
  //     }
  //   });
  // }

  _confirmDeleteAction(
      BuildContext context, SILIST standingOrder, TextEditingController pin) {
    return AlertUtil.showAlertDialog(
      context,
      "Confirm Termination of Standing order for debit account ${standingOrder.creditAccountID} with amount ${standingOrder.amount}",
      isConfirm: true,
      title: "Confirm",
      confirmButtonText: "Terminate",
    ).then((value) {
      Navigator.pop(context);
      showModalBottomDialogPIN(context, 'Enter PIN', pin, standingOrder);

      // Navigator.pop(context);

      //     // .then((value) {
      //   debugPrint('terminationValue>>>> $value');
      //   debugPrint('terminationValue>>>> ${value.status}');
      // if(value.status == StatusCode.success.statusCode){
      //   AlertUtil.showAlertDialog(context, value.message.toString());
      // }
      // else{
      //   AlertUtil.showAlertDialog(context, value.message.toString());
      //
      // }
    });
    // });
  }

  static showModalBottomDialogPIN(context, message,
      TextEditingController controller, SILIST standingOrder) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
      ),
      context: context,
      builder: (BuildContext context) {
        return Container(
            padding:
                const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 4),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12))),
            child: ListView(
              shrinkWrap: true,
              children: [
                SizedBox(height: 10),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [SizedBox(), Text('Enter PIN'), SizedBox()]),
                SizedBox(height: 10),
                Pinput(
                  obscureText: true,
                  controller: controller,
                ),
                SizedBox(height: 10),
                WidgetFactory.buildButton(context, () {
                  // Navigator.of(context,rootNavigator: true).pop();

                  _apiService
                      .terminateStandingOrder(
                          standingOrder.creditAccountID,
                          standingOrder.amount,
                          standingOrder.firstExecutionDate,
                          standingOrder.frequency,
                          standingOrder.lastExecutionDate,
                          controller.text,
                    standingOrder.siID,
                    standingOrder.reference,
                  )
                      .then((value) {
                      debugPrint('value>>>>>>${value.message}');
                      String? message = value.message;
                    // Navigator.pop(context);

                    if (value.status == StatusCode.success.statusCode) {
                      AlertUtil.showAlertDialog(
                          context, message!);
                    }else{
                      AlertUtil.showAlertDialog(
                          context, message!);
                    }
                  });
                  // Navigator.of(context,rootNavigator: true).pop();

                  // Navigator.of(context).pop();
                }, "Proceed")
              ],
            ));
      },
    );
  }
}

class RowItem extends StatelessWidget {
  final String title;
  String? value;

  RowItem({required this.title, this.value, super.key});

  @override
  Widget build(BuildContext context) => Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            Text(value ?? "***",
                style: const TextStyle(fontWeight: FontWeight.bold))
          ],
        ),
      ]);
}

extension ApiCall on APIService {
  Future<DynamicResponse> terminateStandingOrder(
      account, amount, startDate, frequency, endDate, String pin, siId, refrenceNo) async {
    String? res;
    DynamicResponse dynamicResponse =
        DynamicResponse(status: StatusCode.unknown.name);
    Map<String, dynamic> requestObj = {};
    Map<String, dynamic> innerMap = {};
    innerMap["MerchantID"] = "STOPSTANDINGINSTRUCTIONS";
    innerMap["ModuleID"] = "STANDINGORDERVIEWDETAILS";
    innerMap["AMOUNT"] = amount;
    innerMap["ACCOUNTID"] = account;
    innerMap["INFOFIELD3"] = siId;
    innerMap["INFOFIELD5"] = refrenceNo;
    innerMap["INFOFIELD6"] = startDate;
    innerMap["INFOFIELD7"] = frequency;
    innerMap["INFOFIELD8"] = endDate;
    innerMap["INFOFIELD10"] = "R";
    requestObj["EncryptedFields"] = {"PIN": "${CryptLib.encryptField(pin)}"};

    // encryptedPin: CryptLib.encryptField(pin);

    // innerMap["PIN"] = CryptLib.encryptField(pin);
    // "EncryptedFields":CryptLib.encryptField(pin);

    requestObj[RequestParam.Paybill.name] = innerMap;

    final route =
        await _sharedPrefs.getRoute(RouteUrl.account.name.toLowerCase());
    try {
      res = await performDioRequest(
          await dioRequestBodySetUp("PAYBILL",
              objectMap: requestObj, isAuthenticate: false),
          route: route);
      dynamicResponse = DynamicResponse.fromJson(jsonDecode(res ?? "{}") ?? {});
      logger.d("termination>>: $res");
    } catch (e) {
      // CommonUtils.showToast("Unable to get promotional images");
      AppLogger.appLogE(tag: runtimeType.toString(), message: e.toString());
      return dynamicResponse;
    }

    return dynamicResponse;
  }

  Future<SO> fetchStandingOrder() async {
    String? res;
    SO so = SO();
    // DynamicResponse dynamicResponse =
    //     DynamicResponse(status: StatusCode.unknown.name);
    Map<String, dynamic> requestObj = {};
    Map<String, dynamic> innerMap = {};
    innerMap["MerchantID"] = "GETSILIST";
    innerMap["ModuleID"] = "STANDINGORDERVIEWDETAILS";

    requestObj[RequestParam.Paybill.name] = innerMap;

    final route =
        await _sharedPrefs.getRoute(RouteUrl.account.name.toLowerCase());
    try {
      res = await performDioRequest(
          await dioRequestBodySetUp("PAYBILL",
              objectMap: requestObj, isAuthenticate: false),
          route: route);
      so = SO.fromJson(jsonDecode(res ?? "{}") ?? {});
      logger.d("fetch>>: $res");
    } catch (e) {
      // CommonUtils.showToast("Unable to get promotional images");
      AppLogger.appLogE(tag: runtimeType.toString(), message: e.toString());
      return so;
    }

    return so;
  }
//   if (results?.status == StatusCode.success.statusCode) {
//   var list = results?.dynamicList;
//   AppLogger.appLogD(tag: "Standing orders", message: list);
//   if (list != []) {
//   list?.forEach((order) {
//   try {
//   Map<String, dynamic> orderJson = order;
//   orders.add(StandingOrder.fromJson(orderJson));
//   } catch (e) {
//   AppLogger.appLogE(
//   tag: "Add standing order error", message: e.toString());
//   }
//   });
//   }
//   }
//
//   return orders;
// }
// Future<DynamicResponse> terminateStandingOrder() async {
//   String? res;
//   DynamicResponse dynamicResponse =
//       DynamicResponse(status: StatusCode.unknown.name);
//   Map<String, dynamic> requestObj = {};
//   Map<String, dynamic> innerMap = {};
//   innerMap["MerchantID"] = "ADDSTANDINGINSTRUCTIONS";
//   innerMap["INFOFIELD10"] = "R";
//
//   requestObj[RequestParam.Paybill.name] = innerMap;
//
//   final route =
//       await _sharedPrefs.getRoute(RouteUrl.account.name.toLowerCase());
//   try {
//     res = await performDioRequest(
//         await dioRequestBodySetUp("PAYBILL",
//             objectMap: requestObj, isAuthenticate: false),
//         route: route);
//     dynamicResponse = DynamicResponse.fromJson(jsonDecode(res ?? "{}") ?? {});
//     logger.d("termination>>: $res");
//   } catch (e) {
//     // CommonUtils.showToast("Unable to get promotional images");
//     AppLogger.appLogE(tag: runtimeType.toString(), message: e.toString());
//     return dynamicResponse;
//   }
//
//   return dynamicResponse;
// }

// Future<DynamicResponse> viewStandingOrder() async {
//   String? res;
//   DynamicResponse dynamicResponse =
//       DynamicResponse(status: StatusCode.unknown.name);
//   Map<String, dynamic> requestObj = {};
//   Map<String, dynamic> innerMap = {};
//   innerMap["MerchantID"] = "GETSILIST";
//   innerMap["ModuleID"] = "STANDINGORDERVIEWDETAILS";
//
//   requestObj[RequestParam.Paybill.name] = innerMap;
//
//   final route =
//       await _sharedPrefs.getRoute(RouteUrl.account.name.toLowerCase());
//   try {
//     res = await performDioRequest(
//         await dioRequestBodySetUp("PAYBILL",
//             objectMap: requestObj, isAuthenticate: false),
//         route: route);
//     dynamicResponse = DynamicResponse.fromJson(jsonDecode(res ?? "{}") ?? {});
//     logger.d("standing>>: $res");
//   } catch (e) {
//     // CommonUtils.showToast("Unable to get promotional images");
//     AppLogger.appLogE(tag: runtimeType.toString(), message: e.toString());
//     return dynamicResponse;
//   }
//
//   return dynamicResponse;
// }
// Future<List<StandingOrder>?> _viewStandingOrder() async {
//     List<StandingOrder>? orders = [];
//
//     DynamicInput.formInputValues.clear();
//     DynamicInput.formInputValues
//         .addAll({"MerchantID": ""});
//     DynamicInput.formInputValues.addAll({"HEADER": "VIEWSTANDINGORDER"});
//     // DynamicInput.formInputValues.add({"INFOFIELD1": "TRANSFER"});
//     var results = await _dynamicRequest.dynamicRequest(widget.moduleItem,
//         dataObj: DynamicInput.formInputValues,
//         context: context,
//         listType: ListType.ViewOrderList);
//
//     if (results?.status == StatusCode.success.statusCode) {
//       var list = results?.dynamicList;
//       AppLogger.appLogD(tag: "Standing orders", message: list);
//       if (list != []) {
//         list?.forEach((order) {
//           try {
//             Map<String, dynamic> orderJson = order;
//             orders.add(StandingOrder.fromJson(orderJson));
//           } catch (e) {
//             AppLogger.appLogE(
//                 tag: "Add standing order error", message: e.toString());
//           }
//         });
//       }
//     }
//
//     return orders;
//   }
}
