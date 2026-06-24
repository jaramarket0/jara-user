enum UserType { customer, vendor, other }

class ContactFormData {
  UserType userType;
  String name;
  String email;
  String subject;
  String message;

  ContactFormData({
    this.userType = UserType.customer,
    this.name = '',
    this.email = '',
    this.subject = '',
    this.message = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'userType': userType.toString().split('.').last,
      'name': name,
      'email': email,
      'subject': subject,
      'message': message,
    };
  }
}