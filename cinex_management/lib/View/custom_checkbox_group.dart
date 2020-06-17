import 'package:flutter/material.dart';

class CustomCheckboxItem {
  String value;
  String label;

  CustomCheckboxItem({ this.value, this.label });
}

class CustomCheckbox extends StatefulWidget {

  final List<CustomCheckboxItem> options;
  final String initSelectedValue;

  final Function(String selectedItem) onChanged;

  CustomCheckbox({Key key, this.options, this.initSelectedValue, this.onChanged});


  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {

  String _selectedItem;

  bool _checkIsChecked(CustomCheckboxItem item) {
    return _selectedItem==item.value;
  }

  void _setNewSelectedValues(CustomCheckboxItem item, bool isSelected) {
    setState(() {
      _selectedItem=item.value;
    });

    widget.onChanged(_selectedItem);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedItem= widget.initSelectedValue;
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
