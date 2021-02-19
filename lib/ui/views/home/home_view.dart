import 'package:assistant_compta_medge/models/consultation/consultation_state.dart';
import 'package:assistant_compta_medge/models/medecin/medecin_state.dart';
import 'package:assistant_compta_medge/models/workplace/workplace_state.dart';
import 'package:assistant_compta_medge/ui/style_constants/form_style.dart';
import 'package:assistant_compta_medge/ui/views/home/home_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:smart_select/smart_select.dart';

class HomeView extends ConsumerWidget {
  final priceController = TextEditingController();
  final noteController = TextEditingController();
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    print('MenuView');
    var workplaceState = watch(workplaceNotifierProvider.state);
    var consultationState = watch(consultationNotifierProvider.state);
    var medecinState = watch(medecinNotifierProvider.state);
    // priceController.text = consultationState.price.toString();
    // noteController.text = consultationState.note;
    // print('Workspaces : ${medecinState.workplaces.toString()}');

    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      appBar: AppBar(
        title: Text('Ajouter une consultation'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    DropdownButton<String>(
                        value: workplaceState.name,
                        icon: Icon(CupertinoIcons.down_arrow),
                        hint: Text('Choisissez un cabinet'),
                        onChanged: (newValue) {
                          context
                              .read(workplaceNotifierProvider)
                              .setName(newName: newValue);
                        },
                        items: medecinState.workplaces
                            .map<DropdownMenuItem<String>>((workplace) {
                          return DropdownMenuItem<String>(
                            value: workplace.name,
                            child: Text(workplace.name),
                          );
                        }).toList()),
                    TextField(
                      keyboardType: TextInputType.number,
                      controller: priceController,
                      decoration:
                          kTextFieldInputDecoration.copyWith(hintText: 'Prix'),
                      onChanged: (newValue) {
                        context.read(consultationNotifierProvider).setPrice(
                              newPrice: double.parse(priceController.text),
                            );
                      },
                      onEditingComplete: () => FocusScope.of(context).unfocus(),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    SmartSelect.single(
                      modalConfig: S2ModalConfig(
                          title: 'Moyen de Paiement',
                          type: S2ModalType.bottomSheet),
                      choiceItems: S2Choice.listFrom(
                          source: consultationState.paiementTypes,
                          value: (index, item) => item['value'],
                          title: (index, item) => item['title']),
                      value: consultationState.paiementTypes[0]['title'],
                      placeholder: 'Moyen de paiement',
                      onChange: (newValue) {
                        context
                            .read(consultationNotifierProvider)
                            .setPaiementType(
                                newPaiementType: newValue.valueDisplay);
                        FocusScope.of(context).unfocus();
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    SwitchListTile(
                      title: Text('Tiers Payant'),
                      value: consultationState.tp,
                      activeColor: Colors.blueAccent,
                      inactiveTrackColor: Colors.grey,
                      onChanged: (newValue) {
                        print('newValue is :$newValue');
                        context
                            .read(consultationNotifierProvider)
                            .setTp(newTp: newValue);
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      controller: noteController,
                      decoration: kTextFieldInputDecoration.copyWith(
                          hintText: 'Ajouter une note...'),
                      onChanged: (newValue) {
                        context
                            .read(consultationNotifierProvider)
                            .setNote(newNote: newValue);
                      },
                      onEditingComplete: () => FocusScope.of(context).unfocus(),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    CupertinoButton.filled(
                        child: Text('Ajouter la consultation'),
                        onPressed: () {
                          var model = context.read(homeViewModelProvider);
                          model.addConsult();
                          noteController.clear();
                        })
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
