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
