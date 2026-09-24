class UserProfile {
  final String name;
  final String email;
  final String studentId;
  final bool isGuest;
  final String department;

  const UserProfile({
    required this.name,
    required this.email,
    required this.studentId,
    this.isGuest = false,
    this.department = 'Computing & Information Systems',
  });

  factory UserProfile.guest() {
    return const UserProfile(
      name: 'Guest Student',
      email: 'guest.student@campus.ac.lk',
      studentId: 'GST-2026-88',
      isGuest: true,
      department: 'General Campus Visitor',
    );
  }
}
