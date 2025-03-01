/*
Copyright (C) 2023 Stephen Tigner

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published
by the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

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
  void Function(bool)? onMeasureTypeChanged;

  void addComparisonItem(
      int deletionNoticeTimeoutInSeconds,
      void Function(ItemDetails) onItemMarkedDeleted,
      void Function(ItemDetails) onDeleteItem) {
    ComparisonItem item = ComparisonItem(
      key: GlobalKey(),
      deletionNoticeTimeoutInSeconds: deletionNoticeTimeoutInSeconds,
      onItemMarkedDeleted: onItemMarkedDeleted,
      onDeleteItem: onDeleteItem,
      onMeasureTypeChanged: onMeasureTypeChanged,
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
