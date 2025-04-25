class Urls{
  static const String _baseUrls="http://35.73.30.144:2005/api/v1";
  static const String registerUrls="$_baseUrls/Registration";
  static const String loginrUrls="$_baseUrls/Login";
  static const String updateUserProfile="$_baseUrls/ProfileUpdate";
  static const String createNewTask="$_baseUrls/createTask";
  static const String taskStatusCount = "$_baseUrls/taskStatusCount";
  static const String newTaskStatus = "$_baseUrls/listTaskByStatus/New";
  static const String completedTaskStatus = "$_baseUrls/listTaskByStatus/Completed";
  static const String progressTaskStatus = "$_baseUrls/listTaskByStatus/Progress";
  static const String cancelTaskStatus = "$_baseUrls/listTaskByStatus/Cancelled";
  static String updateTaskStatus(String taskId,String status) => "$_baseUrls/updateTaskStatus/$taskId/$status";
  static String deleteTaskStatus(String taskId) => "$_baseUrls/deleteTask/$taskId";
  static String emailverification(String userEmail) => "$_baseUrls/RecoverVerifyEmail/$userEmail";
  static String pinVerification(String userEmail, String otp) => "$_baseUrls/RecoverVerifyOtp/$userEmail/$otp";
  static const String resetPassword = "$_baseUrls/RecoverResetPassword";

}