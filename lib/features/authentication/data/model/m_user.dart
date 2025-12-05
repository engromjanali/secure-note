// import '/core/util/data/model/m_Profile_data.dart';
// import '/core/util/data/model/m_meta.dart';

// class MUser {
//   final MUserData? data;
//   final String? status;
//   final MMeta? meta;

//   MUser({
//     this.data,
//     this.status,
//     this.meta,
//   });

//   factory MUser.fromJson(Map<String, dynamic> json) => MUser(
//         data: json["data"] == null ? null : MUserData.fromJson(json["data"]),
//         status: json["status"],
//         meta: json["meta"] == null ? null : MMeta.fromJson(json["meta"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "data": data?.toJson(),
//         "status": status,
//         "meta": meta?.toJson(),
//       };
// }

// class MUserData {
//   final String? accessToken;
//   final MProfileData? user;

//   MUserData({
//     this.accessToken,
//     this.user,
//   });

//   factory MUserData.fromJson(Map<String, dynamic> json) {
//     return MUserData(
//       accessToken: json["access_token"],
//       user: json["user"] == null ? null : MProfileData.fromJson(json["user"]),
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         "access_token": accessToken,
//         "user": user?.toJson(),
//       };
// }
