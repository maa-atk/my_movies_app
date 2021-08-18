import 'package:flutter/material.dart';

import 'package:my_movie/models/transaction.dart';

class TransactionDialog extends StatefulWidget {
  final Transaction? transaction;
  final Function(String name, String director, String poster) onClickedDone;

  const TransactionDialog({
    Key? key,
    this.transaction,
    required this.onClickedDone,
  }) : super(key: key);

  @override
  _TransactionDialogState createState() => _TransactionDialogState();
}

class _TransactionDialogState extends State<TransactionDialog> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final directorController = TextEditingController();
  final posterController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.transaction != null) {
      final transaction = widget.transaction!;

      nameController.text = transaction.name;
      directorController.text = transaction.director;
      posterController.text = transaction.poster;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    directorController.dispose();
    posterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.transaction != null;
    final title = isEditing ? 'Edit Movie' : 'Add new movie';

    return AlertDialog(
      title: Text(title),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 8),
              buildName(),
              SizedBox(height: 8),
              buildDirector(),
              SizedBox(height: 8),
              buildPoster(),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        buildCancelButton(context),
        buildAddButton(context, isEditing: isEditing),
      ],
    );
  }

  Widget buildName() => TextFormField(
        controller: nameController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter Name Of Movie',
        ),
        validator: (name) =>
            name != null && name.isEmpty ? 'Enter a name' : null,
      );

  Widget buildDirector() => TextFormField(
        controller: directorController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter Director',
        ),
        validator: (director) =>
            director != null && director.isEmpty ? 'Enter Director' : null,
      );

  Widget buildPoster() => TextFormField(
        controller: posterController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Poster link',
        ),
        validator: (Poster) =>
            Poster != null && Poster.isEmpty ? 'Poster link ' : null,
      );

  Widget buildCancelButton(BuildContext context) => TextButton(
        child: Text('Cancel'),
        onPressed: () => Navigator.of(context).pop(),
      );

  Widget buildAddButton(BuildContext context, {required bool isEditing}) {
    final text = isEditing ? 'Save' : 'Add';

    return TextButton(
      child: Text(text),
      onPressed: () async {
        final isValid = formKey.currentState!.validate();

        if (isValid) {
          final name = nameController.text;
          final director = directorController.text;
          final poster = posterController.text;

          widget.onClickedDone(name, director, poster);

          Navigator.of(context).pop();
        }
      },
    );
  }
}
