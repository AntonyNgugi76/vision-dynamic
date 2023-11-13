import 'package:flutter/material.dart';


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoanRepayments(),
    );
  }
}

class Statement {
  final String id;
  final String description;

  Statement(this.id, this.description);
}

class Account {
  final String id;
  final String name;
  final List<Statement> statements;

  Account(this.id, this.name, this.statements);
}

class StatementListScreen extends StatelessWidget {
  final List<Statement> statements;

  StatementListScreen(this.statements);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Statements'),
      ),
      body: ListView.builder(
        itemCount: statements.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(statements[index].description),
          );
        },
      ),
    );
  }
}

class LoanRepayments extends StatefulWidget {
  @override
  _LoanRepaymentsState createState() => _LoanRepaymentsState();
}

class _LoanRepaymentsState extends State<LoanRepayments> {
  List<Account> accounts = [
    Account(
      '1',
      'Account 1',
      [
        Statement('1', 'Statement 1'),
        Statement('2', 'Statement 2'),
      ],
    ),
    // Account(
    //   '2',
    //   'Account 2',
    //   [
    //     Statement('3', 'Statement 3'),
    //     Statement('4', 'Statement 4'),
    //   ],
    // ),
    // Add more accounts with statements as needed
  ];

  String selectedAccountId = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Statements'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Account:'),
            DropdownButton<String>(
              value: selectedAccountId,
              onChanged: (String? newValue) {
                setState(() {
                  selectedAccountId = newValue!;
                });

                // Navigate to the StatementListScreen with the selected account's statements
                Account selectedAccount = accounts.firstWhere(
                      (account) => account.id == selectedAccountId,
                  orElse: () => Account('', '', []),
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StatementListScreen(selectedAccount.statements),
                  ),
                );
              },
              items: accounts
                  .map<DropdownMenuItem<String>>((Account account) {
                return DropdownMenuItem<String>(
                  value: account.id,
                  child: Text(account.name),
                );
              })
                  .toList(),
            ),


          ],
        ),
      ),
    );
  }
}
