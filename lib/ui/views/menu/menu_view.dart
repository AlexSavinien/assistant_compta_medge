import 'package:assistant_compta_medge/ui/views/menu/menu_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

class MenuView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final model = watch(menuViewModelProvider);
    print('MenuView');
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: model.navigationBarItems,
        currentIndex: model.currentIndex,
        selectedItemColor: Colors.grey[800],
        onTap: model.setIndex,
      ),
      body: model.getViewForIndex(model.currentIndex),
    );
  }
}
