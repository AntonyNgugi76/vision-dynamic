import 'dart:convert';

import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';
CommonSharedPref _sharedPrefs = CommonSharedPref();


class LoanListScreen extends StatefulWidget {
  const LoanListScreen({super.key});

  @override
  State<LoanListScreen> createState() => _LoanListScreenState();
}

class _LoanListScreenState extends State<LoanListScreen> {
  final _apiServices = APIService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Loan Information'),),
        body: FutureBuilder(
          future: _apiServices.getLoanInfo(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            Widget child = Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            );
            if (snapshot.connectionState == ConnectionState.waiting ||
                snapshot.connectionState == ConnectionState.active) {
              child = Center(
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                  ));
            } else {
              if (snapshot.hasData) {
                // emailList = snapshot.data;
                // emails = emailList!.eMAILLIST!;
                child = Container(
                  child: ListView.builder(
                    itemCount:2,
                    itemBuilder: (context, index) {
                      return InkWell(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) =>
                            //         // EmailDetailsScreen(
                            //         //     emailSubscription: emails[index]),
                            //   ),
                            // );
                          },
                          child: Column(
                            children: [
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 10, right: 10, top: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Recepient:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text('emails[index].recipient!'),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 10, right: 10, top: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Account:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text("${'emails[index].accountNumber'},"),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 10, right: 10, top: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Frequency:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        " ${'emails[index].frequency'}",
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 10, right: 10, top: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Subscribed On:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        " '{emails[index].'subscribedON'}'",
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: Divider())
                            ],
                          ));
                    },
                  ),
                );
              } else {
                child = Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }

            return child;
          },
        ),



    );
  }
}

extension ApiCall on APIService {

  Future getLoanInfo() async {
    String? res;
    EmailsList emailList = EmailsList();
    DynamicResponse dynamicResponse =
    DynamicResponse(status: StatusCode.unknown.name);
    Map<String, dynamic> requestObj = {};
    Map<String, dynamic> innerMap = {};
    innerMap["MerchantID"] = "SUBSCRIBEDEMAILLIST";
    innerMap["ModuleID"] = "VIEWEMAILSUBSCRIPTIONS";
    requestObj[RequestParam.Paybill.name] = innerMap;

    final route = await _sharedPrefs.getRoute(RouteUrl.account.name.toLowerCase());
    try {
      res = await performDioRequest(
          await dioRequestBodySetUp("PAYBILL",
              objectMap: requestObj, isAuthenticate: false),
          route: route);
      // emailList = EmailsList.fromJson(jsonDecode(res ?? "{}") ?? {});
      logger.d("emailList>>: $res");
    } catch (e) {
      // CommonUtils.showToast("Unable to get promotional images");
      AppLogger.appLogE(tag: runtimeType.toString(), message: e.toString());
      return emailList;
    }

    return emailList;
  }

}

class EmailsList {
}

