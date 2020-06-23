class Currency {
  final String name;
  final String code;
  final String symbol;

  Currency({this.name, this.code, this.symbol});

  factory Currency.fromJson(Map<String, dynamic> json) {
    return new Currency(
      name: json['name'] as String,
      code: json['cc'] as String,
      symbol: json['symbol'] as String,
    );
  }
}
