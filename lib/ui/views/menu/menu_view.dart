import 'package:assistant_compta_medge/ui/views/menu/menu_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MenuView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final model = watch(menuViewModelProvider);
    print('Index is : ${model.currentIndex}');
    print('MenuView');
    print('View is ${model.getViewForIndex()}');
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: model.getTitleViewForIndex(),
      bottomNavigationBar: SizedBox(
        height: 56,
        child: BottomNavigationBar(
          items: model.navigationBarItems,
          currentIndex: model.currentIndex,
          selectedItemColor: Colors.grey[800],
          onTap: (newIndex) {
            context.read(menuViewModelProvider).setIndex(newIndex);
          },
        ),
      ),
      body: Builder(
        builder: (context) {
          return model.getViewForIndex();
        },
      ),
    );
  }
}
