import '../craft_dynamic.dart';
import 'loan_list_screen.dart';

final _sharedPrefs= CommonSharedPref();

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
  Future getLoanAccounts() async {
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