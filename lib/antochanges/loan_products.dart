import 'dart:convert';

import 'package:craft_dynamic/antochanges/extensions.dart';
import 'package:craft_dynamic/antochanges/loan_list_item.dart';
import 'package:craft_dynamic/antochanges/loan_products_item.dart';
import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';

CommonSharedPref _sharedPrefs = CommonSharedPref();

class LoanProductsScreen extends StatefulWidget {
  const LoanProductsScreen({super.key});

  @override
  State<LoanProductsScreen> createState() => _LoanProductsScreenState();
}

class _LoanProductsScreenState extends State<LoanProductsScreen> {
  final _apiServices = APIService();

  @override
  void initState() {
    _apiServices.getLoanInfo();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Loan Products'),
      ),
      body: FutureBuilder(
        future: _apiServices.getLoanProducts(),
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
              LoanProducts loanProducts;
              loanProducts = snapshot.data;
              var loans = loanProducts.lOANPRODUCTS!;
              child = Container(
                child: ListView.builder(
                  itemCount: loans.length,
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
                                      'Loan ID:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(loans[index].loanProductID!),
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
                                      'Name:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text("${loans[index].loanProductName},"),
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

class EmailsList {}
