
import Foundation

protocol ProvidesReviews {
  
  func getReviews(offset: Int) async throws -> Data

}

/// Класс для загрузки отзывов.
final class ReviewsProvider {

  private let bundle: Bundle

  init(bundle: Bundle = .main) {
    self.bundle = bundle
  }
}

// MARK: - Internal

extension ReviewsProvider {

  enum GetReviewsError: Error {
    case badURL
    case badData(Error)
  }

}

// MARK: - ProvidesReviews

extension ReviewsProvider: ProvidesReviews {

  func getReviews(offset: Int = 0) async throws -> Data {
    guard let url = self.bundle.url(
      forResource: "getReviews.response",
      withExtension: "json")
    else {
      throw GetReviewsError.badURL
    }
    
    // Симулируем сетевой запрос — не менять
    usleep(.random(in: 100_000...1_000_000))
    
    do {
      return try Data(contentsOf: url)
    } catch {
      throw GetReviewsError.badData(error)
    }
  }

}
