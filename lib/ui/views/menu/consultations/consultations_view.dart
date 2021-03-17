import 'package:assistant_compta_medge/models/consultation/consultation.dart';
import 'package:assistant_compta_medge/models/consultation/consultation_state.dart';
import 'package:assistant_compta_medge/models/workplace/workplace.dart';
import 'package:assistant_compta_medge/models/workplace/workplace_state.dart';
import 'package:assistant_compta_medge/ui/views/menu/consultations/consultations_viewmodel.dart';
import 'package:assistant_compta_medge/ui/views/menu/home/home_viewmodel.dart';
import 'package:assistant_compta_medge/ui/views/menu/profile/profile_view/profile_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:smart_select/smart_select.dart';

class ConsultationsView extends HookWidget {
  @override
  Widget build(BuildContext context) {
    double usableScreenSize =
        MediaQuery.of(context).size.height - Scaffold.of(context).appBarMaxHeight - 65;
    print('Consultation View');
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: useProvider(workplacesStreamProvider).when(
              data: (List<Workplace> list) {
                return SmartSelect<Workplace>.single(
                  modalConfig: S2ModalConfig(
                    title: 'Cabinet',
                    type: S2ModalType.bottomSheet,
                  ),
                  value: context.read(homeViewModelProvider).selectedWorkplace,
                  placeholder: 'Choisissez un cabinet',
                  choiceItems: S2Choice.listFrom(
                    source: list,
                    value: (index, Workplace item) => item,
                    title: (index, Workplace item) => item.name,
                  ),
                  onChange: (newValue) {
                    context.read(homeViewModelProvider).setSelectedWorkplace(
                          workplace: newValue.value,
                        );
                    // FocusScope.of(context).unfocus();
                  },
                );
              },
              loading: () => Center(child: CircularProgressIndicator()),
              error: (err, stack) => Text('$err'),
            ),
          ),
          Expanded(
            flex: 1,
            child: ListTile(
              title: Text('Sélectionnez un mois'),
              trailing: GestureDetector(
                child: Consumer(builder: (context, watch, child) {
                  return Text(
                    DateFormat('yMMMM', 'fr_Fr')
                            .format(watch(consultationsViewModelProvider).selectedDate) ??
                        DateFormat('yMMMM', 'fr_Fr').format(DateTime.now()),
                  );
                }),
                onTap: () {
                  DatePicker.showDatePicker(
                    context,
                    maxDateTime: DateTime.now(),
                    dateFormat: 'MMMM-yyyy',
                    locale: DateTimePickerLocale.fr,
                    onConfirm: (DateTime newDate, List<int> index) {
                      context
                          .read(consultationsViewModelProvider)
                          .setSelectedDate(newDate: newDate);
                    },
                  );
                },
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: CupertinoButton.filled(
                child: Text('Télécharger les consultations du mois sélectionné'),
                onPressed: () {
                  context.read(consultationsViewModelProvider).getCsv(
                      list: context.read(monthConsultationsStreamProvider).data,
                      workplace: context.read(homeViewModelProvider).selectedWorkplace);
                },
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: useProvider(monthConsultationsStreamProvider).when(
              data: (List<Consultation> list) {
                if (list.length == 0) {
                  return Text('Aucune consultations');
                }
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.lightBlueAccent,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    child: ListView(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: false,
                      children: list.map((e) {
                        return ListTile(
                          isThreeLine: true,
                          leading: Text('${e.price.toStringAsFixed(2)}€'),
                          title: Text(
                              '${DateFormat.Md('fr_FR').format(e.date.toDate())} à ${DateFormat.Hm('fr_FR').format(e.date.toDate())} - ${e.paiementType} ${e.tp ? '- T.P' : ' '}'),
                          subtitle: Text('${e.note ??= ' '}'),
                          trailing: GestureDetector(
                            onTap: () {
                              print('tapped');
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
                  ),
                );
              },
              loading: () => Text('Cabinet non sélectionné'),
              error: (err, stack) => Text('Erreur : $err, see the stack : $stack'),
            ),
          )
        ],
      ),
    );
  }
}
