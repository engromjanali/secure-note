import 'package:secure_note/web/features_web/delete_data/data/model/delete_model.dart';

abstract class DeleteRepositoryInterface {
  Future<void> sendDeleteRequest(DeleteModel payload);
}