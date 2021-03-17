import 'package:assistant_compta_medge/models/consultation/consultation.dart';
import 'package:assistant_compta_medge/models/consultation/consultation_state.dart';
import 'package:assistant_compta_medge/models/workplace/workplace.dart';
import 'package:assistant_compta_medge/models/workplace/workplace_state.dart';
import 'package:assistant_compta_medge/ui/style_constants/form_style.dart';
import 'package:assistant_compta_medge/ui/views/menu/home/home_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:smart_select/smart_select.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeView extends HookWidget {
  final priceController = TextEditingController();
  final noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool tp = useProvider(homeViewModelProvider).tp;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: useProvider(workplacesStreamProvider).when(
                data: (List<Workplace> workplaces) {
                  return SmartSelect<Workplace>.single(
                    value: context.read(homeViewModelProvider).selectedWorkplace,
                    placeholder: 'Choisissez un cabinet',
                    modalConfig: S2ModalConfig(
                      title: 'Cabinet',
                      type: S2ModalType.bottomSheet,
                    ),
                    choiceItems: S2Choice.listFrom(
                      source: workplaces,
                      value: (index, Workplace item) => item,
                      title: (index, Workplace item) => item.name,
                    ),
                    onChange: (newValue) {
                      context.read(homeViewModelProvider).setSelectedWorkplace(
                            workplace: newValue.value,
                          );
                      FocusScope.of(context).unfocus();
                    },
                  );
                },
                loading: () => Center(child: CircularProgressIndicator()),
                error: (err, stack) => Text('$err'),
              ),
            ),
            Expanded(
              flex: 1,
              child: TextField(
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.deny(',')],
                controller: priceController,
                decoration: kTextFieldInputDecoration.copyWith(hintText: 'Prix'),
                onChanged: (newValue) {
                  print(newValue);
                  context.read(homeViewModelProvider).setPrice(
                        newPrice: double.parse(priceController.text),
                      );
                },
                onEditingComplete: () => FocusScope.of(context).unfocus(),
              ),
            ),
            Expanded(
              flex: 1,
              child: SmartSelect.single(
                modalConfig: S2ModalConfig(
                  title: 'Moyen de Paiement',
                  type: S2ModalType.bottomSheet,
                ),
                choiceItems: S2Choice.listFrom(
                    source: context.read(homeViewModelProvider).paiementTypes,
                    value: (index, item) => item['value'],
                    title: (index, item) => item['title']),
                value: context.read(homeViewModelProvider).paiementTypes[0]['title'],
                placeholder: 'Moyen de paiement',
                onChange: (newValue) {
                  context.read(homeViewModelProvider).setPaiementType(
                        newPaiementType: newValue.valueDisplay,
                      );
                  FocusScope.of(context).unfocus();
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: SwitchListTile(
                title: Text('Tiers Payant'),
                value: tp,
                activeColor: Colors.blueAccent,
                inactiveTrackColor: Colors.grey,
                onChanged: (newValue) {
                  context.read(homeViewModelProvider).setTp(newTp: newValue);
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  decoration: kTextFieldInputDecoration.copyWith(hintText: 'Ajouter une note...'),
                  maxLines: 5,
                  controller: noteController,
                  onChanged: (newValue) {
                    context.read(homeViewModelProvider).setNote(newNote: newValue);
                  },
                  onEditingComplete: () => FocusScope.of(context).unfocus(),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: CupertinoButton.filled(
                  child: Text('Ajouter la consultation'),
                  onPressed: () {
                    context.read(homeViewModelProvider)
                      ..addConsult()
                      ..setPrice(newPrice: 25)
                      ..setTp(newTp: false)
                      ..setNote(newNote: null);
                    priceController.text = '25';
                    noteController.clear();
                    FocusScope.of(context).unfocus();
                    // context.read(navigationServiceProvider).navigateTo(Routes.addWorkPlaceView);
                  },
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: useProvider(consultationStreamProvider).when(
                data: (List<Consultation> list) {
                  if (list.length == 0) {
                    return Text('Aucune consultations');
                  }
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.lightBlueAccent,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListView(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: false,
                      children: list.map((e) {
                        return ListTile(
                          title: Text(
                              '${e.price.toStringAsFixed(2)}€ - ${DateFormat.Md('fr_FR').format(e.date.toDate())} à ${DateFormat.Hm('fr_FR').format(e.date.toDate())}'),
                          subtitle: Text('${e.paiementType} ${e.tp ? '- Tiers Payant' : ' '}'),
                          trailing: GestureDetector(
                            onTap: () {
                              context
                                  .read(homeViewModelProvider)
                                  .deleteConsultation(consultation: e);
                            },
                            child: Icon(
                              Icons.restore_from_trash_outlined,
                              color: Colors.red,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
                loading: () => Text('Cabinet non sélectionné'),
                error: (err, stack) => Text('Erreur : $err, see the stack : $stack'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
