class JobCardModel {
  final String bookingId;
  final String technicianAssignment;
  final String customerComplaints;
  final String advisorNotes;
  final List<String> inspectionChecklist; // e.g., ["Brakes", "Engine", "Lights"]
  final List<String>? vehicleImages; 

  JobCardModel({
    required this.bookingId,
    required this.technicianAssignment,
    required this.customerComplaints,
    required this.advisorNotes,
    required this.inspectionChecklist,
    this.vehicleImages,
  });
}
