import 'package:assistant_compta_medge/models/workplace/workplace.dart';
import 'package:assistant_compta_medge/models/workplace/workplace_state.dart';
import 'package:assistant_compta_medge/services/authentification_service.dart';
import 'package:assistant_compta_medge/ui/style_constants/form_style.dart';
import 'package:assistant_compta_medge/ui/views/menu/profile/add_worplace/add_workplace_viewmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddWorkPlaceView extends HookWidget {
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un Cabinet'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    'Pour pouvoir ajouter des consultations, veuillez rentrer le nom du Cabinet dans lequel vous travaillez.'),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: nameController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: kTextFieldInputDecoration.copyWith(hintText: 'Nom du cabinet'),
                ),
                SizedBox(
                  height: 20,
                ),
                CupertinoButton.filled(
                  onPressed: () async {
                    print('button pressed');
                    context
                        .read(addWorkPlaceViewModelProvider)
                        .addWorkPlace(name: nameController.text);
                    FocusScope.of(context).unfocus();
                    nameController.clear();
                  },
                  child: Text('Ajouter le cabinet'),
                ),
                SizedBox(
                  height: 30,
                ),
                Text('Vos Cabinets'),
                SizedBox(
                  height: 15,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 1, color: Colors.lightBlueAccent),
                  ),
                  constraints: BoxConstraints(
                    maxHeight: 150,
                  ),
                  child: useProvider(workplacesStreamProvider).when(
                    data: (data) {
                      print('Data from workplace stream provider is ${data.toString()}');
                      if (data.length == 0) {
                        return Text('Aucun cabinet');
                      }
                      return ListView(
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
                      }).toList());
                    },
                    loading: () {
                      return CircularProgressIndicator();
                    },
                    error: (err, stack) => SingleChildScrollView(
                      child: Text('Error is $err, Stack is ${stack.toString()}'),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                CupertinoButton.filled(
                  onPressed: () async {
                    print('button pressed');
                    context.read(addWorkPlaceViewModelProvider).navigateToMenu();
                  },
                  child: Text('Suivant'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
