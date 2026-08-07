import 'package:frontend/data/models/category.dart';
import 'package:frontend/data/models/status.dart';

class Report {


final int id;

final String title;

final String description;

final Category category;

final String? imageUrl;

final double? latitude;

final double? longitude;

final String? address;

final Status status;



Report({

required this.id,

required this.title,

required this.description,

required this.category,

this.imageUrl,

this.latitude,

this.longitude,

this.address,

required this.status,

});



factory Report.fromJson(Map<String,dynamic> json){

return Report(

id: json['id'],

title: json['title'],

description: json['description'],

category:
Category.fromString(json['category']),

imageUrl:
json['imageUrl'],

latitude:
json['latitude']?.toDouble(),

longitude:
json['longitude']?.toDouble(),

address:
json['address'],

status:
Status.fromString(json['status'])

);

}

}