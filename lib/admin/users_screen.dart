import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sportshop/admin/user_form.dart';

import '../utilities/users_service.dart';

class Admin extends StatelessWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anh ADMIN',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: false,
      ),
      home: const UsersScreen(),
    );
  }
}

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Admin"),
        ),
        body: FutureBuilder<List<dynamic>>(
          future: UsersService.instance.getUsers(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data!;
              return ListView.separated(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: Image.network(
                        // Replace "Path_Link" with the actual image URL
                        data[index]['Path_Link'] ?? "Path_Link",
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(
                          "${data[index]['ItemName']} ${data[index]['Dis_Price']}"),
                      trailing: PopupMenuButton(
                          icon: const Icon(Icons.more_vert),
                          itemBuilder: (_) {
                            return [
                              PopupMenuItem(
                                child: const Text('Update'),
                                onTap: () async {
                                  final formKey = GlobalKey<FormBuilderState>();
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => UserForm(
                                        formKey: formKey,
                                        initialValue: data[index],
                                        titleText: 'Update user',
                                        onSubmit: () async {
                                          if (formKey.currentState
                                                  ?.saveAndValidate() ??
                                              false) {
                                            await UsersService.instance
                                                .updateUser(
                                                    data[index]['id'],
                                                    formKey
                                                        .currentState!.value);
                                            Navigator.of(context).pop();
                                            setState(() {});
                                          }
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                              PopupMenuItem(
                                child: const Text('Delete'),
                                onTap: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (BuildContext dialogContext) {
                                      // Use a different context for the dialog
                                      return AlertDialog.adaptive(
                                        content: const Text('Delete?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(dialogContext).pop(
                                                  false); // Close the dialog safely
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(dialogContext).pop(
                                                  true); // Close the dialog safely
                                            },
                                            child: const Text('Ok'),
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  // Ensure the dialog is closed before continuing
                                  if (confirm ?? false) {
                                    Future.microtask(() async {
                                      try {
                                        await UsersService.instance
                                            .deleteUser(data[index]['id']);
                                        debugPrint(
                                            'User deleted: ${data[index]['id']}');

                                        if (mounted) {
                                          setState(
                                              () {}); // Refresh UI after deletion
                                        }
                                      } catch (error) {
                                        debugPrint(
                                            'Error deleting user: $error');
                                      }
                                    });
                                  }
                                },
                              ),
                            ];
                          }),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider());
            }

            if (snapshot.hasError) {
              debugPrintStack(stackTrace: snapshot.stackTrace!);
              return Text(snapshot.error.toString());
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            final formKey = GlobalKey<FormBuilderState>();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => UserForm(
                  formKey: formKey,
                  titleText: 'Create Card',
                  onSubmit: () async {
                    if (formKey.currentState?.saveAndValidate() ?? false) {
                      await UsersService.instance
                          .createUser(formKey.currentState!.value);
                      Navigator.of(context).pop();
                      setState(() {});
                    }
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
