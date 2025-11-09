class ActionModel {
  final String operationType; // "query" or "mutation"
  final String operationName; // e.g. "CreateUser"
  final String gqlDocument;   // GraphQL query/mutation string
  final Map<String, dynamic> variables; // GraphQL variables
  final Map<String, String>? headers;   // optional auth headers
  final DateTime timestamp;

  ActionModel({
    required this.operationType,
    required this.operationName,
    required this.gqlDocument,
    required this.variables,
    this.headers,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}
