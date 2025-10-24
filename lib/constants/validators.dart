final emailRegex = RegExp(
  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
);

bool isValidEmail(String email) {
  return emailRegex.hasMatch(email.trim());
}