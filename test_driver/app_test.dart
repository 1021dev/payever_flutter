// // Imports the Flutter Driver API.
// import 'package:flutter_driver/flutter_driver.dart';
// import 'package:test/test.dart';

// void main() {

//   group('payever App', () {

//     FlutterDriver driver;
//     setUpAll(() async {
//       driver = await FlutterDriver.connect();
//     });
//     tearDownAll(() async {
//       if (driver != null) {
//         driver.close();
//       }
//     });
//     test("login with first business",() async {
//       final loginButtom = find.byValueKey('login.login');
//       final allButtom   = find.byValueKey('switcher.business.all');
//       final firstButtom = find.byValueKey('0.switcher.icon');
//       final timeline = await driver.traceAction(() async {
//         await driver.tap(loginButtom);
//         await driver.tap(allButtom);
//         await driver.tap(firstButtom);
//       });
//       final summary = new TimelineSummary.summarize(timeline);
//       summary.writeSummaryToFile('Login_Summary', pretty: true);
//     });
//     test('pick first transaction', () async {
//       final listFinder = find.byValueKey('transaction.list');
//       final cardFinder = find.byValueKey('transactions.card.open');
//       final itemFinder = find.byValueKey('transaction.list.transaction_8');
//       final timeline = await driver.traceAction(() async {
//         await driver.tap(cardFinder);
//         await driver.scrollUntilVisible(listFinder,itemFinder,dyScroll: -200.0);
//         print(driver.getText(itemFinder));
//       });
//       final summary = new TimelineSummary.summarize(timeline);
//       summary.writeSummaryToFile('Picking_Summary', pretty: true);
//     });

//   });
// }