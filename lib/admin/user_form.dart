import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class UserForm extends StatefulWidget {
  const UserForm({
    Key? key,
    required this.formKey,
    required this.onSubmit,
    this.initialValue = const {},
    this.titleText = 'Card',
  }) : super(key: key);

  final GlobalKey<FormBuilderState> formKey;
  final VoidCallback onSubmit;

  final Map<String, dynamic> initialValue;

  final String titleText;

  @override
  UserFormState createState() => UserFormState();
}

class UserFormState extends State<UserForm> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titleText),
      ),
      body: FormBuilder(
        key: widget.formKey,
        initialValue: widget.initialValue,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                FormBuilderTextField(
                  name: 'ItemName',
                  decoration: const InputDecoration(labelText: 'ItemName'),
                  validator: (val) {
                    if (val?.isEmpty ?? true) {
                      return 'This field is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                FormBuilderTextField(
                  name: 'Dis_Price',
                  decoration:
                      const InputDecoration(labelText: 'After Discount'),
                  validator: (val) {
                    if (val?.isEmpty ?? true) {
                      return 'This field is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                FormBuilderTextField(
                  name: 'Ori_Price',
                  decoration:
                      const InputDecoration(labelText: 'Original Price'),
                ),
                const SizedBox(height: 20),
                FormBuilderTextField(
                  name: 'Path_Link',
                  decoration: const InputDecoration(labelText: 'Path_Link'),
                  validator: (val) {
                    if (val?.isEmpty ?? true) {
                      return 'This field is required';
                    }
                    return null;
                  },
                ),
                 const SizedBox(height: 20),
                FormBuilderDropdown<String>(
                  name: 'Categories',
                  decoration: const InputDecoration(labelText: 'Categories'),
                  items: const [
                  DropdownMenuItem(value: 'Jersey', child: Text('Jersey')),
                  DropdownMenuItem(value: 'Jacket', child: Text('Jacket')),
                  DropdownMenuItem(value: 'Shoes', child: Text('Shoes')),
                  DropdownMenuItem(value: 'Ball', child: Text('Ball')),
                  DropdownMenuItem(value: 'Material', child: Text('Material')),
                  ],
                  validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'This field is required';
                  }
                  return null;
                  },
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.maxFinite,
                  child: FilledButton(
                    onPressed: () {
                      if (widget.formKey.currentState?.saveAndValidate() ??
                          false) {
                        widget.onSubmit();
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
