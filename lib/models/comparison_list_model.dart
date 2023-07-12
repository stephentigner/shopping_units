import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:shopping_units/enums/unit_type.dart';

import '../widgets/comparison_item.dart';
import 'item_details.dart';

class ComparisonListModel with ChangeNotifier {
  final LinkedHashMap<UniqueKey, ComparisonItem> _comparisonItems =
      LinkedHashMap<UniqueKey, ComparisonItem>();

  List<ComparisonItem> get values => _comparisonItems.values.toList();

  void Function()? addComparisonItemCallback;

  void addComparisonItem(
      int deletionNoticeTimeoutInSeconds,
      void Function(ItemDetails) onItemMarkedDeleted,
      void Function(ItemDetails) onDeleteItem) {
    ComparisonItem item = ComparisonItem(
      key: GlobalKey(),
      deletionNoticeTimeoutInSeconds: deletionNoticeTimeoutInSeconds,
      onItemMarkedDeleted: onItemMarkedDeleted,
      onDeleteItem: onDeleteItem,
      // onRestoreItem: _restoreItem,
    );
    _comparisonItems[item.details.key] = item;

    notifyListeners();
  }

  void removeComparisonItem(UniqueKey key) {
    _comparisonItems.remove(key);
  }

  set isFluidMeasure(bool isFluidMeasure) {
    for (var item in _comparisonItems.values) {
      item.details.isFluidMeasure = isFluidMeasure;
    }

    notifyListeners();
  }

  set standardizedUnits(UnitType standardizedUnits) {
    for (var item in _comparisonItems.values) {
      item.details.standardizedUnits = standardizedUnits;
    }

    notifyListeners();
  }

  int get validItemCount => _comparisonItems.values
      .where((currentItem) => !currentItem.details.isDeleted)
      .length;
  int validItemCountExcluding(ItemDetails item) => _comparisonItems.values
      .where((currentItem) =>
          !currentItem.details.isDeleted && currentItem.details != item)
      .length;
}
