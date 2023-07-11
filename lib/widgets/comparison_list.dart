import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:shopping_units/models/item_details.dart';
import 'package:shopping_units/widgets/comparison_item.dart';

class ComparisonList extends StatefulWidget {
  const ComparisonList(
      {super.key,
      this.minItemCount = 2,
      this.deletionNoticeTimeoutInSeconds = 30});

  final int minItemCount;
  final int deletionNoticeTimeoutInSeconds;

  @override
  State<ComparisonList> createState() => _ComparisonListState();
}

class _ComparisonListState extends State<ComparisonList> {
  final LinkedHashMap<UniqueKey, ComparisonItem> _comparisonItems =
      LinkedHashMap<UniqueKey, ComparisonItem>();

  @override
  void initState() {
    _addComparisonItem();
    _addComparisonItem();
    super.initState();
  }

  void _addComparisonItem() {
    ComparisonItem item = ComparisonItem(
      key: GlobalKey(),
      deletionNoticeTimeoutInSeconds: widget.deletionNoticeTimeoutInSeconds,
      onItemMarkedDeleted: _markItemDeleted,
      onDeleteItem: _deleteItem,
      // onRestoreItem: _restoreItem,
    );
    _comparisonItems[item.details.key] = item;
  }

  void _addComparisonItemToState() {
    setState(() {
      _addComparisonItem();
    });
  }

  void _markItemDeleted(ItemDetails item) {
    setState(() {
      if (_comparisonItems.values
              .where((currentItem) =>
                  !currentItem.details.isDeleted && currentItem.details != item)
              .length <
          2) {
        _addComparisonItem();
      }
    });
  }

  void _deleteItem(ItemDetails item) {
    setState(() {
      if (item.isDeleted) {
        _comparisonItems.remove(item.key);
      }
    });
  }

  void _restoreItem(ItemDetails item) {
    setState(() {
      item.isDeleted = false;
      item.deletionNoticeTimer?.cancel();
      item.deletionNoticeTimeRemaining = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: false,
      children: _comparisonItems.values.toList(),
    );
  }
}
