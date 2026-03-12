class ServiceCompletionModel {
  final String bookingId;
  final List<ServiceTask> tasks;

  ServiceCompletionModel({
    required this.bookingId,
    required this.tasks,
  });
}

class ServiceTask {
  final String id;
  final String name;
  final bool isCompleted;
  final String? notCompletedReason;

  ServiceTask({
    required this.id,
    required this.name,
    required this.isCompleted,
    this.notCompletedReason,
  });
}
