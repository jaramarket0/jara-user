class SupportTicket {
  final int id;
  final String subject;
  final String message;
  final String status;
  final String? createdAt;
  final String? attachmentUrl;

  SupportTicket({
    required this.id,
    required this.subject,
    required this.message,
    required this.status,
    this.createdAt,
    this.attachmentUrl,
  });

  factory SupportTicket.fromJson(Map<String, dynamic> json) {
    return SupportTicket(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      subject: json['subject']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      status: json['status']?.toString() ?? 'unknown',
      createdAt:
          json['created_at']?.toString() ?? json['createdAt']?.toString(),
      attachmentUrl:
          json['attachment']?.toString() ?? json['attachmentUrl']?.toString(),
    );
  }
}
