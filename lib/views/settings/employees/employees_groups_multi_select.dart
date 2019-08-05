import 'package:flutter/material.dart';
import 'package:payever/models/business_employees_groups.dart';

class EmployeesGroupsMultiSelect extends StatefulWidget {
  final List<BusinessEmployeesGroups> optionsList;
  final List<BusinessEmployeesGroups> selectedOptionsList;
  final Function(List<BusinessEmployeesGroups>) onSelectionChanged;

  EmployeesGroupsMultiSelect(this.optionsList, this.selectedOptionsList,
      {this.onSelectionChanged});

  @override
  createState() => _EmployeesGroupsMultiSelectState();
}

class _EmployeesGroupsMultiSelectState extends State<EmployeesGroupsMultiSelect> {
  List<BusinessEmployeesGroups> selectedChoices = List();

  _buildChoiceList() {
    List<Widget> choices = List();

    selectedChoices = widget.selectedOptionsList;

    widget.optionsList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Text('${item.name}',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ),
          backgroundColor: Colors.grey,
          selectedColor: Colors.blue,
          selected: selectedChoices.contains(item),
          onSelected: (selected) {
            setState(() {
              selectedChoices.contains(item)
                  ? selectedChoices.remove(item)
                  : selectedChoices.add(item);
              widget.onSelectionChanged(selectedChoices);
            });
          },
        ),
      ));
    });

    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}
