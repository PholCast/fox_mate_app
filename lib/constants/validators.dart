// final emailRegex = RegExp(
//   r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
// );
final emailRegex = RegExp(
  r'^[\w\.-]+@soyudemedellin\.edu\.co$',
  caseSensitive: false,
);


bool isValidEmail(String email) {
  return emailRegex.hasMatch(email.trim());
}