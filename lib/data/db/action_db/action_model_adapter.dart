import 'package:hive/hive.dart';
import 'action_model.dart';

class ActionModelAdapter extends TypeAdapter<ActionModel> {
  @override
  final int typeId = 0;

  @override
  ActionModel read(BinaryReader reader) {
    final operationType = reader.readString();
    final operationName = reader.readString();
    final gqlDocument = reader.readString();

    final variables = (reader.readMap().cast<String, dynamic>());
    final headers = (reader.readMap().cast<String, String>());
    final timestamp = reader.read() as DateTime;

    return ActionModel(
      operationType: operationType,
      operationName: operationName,
      gqlDocument: gqlDocument,
      variables: variables,
      headers: headers,
      timestamp: timestamp,
    );
  }

  @override
  void write(BinaryWriter writer, ActionModel obj) {
    writer.writeString(obj.operationType);
    writer.writeString(obj.operationName);
    writer.writeString(obj.gqlDocument);
    writer.writeMap(obj.variables);
    writer.writeMap(obj.headers ?? {});
    writer.write(obj.timestamp);
  }
}

