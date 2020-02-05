import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTransaction;

  NewTransaction(this.addTransaction);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final TextEditingController _titleTextController = TextEditingController();

  final TextEditingController _amountTextController = TextEditingController();

  DateTime _selectedDate;

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                onSubmitted: (_) => _submitData(),
                controller: _titleTextController,
                decoration: InputDecoration(
                  labelText: "Title",
                ),
              ),
              TextField(
                onSubmitted: (_) => _submitData(),
                keyboardType: TextInputType.number,
                controller: _amountTextController,
                decoration: InputDecoration(
                  labelText: "Amount",
                ),
              ),
              Container(
                height: 70,
                child: Row(
                  children: <Widget>[
                    Text(_selectedDate == null
                        ? "No date chosen."
                        : DateFormat.yMd().format(_selectedDate)),
                    FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      child: Text(
                        "Choose Date",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: _presentDatePicker,
                    )
                  ],
                ),
              ),
              RaisedButton(
                child: Text("Add Transaction"),
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).textTheme.button.color,
                onPressed: () {
                  _submitData();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void _submitData() {
    final enteredTitle = _titleTextController.text;
    if (enteredTitle.isEmpty ||
        _amountTextController.text.isEmpty && _selectedDate == null) {
      return;
    }
    final enteredAmount = double.parse(_amountTextController.text);
    widget.addTransaction(enteredTitle, enteredAmount, _selectedDate);
    Navigator.of(context).pop();
  }
}
