/// One message in a support conversation — either the customer's follow-up or
/// an answer from the support team.
class TicketReply {
  final int id;
  final String message;
  final bool isStaff;
  final String authorName;
  final String? createdAt;

  TicketReply({
    required this.id,
    required this.message,
    required this.isStaff,
    required this.authorName,
    this.createdAt,
  });

  factory TicketReply.fromJson(Map<String, dynamic> json) {
    return TicketReply(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      message: json['message']?.toString() ?? '',
      isStaff: json['is_staff'] == true,
      authorName: json['author_name']?.toString() ?? '',
      createdAt: json['created_at']?.toString(),
    );
  }
}

class SupportTicket {
  final int id;
  final String subject;
  final String message;
  final String status;
  final String? createdAt;
  final String? attachmentUrl;

  /// The conversation after the opening message. Empty until support answers.
  final List<TicketReply> replies;
  final bool hasStaffReply;

  SupportTicket({
    required this.id,
    required this.subject,
    required this.message,
    required this.status,
    this.createdAt,
    this.attachmentUrl,
    this.replies = const [],
    this.hasStaffReply = false,
  });

  bool get isClosed => status.toLowerCase() == 'closed';

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
      replies: (json['replies'] as List? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(TicketReply.fromJson)
          .toList(),
      hasStaffReply: json['has_staff_reply'] == true,
    );
  }
}
