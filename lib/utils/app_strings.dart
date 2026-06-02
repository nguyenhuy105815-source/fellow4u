/// App strings - Tiếng Việt
/// Centralized UI text for easy maintenance and localization.
library;

class AppStrings {
  AppStrings._();

  // Common
  static const appName = 'Fellow4U';

  // Auth - Sign Up
  static const signUp = 'Đăng ký';
  static const signIn = 'Đăng nhập';
  static const firstName = 'Tên';
  static const lastName = 'Họ';
  static const country = 'Quốc gia';
  static const email = 'Email';
  static const password = 'Mật khẩu';
  static const confirmPassword = 'Xác nhận mật khẩu';
  static const traveler = 'Du khách';
  static const guide = 'Hướng dẫn viên';
  static const passwordHint = 'Mật khẩu có hơn 6 ký tự';
  static const termsText = 'Bằng việc đăng ký, bạn đồng ý với ';
  static const termsLink = 'Điều khoản & Điều kiện';
  static const alreadyHaveAccount = 'Đã có tài khoản? ';
  static const noAccount = 'Chưa có tài khoản? ';

  // Auth - Sign In
  static const welcomeBack = 'Chào mừng trở lại, ';
  static const forgotPassword = 'Quên mật khẩu';
  static const orSignInWith = 'hoặc đăng nhập với';

  // Placeholders
  static const hintFirstName = 'Nhập tên';
  static const hintLastName = 'Nhập họ';
  static const hintCountry = 'Chọn quốc gia';
  static const hintEmail = 'Nhập email';
  static const hintPassword = 'Nhập mật khẩu';

  // Home
  static const hi = 'Xin chào, ';
  static const popularTours = 'Tour phổ biến';
  static const explore = 'Khám phá';
  static const seeMore = 'Xem thêm';
  static const chooseGuide = 'Chọn hướng dẫn viên';
  static const myTrips = 'Chuyến đi của tôi';
  static const searchPlaceholder = 'Tìm tour, hướng dẫn viên, điểm đến...';

  // Search
  static const searchHint = 'Bạn muốn khám phá đâu?';
  static const searchEmpty = 'Tìm kiếm tour hoặc hướng dẫn viên';
  static const popularDestinations = 'Điểm đến phổ biến';
  static const guidesIn = 'Hướng dẫn viên tại %s';
  static const toursIn = 'Tour tại %s';
  static const filters = 'Bộ lọc';
  static const guidesFilter = 'Hướng dẫn viên';
  static const toursFilter = 'Tour';
  static const guideLanguage = 'Ngôn ngữ hướng dẫn';
  static const feeFilter = 'Phí';
  static const free = 'Miễn phí';
  static const feePerHour = '(\$/giờ)';
  static const applyFilters = 'ÁP DỤNG BỘ LỌC';

  // Explore
  static const discoverTours = 'Khám phá tour và điểm đến';
  static const seeAllTours = 'Xem tất cả tour';
  static const findGuide = 'Tìm hướng dẫn viên phù hợp';
  static const search = 'Tìm kiếm';
  static const exploreSearchHint = 'Xin chào, bạn muốn khám phá đâu?';
  static const topJourneys = 'Tour nổi bật';
  static const bestGuides = 'Hướng dẫn viên xuất sắc';
  static const topExperiences = 'Trải nghiệm hàng đầu';
  static const featuredTours = 'Tour đặc sắc';
  static const travelNews = 'Tin du lịch';
  static const topGuide = 'TOP GUIDE';

  // Home - Headers (theo Figma)
  static const homeGuidesHeader =
      'Đặt hướng dẫn viên riêng của bạn và khám phá thành phố';
  static const homeToursHeader =
      'Nhiều tour tuyệt vời đang chờ bạn khám phá';
  static const guidesHeader =
      'Đặt hướng dẫn viên riêng và khám phá thành phố';
  static const toursHeader = 'Nhiều tour tuyệt vời đang chờ bạn';
  static const searchExploreHint = 'Xin chào, bạn muốn khám phá đâu?';
  static const reviews = 'đánh giá';
  static const likes = ' lượt thích';

  // Guides & Tours
  static const allTours = 'Tất cả tour';
  static const noTours = 'Chưa có tour nào';
  static const yourGuide = 'Hướng dẫn viên của bạn';
  static const bookNow = 'Đặt ngay';
  static const bookThisTour = 'ĐẶT TOUR NÀY';
  static const bookingSoon = 'Tính năng đặt tour sẽ sớm ra mắt!';
  static const summary = 'Tóm tắt';
  static const itinerary = 'Lịch trình';
  static const departureDate = 'Ngày khởi hành';
  static const departurePlace = 'Nơi khởi hành';
  static const schedule = 'Lịch trình chi tiết';
  static const priceSection = 'Giá';
  static const adultPrice = 'Người lớn (>10 tuổi)';
  static const childPrice = 'Trẻ em (5 - 10 tuổi)';
  static const childFree = 'Trẻ em (<5 tuổi)';
  static const bookTour = 'Đặt tour';
  static const selectDate = 'Chọn ngày khởi hành';
  static const adults = 'Người lớn';
  static const children = 'Trẻ em';
  static const totalPrice = 'Tổng tiền';
  static const confirmBooking = 'Xác nhận đặt tour';
  static const bookingSuccess = 'Đặt tour thành công!';
  static const shareOn = 'Chia sẻ trên';
  static const cancel = 'Hủy';
  static const chooseThisGuide = 'CHỌN HƯỚNG DẪN NÀY!';
  static const guidePage = 'Trang hướng dẫn';
  static const myExperiences = 'Trải nghiệm của tôi';
  static const seeMoreReviews = 'Xem thêm';

  // Trip Information
  static const tripInformation = 'Thông tin chuyến đi';
  static const date = 'Ngày';
  static const time = 'Giờ';
  static const city = 'Thành phố';
  static const numberOfTravelers = 'Số du khách';
  static const attractions = 'Điểm đến';
  static const addNew = '+ Thêm mới';
  static const done = 'XONG';

  // Add Attractions
  static const newAttractions = 'Điểm đến mới';
  static const typeAPlace = 'Nhập tên địa điểm';

  // Trips
  static const noTrips = 'Chưa có chuyến đi nào';
  static const noTripsHint = 'Đặt tour để xem chuyến đi tại đây';
  static const exploreTours = 'Khám phá tour';
  static const currentTrips = 'Chuyến hiện tại';
  static const nextTrips = 'Chuyến sắp tới';
  static const pastTrips = 'Chuyến đã qua';
  static const wishList = 'Danh sách yêu thích';
  static const markFinished = 'Đánh dấu hoàn thành';
  static const detail = 'Chi tiết';
  static const chat = 'Nhắn tin';
  static const pay = 'Thanh toán';
  static const chooseAnotherGuide = 'Chọn hướng dẫn khác';
  static const waitingForOffers = 'Đang chờ đề xuất';
  static const chatWithGuide = 'Nhắn tin';
  static const chatWithGuideLong = 'Nhắn tin với hướng dẫn viên';
  static const statusUpcoming = 'SẮP TỚI';
  static const statusOngoing = 'ĐANG DIỄN RA';
  static const statusCompleted = 'HOÀN THÀNH';
  static const statusCancelled = 'ĐÃ HỦY';

  // Profile
  static const profile = 'Hồ sơ';
  static const settings = 'Cài đặt';
  static const signOut = 'Đăng xuất';
  static const settingsSoon = 'Cài đặt sẽ sớm ra mắt';
  static const myPhotos = 'Ảnh của tôi';
  static const myJourneys = 'Hành trình của tôi';
  static const editProfile = 'Chỉnh sửa hồ sơ';
  static const changePassword = 'Đổi mật khẩu';
  static const currentPassword = 'Mật khẩu hiện tại';
  static const newPassword = 'Mật khẩu mới';
  static const retypePassword = 'Nhập lại mật khẩu mới';
  static const notifications = 'Thông báo';
  static const languages = 'Ngôn ngữ';
  static const payment = 'Thanh toán';
  static const privacyPolicies = 'Quyền riêng tư & Chính sách';
  static const feedback = 'Phản hồi';
  static const usage = 'Sử dụng';
  static const selectLanguage = 'Chọn ngôn ngữ';
  static const paymentMethods = 'Phương thức thanh toán';
  static const addCard = 'Thêm thẻ';
  static const noCards = 'Chưa có thẻ nào';
  static const addCardHint = 'Thêm thẻ để thanh toán nhanh hơn';
  static const feedbackTitle = 'Gửi phản hồi';
  static const feedbackHint = 'Chia sẻ ý kiến của bạn để chúng tôi cải thiện ứng dụng';
  static const subject = 'Chủ đề';
  static const message = 'Nội dung';
  static const sendFeedback = 'Gửi phản hồi';
  static const feedbackSent = 'Cảm ơn bạn đã gửi phản hồi!';
  static const howToUse = 'Hướng dẫn sử dụng';
  static const usageIntro = 'Tìm hiểu cách sử dụng Fellow4U hiệu quả';

  // Chat
  static const noMessages = 'Chưa có tin nhắn. Hãy chào hỏi!';
  static const typeMessage = 'Nhập tin nhắn...';

  // Social
  static const socialComingSoon = 'Đăng nhập bằng %s sẽ sớm ra mắt';
}
