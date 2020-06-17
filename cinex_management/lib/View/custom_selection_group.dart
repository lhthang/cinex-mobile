import 'package:flutter/material.dart';

class CustomSelectionItem {
  String value;
  String label;

  CustomSelectionItem({ this.value, this.label });
}

class CustomSelectionGroup extends StatefulWidget {
  final List<CustomSelectionItem> options;
  final List<String> initialSelectedValues;

  final Function(List<String> selectedValues) onChanged;

  CustomSelectionGroup({ this.options, this.initialSelectedValues, this.onChanged });

  @override
  _CustomSelectionGroupState createState() => _CustomSelectionGroupState();
}

class _CustomSelectionGroupState extends State<CustomSelectionGroup> {
  List<String> _selectedValues = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _selectedValues = List.from(widget.initialSelectedValues);
  }

  bool _checkIsChecked(CustomSelectionItem item) {
    return _selectedValues.contains(item.value);
  }

  void _setNewSelectedValues(CustomSelectionItem item, bool isSelected) {
//    List<String> newSelectedValues = List.from(_selectedValues);
    if (isSelected == true && !_selectedValues.contains(item.value)) {
      setState(() {
        var newList = _selectedValues.add(item.value);
      });
//      newSelectedValues.add(item.value);
    }
    else if (isSelected == false && _selectedValues.contains(item.value)) {
      setState(() {
        _selectedValues.remove(item.value);
      });
//      newSelectedValues.remove(item.value);
    }

    widget.onChanged(_selectedValues);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: ListTileTheme(
          contentPadding: EdgeInsets.fromLTRB(14.0, 0.0, 24.0, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.options.map((option){
              return Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Checkbox(
                    value: _checkIsChecked(option),
                    onChanged: (bool value) {
                      _setNewSelectedValues(option, value);
                    },
                  ),
                  Text(option.label),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
