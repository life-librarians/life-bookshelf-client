class PageCalculator {
  // 상수 정의
  static const int CHARACTERS_PER_SUBCHAPTER = 3000;  // 한 소챕터당 글자 수
  static const int CHARACTERS_PER_PAGE = 760;         // 한 페이지당 글자 수

  // 총 페이지 수 계산 함수
  static int calculateTotalPages(int totalSubchapters) {
    // 전체 글자 수 = 소챕터 수 * 한 소챕터당 글자 수
    int totalCharacters = totalSubchapters * CHARACTERS_PER_SUBCHAPTER;

    // 전체 페이지 수 = 전체 글자 수 / 한 페이지당 글자 수 (올림 처리)
    return (totalCharacters / CHARACTERS_PER_PAGE).ceil();
  }
}