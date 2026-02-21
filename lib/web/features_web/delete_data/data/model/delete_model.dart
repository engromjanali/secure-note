class DeleteModel {
  String? id;
  String? message;

  DeleteModel({this.id, this.message});

  void fromMap(Map<String, dynamic> data){
    id  = data["id"];
    message  = data["message"];
  }
  Map toJson()=> {
    "id" : id,
    "message" : message,
  };
}