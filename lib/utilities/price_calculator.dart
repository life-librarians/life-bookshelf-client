// lib/utils/price_calculator.dart
class PriceCalculator {
  // 상수 정의
  static const int BASE_PRICE = 30000;     // 기본 가격 (50p 이하)
  static const int BASE_PAGES = 50;        // 기본 페이지 수
  static const int PRICE_PER_10_PAGES = 1000;  // 10p당 추가 가격

  // 총 가격 계산 함수
  static int calculateTotalPrice(int totalPages) {
    if (totalPages <= BASE_PAGES) {
      return BASE_PRICE;
    } else {
      int extraPages = totalPages - BASE_PAGES;
      int extraCharge = ((extraPages + 9) ~/ 10) * PRICE_PER_10_PAGES;  // 올림 처리
      return BASE_PRICE + extraCharge;
    }
  }
}