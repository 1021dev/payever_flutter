
class CountryDropdownItem {
  final String label;
  final String value;
  CountryDropdownItem({
    this.label,
    this.value,
  });

  factory CountryDropdownItem.fromMap(dynamic obj) {
    return CountryDropdownItem(
      label: obj['label'],
      value: obj['value'],
    );
  }
}

class AddPhoneNumberSettingsModel{
  String id;
  String country;
  String phoneNumber;
  bool excludeAny;
  bool excludeForeign;
  bool excludeLocal;
}