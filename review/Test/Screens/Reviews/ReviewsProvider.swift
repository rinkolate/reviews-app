
import Foundation
import UIKit

protocol ProvidesReviews {
  
  func getReviews(offset: Int) async throws -> Data
  func loadImage(from urlString: String) async -> UIImage?

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
  
  func loadImage(from urlString: String) async -> UIImage? {
    if let cachedImage = ImageCache.shared.getImage(for: urlString) {
      return cachedImage
    }
    guard let url = URL(string: urlString) else {
      return nil
    }

    do {
      let (data, _) = try await URLSession.shared.data(from: url)
      if let image = UIImage(data: data) {
        ImageCache.shared.setImage(image, for: urlString)
        return image
      }
    } catch {
      assertionFailure("\(error)")
    }
    return nil
  }

}
