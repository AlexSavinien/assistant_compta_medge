import 'package:assistant_compta_medge/models/medecin/medecin_state.dart';
import 'package:assistant_compta_medge/models/workplace/workplace.dart';
import 'package:assistant_compta_medge/models/workplace/workplace_state.dart';
import 'package:assistant_compta_medge/ui/style_constants/form_style.dart';
import 'package:assistant_compta_medge/ui/views/menu/profile/add_worplace/add_workplace_viewmodel.dart';
import 'package:assistant_compta_medge/ui/views/menu/profile/profile_view/profile_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ProfileView extends HookWidget {
  final priceController = TextEditingController();
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double usableScreenSize =
        MediaQuery.of(context).size.height - Scaffold.of(context).appBarMaxHeight - 65;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: usableScreenSize,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  FlexibleInScrollView(
                    child: RowWithLeadingAndTrailing(
                      child: useProvider(medecinProvider).when(
                        data: (medecin) => Text('Prénom : ${medecin.firstname}' ?? 'Prénom'),
                        loading: () => Center(child: CircularProgressIndicator()),
                        error: (err, stack) => Text('err is $err, stack is ${stack.toString()}'),
                      ),
                      trailingChild: GestureDetector(
                        child: Icon(
                          Icons.edit_outlined,
                          color: Colors.lightBlueAccent,
                        ),
                        onTap: () {
                          showCupertinoModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return ModalTextField(
                                hintText: 'Entrez votre prénom',
                                onSubmitted: (newValue) {
                                  print('submitted');
                                  context
                                      .read(profilViewModelProvider)
                                      .updateFirstname(newFirstname: newValue);
                                  Navigator.of(context).pop();
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  FlexibleInScrollView(
                    child: RowWithLeadingAndTrailing(
                      child: useProvider(medecinProvider).when(
                        data: (medecin) => Text('Nom : ${medecin.lastname}' ?? 'Nom'),
                        loading: () => Center(child: CircularProgressIndicator()),
                        error: (err, stack) => Text('err is $err, stack is ${stack.toString()}'),
                      ),
                      trailingChild: GestureDetector(
                        child: Icon(
                          Icons.edit_outlined,
                          color: Colors.lightBlueAccent,
                        ),
                        onTap: () {
                          showCupertinoModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return ModalTextField(
                                hintText: 'Entrez votre nom',
                                onSubmitted: (newValue) {
                                  print('submitted');
                                  context
                                      .read(profilViewModelProvider)
                                      .updateLastname(newLastname: newValue);
                                  Navigator.of(context).pop();
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  FlexibleInScrollView(
                    child: RowWithLeadingAndTrailing(
                      child: useProvider(medecinProvider).when(
                        data: (medecin) => Text('Email : ${medecin.email}'),
                        loading: () => Center(child: CircularProgressIndicator()),
                        error: (err, stack) => Text('err is $err, stack is ${stack.toString()}'),
                      ),
                      trailingChild: GestureDetector(
                        child: Icon(
                          Icons.edit_outlined,
                          color: Colors.lightBlueAccent,
                        ),
                        onTap: () {
                          showCupertinoModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return ModalTextField(
                                keyBoardType: TextInputType.emailAddress,
                                hintText: 'Entrez votre nouvelle adresse mail',
                                onSubmitted: (newValue) {
                                  print('submitted');
                                  context
                                      .read(profilViewModelProvider)
                                      .updateEmail(newEmail: newValue);
                                  Navigator.of(context).pop();
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  FlexibleInScrollView(
                    child: CupertinoButton.filled(
                      child: Text('Ajouter un cabinet'),
                      onPressed: () {
                        context.read(profilViewModelProvider).navigateToAddWorkplace();
                      },
                    ),
                  ),
                  useProvider(workplacesStreamProvider).when(
                    data: (data) {
                      print('Data from workplace stream provider is ${data.toString()}');
                      if (data.length == 0) {
                        return Text('Aucun cabinet');
                      }
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 1, color: Colors.lightBlueAccent),
                        ),
                        height: usableScreenSize / 4,
                        child: ListView(
                            children: data.map((Workplace workplace) {
                          return ListTile(
                            title: Text(workplace.name),
                            trailing: GestureDetector(
                              onTap: () {
                                context
                                    .read(addWorkPlaceViewModelProvider)
                                    .deleteWorkplace(name: workplace.name);
                              },
                              child: Icon(
                                CupertinoIcons.trash_circle,
                                color: Colors.red,
                              ),
                            ),
                          );
                        }).toList()),
                      );
                    },
                    loading: () => Center(child: CircularProgressIndicator()),
                    error: (err, stack) => SingleChildScrollView(
                      child: Text('Error is $err, Stack is ${stack.toString()}'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FlexibleInScrollView extends StatelessWidget {
  const FlexibleInScrollView({Key key, this.child, this.flex = 1}) : super(key: key);

  final Widget child;
  final int flex;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.tight,
      flex: flex,
      child: Center(
        child: child,
      ),
    );
  }
}

class RowWithLeadingAndTrailing extends StatelessWidget {
  const RowWithLeadingAndTrailing({
    Key key,
    this.child,
    this.trailingChild,
  }) : super(key: key);

  final Widget child;
  final Widget trailingChild;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: child,
          ),
          Expanded(
            child: trailingChild ?? Container(),
          )
        ],
      ),
    );
  }
}

class ModalTextField extends StatelessWidget {
  const ModalTextField({Key key, this.hintText, this.onSubmitted, this.keyBoardType})
      : super(key: key);

  final String hintText;
  final Function onSubmitted;
  final TextInputType keyBoardType;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: MediaQuery.of(context).viewInsets.vertical + 100,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 25,
              ),
              TextField(
                  keyboardType: keyBoardType,
                  decoration: kTextFieldInputDecoration.copyWith(hintText: hintText),
                  onSubmitted: (newValue) {
                    onSubmitted(newValue);
                  }),
            ],
          ),
        ),
      ),
    );
    ;
  }
}
