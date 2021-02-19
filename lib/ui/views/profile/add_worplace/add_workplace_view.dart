import 'package:assistant_compta_medge/ui/style_constants/form_style.dart';
import 'package:assistant_compta_medge/ui/views/profile/add_worplace/add_workplace_viewmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

class AddWorkPlaceView extends StatelessWidget {
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
                  decoration: kTextFieldInputDecoration.copyWith(
                      hintText: 'Nom du cabinet'),
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
                      border:
                          Border.all(width: 1, color: Colors.lightBlueAccent)),
                  constraints: BoxConstraints(
                    maxHeight: 150,
                  ),
                  child: Consumer(builder: (context, watch, child) {
                    return StreamBuilder<QuerySnapshot>(
                      stream:
                          watch(addWorkPlaceViewModelProvider).getWorkplaces(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Something went wrong');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }

                        return new ListView(
                            children: snapshot.data.docs.map((doc) {
                          return ListTile(
                            title: Text(doc['name']),
                            trailing: GestureDetector(
                              onTap: () {
                                context
                                    .read(addWorkPlaceViewModelProvider)
                                    .deleteWorkplace(name: doc['name']);
                              },
                              child: Icon(
                                CupertinoIcons.trash_circle,
                                color: Colors.red,
                              ),
                            ),
                          );
                        }).toList());
                      },
                    );
                  }),
                ),
                SizedBox(
                  height: 30,
                ),
                CupertinoButton.filled(
                  onPressed: () async {
                    print('button pressed');
                    context
                        .read(addWorkPlaceViewModelProvider)
                        .navigateToMenu();
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
