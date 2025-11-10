class AppUrl {
  static var baseUrl = "https://www.overcooked.space";
  // static var baseUrl = "https://api.techazora.com";
  static var sendOtpApi = "/api/user/auth/login";
  static var otpVerifyUrl = "/api/user/auth/verify";
  static var registerUrl = "/api/user/auth/register";
  static var storyUrl = "/api/admin/story/all";
  static var categoryUrl = "/api/admin/category/get";
  static var getTherapistProfileApi = "/api/therapist/auth/profile/";
  static var updateProfileUrl = "/api/therapist/auth/updateProfile";
  static var allTherapistUrl = "/api/therapist/auth/allforuser";
  static var therapistByCateUrl = "/api/therapist/auth/all/";
  static var singleStoryUrl = "/api/admin/story/single/";
  static var completeStatusUrl = "/api/user/booking/completed/";
  static var sessionHistoryUrl = "/api/user/booking/user/bookingHistory/";
  static var walletUrl = "/api/user/wallet/getBalance";
  static var walletHistoryUrl = "/api/user/wallet/walletHistory/";
  static var paymentLogUrl = "/api/user/wallet/walletHistory?isDeducted=false";
  static var addMoneyUrl = "/api/user/wallet/add";
  static var createSessionUrl = "/api/user/booking/create/";
  static var createFreeSessionUrl = "/api/user/booking/createFreeSession";
  static var sendMsgUrl = "/api/chat/send";
  static var reviewUrl = "/api/therapist/review/create/";
  static var fcmTokenUrl = "/api/user/auth/sendFcmToken";
  static var singleSessionUrlUrl = "/api/user/booking/single/";
  static var cancelSessionUrl = "/api/user/booking/status/";
  static var sendNotificationUrl =
      "/api/user/notification/createNotificationForTherapist";
  static var remaingTimeUrl = "/api/user/booking/time";
  static var reviewgetUrl = "/api/therapist/review/get/";
  static var deleteUrl = "/api/user/auth/delete";
  static var prefrencesUrl = "/api/user/auth/qna";
  static var reportUrl = "/api/therapist/report/user/create";
  static var moneyDeductUrl = "/api/user/wallet/withdraw/";
  static var createPaymentApi = "$baseUrl/api/user/auth/payment";
  static var capturePaymentApi = "$baseUrl/api/user/auth/capture";
  static var updateSessiontimeApi = "$baseUrl/api/user/booking/timedifference/";
  static var zegoCloudeApi = "$baseUrl/api/admin/zegoCloud/all";
  static var filterTherapistApi = "$baseUrl/api/therapist/auth/allforuser";
  static var availableSlotsApi = "/api/therapist/auth/avalaibleSlots/";
  static var commissionValueApi = "/api/admin/commission/all";
  static var userProfileApi = "/api/user/auth/getUserProfile/";
  static var resultApi = "/api/admin/result/all";

  static var sendPostChatApi =
      "$baseUrl/api/therapist/chatView/createChatView/";
  // -------- Chat Apis ---------
  static var unlockChat = "$baseUrl/api/user/auth/unlockChat/";
  static var emergencyNumber =
      "$baseUrl/api/user/auth/updateUserEmergencyNumber/";
}
