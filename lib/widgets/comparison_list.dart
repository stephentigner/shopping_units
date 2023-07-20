import 'package:flutter/material.dart';
import 'package:shopping_units/models/comparison_list_model.dart';
import 'package:shopping_units/models/item_details.dart';

class ComparisonList extends StatefulWidget {
  const ComparisonList(
      {super.key,
      this.minItemCount = 2,
      this.deletionNoticeTimeoutInSeconds = 10,
      required this.comparisonListModel});

  final int minItemCount;
  final int deletionNoticeTimeoutInSeconds;
  final ComparisonListModel comparisonListModel;

  @override
  State<ComparisonList> createState() => _ComparisonListState();
}

class _ComparisonListState extends State<ComparisonList> {
  @override
  void initState() {
    widget.comparisonListModel.addComparisonItemCallback =
        _addComparisonItemToState;
    _addComparisonItem();
    _addComparisonItem();
    super.initState();
  }

  void _addComparisonItem() {
    widget.comparisonListModel.addComparisonItem(
        widget.deletionNoticeTimeoutInSeconds, _markItemDeleted, _deleteItem);
  }

  void _addComparisonItemToState() {
    setState(() {
      _addComparisonItem();
    });
  }

  void _markItemDeleted(ItemDetails item) {
    setState(() {
      if (widget.comparisonListModel.validItemCountExcluding(item) < 2) {
        _addComparisonItem();
      }
    });
  }

  void _deleteItem(ItemDetails item) {
    setState(() {
      if (item.isDeleted) {
        widget.comparisonListModel.removeComparisonItem(item.key);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: false,
      children: widget.comparisonListModel.values,
    );
  }
}
