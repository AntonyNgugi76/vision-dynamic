import 'dart:convert';

import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';
CommonSharedPref _sharedPrefs = CommonSharedPref();


class LoanRepaymentHistoryList extends StatefulWidget {
  const LoanRepaymentHistoryList({super.key});

  @override
  State<LoanRepaymentHistoryList> createState() => _LoanRepaymentHistoryListState();
}

class _LoanRepaymentHistoryListState extends State<LoanRepaymentHistoryList> {
  final _apiServices = APIService();
  @override
  void initState() {
    _apiServices.getLoanRepaymentHistory();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Loan Repayment History'),),
      body: FutureBuilder(
        future: _apiServices.getLoanRepaymentHistory(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          Widget child = const Center(
            child: CircularProgressIndicator(
              color: Colors.blue,
            ),
          );
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.active) {
            child = const Center(
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
                        child: const Column(
                          children: [
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 10, right: 10, top: 10),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Loan ID:',
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
                                      'OutstandingPrincipal:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text("${'emails[index].accountNumber'},"),
                                  ],
                                )),Padding(
                                padding: EdgeInsets.only(
                                    left: 10, right: 10, top: 10),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Dispersed Amount:',
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

                                  // LoanID
                                  // ,DispersedAmount
                                  // ,OutstandingPrincipal
                                  // ,OutstandingInterest
                                  // ,RepaymentFrequency
                                  // ,InstallmentAmount
                                  // ,InstallmentStartDate
                                  // ,ValueDate
                                  // ,MaturityDate
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Outstanding Interest:',
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
                                      'Installment Amount:',
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

  Future getLoanRepaymentHistory() async {
    String? res;
    EmailsList emailList = EmailsList();
    DynamicResponse dynamicResponse =
    DynamicResponse(status: StatusCode.unknown.name);
    Map<String, dynamic> requestObj = {};
    Map<String, dynamic> innerMap = {};
    // LoanID
    // ,DispersedAmount
    // ,OutstandingPrincipal
    // ,OutstandingInterest
    // ,RepaymentFrequency
    // ,InstallmentAmount
    // ,InstallmentStartDate
    // ,ValueDate
    // ,MaturityDate

    innerMap["MerchantID"] = "LOANREPAYMENTHISTORY";
    innerMap["ModuleID"] = "LOANHISTORY";
    requestObj[RequestParam.Paybill.name] = innerMap;

    final route = await _sharedPrefs.getRoute(RouteUrl.account.name.toLowerCase());
    try {
      res = await performDioRequest(
          await dioRequestBodySetUp("PAYBILL",
              objectMap: requestObj, isAuthenticate: false),
          route: route);
      // emailList = EmailsList.fromJson(jsonDecode(res ?? "{}") ?? {});
      logger.d("historyList>>: $res");
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

