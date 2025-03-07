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
import 'package:shopping_units/enums/unit_type.dart';
import 'package:shopping_units/models/comparison_list_model.dart';
import 'package:shopping_units/utils/application_strings.dart';
import 'package:shopping_units/widgets/comparison_list.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:url_launcher/link.dart';

void main() {
  runApp(const ShoppingUnits());
}

class ShoppingUnits extends StatelessWidget {
  const ShoppingUnits({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: ApplicationStrings.applicationTitle,
      theme:
          ThemeData(primarySwatch: Colors.blue, brightness: Brightness.light),
      darkTheme:
          ThemeData(primarySwatch: Colors.blue, brightness: Brightness.dark),
      themeMode: ThemeMode.system,
      home: const MainScreen(title: ApplicationStrings.applicationTitle),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.title});

  final String title;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static const int _deletionNoticeTimeoutInSeconds = 10;
  final ComparisonListModel _comparisonListModel = ComparisonListModel();
  late ComparisonList _comparisonList;

  bool _isFluidMeasure = false;
  int _measureTypeIndex = 0;
  UnitType _standardizedUnits = UnitType.defaultSolidUnit;

  @override
  void initState() {
    _comparisonList = ComparisonList(
      deletionNoticeTimeoutInSeconds: _deletionNoticeTimeoutInSeconds,
      comparisonListModel: _comparisonListModel,
    );
    _comparisonListModel.onMeasureTypeChanged = (isFluid) {
      _toggleMeasureType(isFluid ? 1 : 0);
    };
    super.initState();
  }

  void _toggleMeasureType(int? measureTypeIndex) {
    setState(() {
      _measureTypeIndex = measureTypeIndex ?? 0;
      switch (measureTypeIndex) {
        case 0:
          _isFluidMeasure = false;
          break;
        case 1:
          _isFluidMeasure = true;
          break;
        default:
        //if unmatched, do nothing for now
      }

      _comparisonListModel.isFluidMeasure = _isFluidMeasure;
      _standardizedUnits = UnitType.defaultUnit(_isFluidMeasure);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 100,
              child: DrawerHeader(
                decoration:
                    BoxDecoration(color: Theme.of(context).primaryColor),
                child: const Text(ApplicationStrings.applicationTitle),
              ),
            ),
            ListTile(
              title: Link(
                uri: Uri.parse(ApplicationStrings.privacyPolicyLink),
                builder: (context, followLink) => InkWell(
                  onTap: followLink,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(ApplicationStrings.privacyPolicyLinkText),
                      Icon(Icons.launch)
                    ],
                  ),
                ),
                target: LinkTarget.blank,
              ),
            ),
            ListTile(
              title: Link(
                uri: Uri.parse(ApplicationStrings.licenseLink),
                builder: (context, followLink) => InkWell(
                  onTap: followLink,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(ApplicationStrings.licenseLinkText),
                      Icon(Icons.launch)
                    ],
                  ),
                ),
                target: LinkTarget.blank,
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: _comparisonList,
      ),
      persistentFooterButtons: [
        Row(
          children: [
            ToggleSwitch(
              totalSwitches: 2,
              labels: const ['Solid', 'Liquid'],
              initialLabelIndex: _measureTypeIndex,
              onToggle: _toggleMeasureType,
            ),
            const Flexible(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(ApplicationStrings.standardizedUnitsLabel),
              ),
            ),
            DropdownButton<UnitType>(
              value: _standardizedUnits,
              items: UnitType.filteredValues(_isFluidMeasure)
                  .map((e) => DropdownMenuItem<UnitType>(
                        value: e,
                        child: Text(e.pluralAbbreviation),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  UnitType nullCheckedValue =
                      value ?? UnitType.defaultUnit(_isFluidMeasure);
                  _standardizedUnits = nullCheckedValue;
                  _comparisonListModel.standardizedUnits = nullCheckedValue;
                });
              },
            )
          ],
        )
      ],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_comparisonListModel.addComparisonItemCallback != null) {
            _comparisonListModel.addComparisonItemCallback!();
          }
        }, //_addComparisonItemToState,
        tooltip: 'Add new item',
        child: const Icon(Icons.add),
      ),
    );
  }
}
