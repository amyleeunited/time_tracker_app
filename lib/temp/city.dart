class City{

  City({this.name, this.country, this.capital});

  final String name;
  final String country;
  final bool capital;


  factory City.fromMap(Map<String, dynamic> data){
    if (data == null){
      return null;
    }
    final name = data['Name'];
    final capital = data['Capital'];
    final country = data['Country'];
    return City(
      name: name,
      country: country,
      capital: capital
    );
  }


  Map<String, dynamic> toMap(){
    return {
      'Country': country,
      'Name': name,
      'Capital': capital,
    };
  }
}