//
// ./helper/functions.dart
//


class Functions {

  //
  // Helper function to get initials from email
  //
  // Input: email
  // Output: two-letter initials
  //
  // name@company.com -> initials = 'NA'
  // firstname.lastname@company.com -> initials = 'FL'

  static getInitials<String>(email){

    // Local variables
    // Return value of initials
    String initials;
    // Index of '.' in email string
    int dotInd;
    // Index of '@' in email string
    int atInd;

    if((email != null) && (email != '')) {
      
      // Find index of '.' in email string
      dotInd = email.indexOf('.');

      // Find index of '@' in email string
      atInd = email.indexOf('@');

      // If '.' occurs before '@'
      if(dotInd < atInd) {
        // First letter of initials is first letter of email, and second letter is first letter after '.'
        initials = email[0].toUpperCase() + email[dotInd+1].toUpperCase();
      } else {
        // Initials is first two letters of email
        initials = email.substring(0,2).toUpperCase();
      }
    
      // return initials
      return initials;
      
    }else{
      return null;
    }
  }
}