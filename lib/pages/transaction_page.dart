import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_movie/boxes.dart';
import 'package:my_movie/widget/transaction_dialog.dart';
import 'package:my_movie/models/transaction.dart';
import 'package:ndialog/ndialog.dart';

class TransactionPage extends StatefulWidget {
  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('My Movies'),
          centerTitle: true,
        ),
        body: ValueListenableBuilder<Box<Transaction>>(
          valueListenable: Boxes.getTransactions().listenable(),
          builder: (context, box, _) {
            final transactions = box.values.toList().cast<Transaction>();

            return buildContent(transactions);
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => showDialog(
            context: context,
            builder: (context) => TransactionDialog(
              onClickedDone: addTransaction,
            ),
          ),
        ),
      );

  Widget buildContent(List<Transaction> transactions) {
    final user = FirebaseAuth.instance.currentUser!;
    if (transactions.isEmpty) {
      return Center(
        child: Text(
          'Hi there ${user.displayName} lets get started',
          style: TextStyle(fontSize: 15),
        ),
      );
    }

    return Column(
      children: [
        SizedBox(height: 24),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(8),
            itemCount: transactions.length,
            itemBuilder: (BuildContext context, int index) {
              final transaction = transactions[index];

              return buildTransaction(context, transaction);
            },
          ),
        ),
      ],
    );
  }
}

Widget buildTransaction(
  BuildContext context,
  Transaction transaction,
) {
  final color = Colors.green;

  //final string = '\$' + transaction.amount.toStringAsFixed(2);

  return Card(
    color: Colors.white,
    child: ExpansionTile(
      tilePadding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      title: Text(
        transaction.name,
        maxLines: 2,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      subtitle: Text(transaction.director),
      trailing: CircleAvatar(
        radius: 30.0,
        backgroundImage: NetworkImage("${transaction.poster}"),
        backgroundColor: Colors.transparent,
      ),
      // trailing: FadeInImage(
      //     image: NetworkImage(transaction.poster),
      //     placeholder: AssetImage('assets/prop.jpg')),
      children: [
        buildButtons(context, transaction),
      ],
    ),
  );
}

Widget buildButtons(BuildContext context, Transaction transaction) => Row(
      children: [
        Expanded(
          child: TextButton.icon(
            label: Text('Edit'),
            icon: Icon(Icons.edit),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => TransactionDialog(
                  transaction: transaction,
                  onClickedDone: (name, director, poster) =>
                      editTransaction(transaction, name, director, poster),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: TextButton.icon(
            label: Text('Delete'),
            icon: Icon(Icons.delete),
            //onPressed: () => deleteTransaction(transaction),

            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return NAlertDialog(
                      title: Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 12),
                          child: Text(
                            "Delete this movie?",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                      ),
                      content: SingleChildScrollView(
                        child: SizedBox(
                          height: 20,
                        ),
                      ),
                      actions: <Widget>[
                        FlatButton(
                          child: Text(
                            "NO",
                          ),
                          textColor: Colors.white,
                          color: Colors.grey,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        FlatButton(
                          child: Text("YES"),
                          color: Colors.red,
                          textColor: Colors.white,
                          onPressed: () {
                            deleteTransaction(transaction);
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  });
            },
          ),
        )
      ],
    );

Future addTransaction(String name, String director, String poster) async {
  final transaction = Transaction()
    ..name = name
    ..director = director
    ..poster = poster;

  final box = Boxes.getTransactions();
  box.add(transaction);
}

void editTransaction(
    Transaction transaction, String name, String director, String poster) {
  transaction.name = name;
  transaction.director = director;
  transaction.poster = poster;
  transaction.save();
}

void deleteTransaction(Transaction transaction) {
  transaction.delete();
}
