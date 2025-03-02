
import UIKit

struct RatingRendererConfig {
  
  let ratingRange: ClosedRange<Int>
  let starImage: UIImage
  let tintColor: UIColor
  let fadeColor: UIColor
  let spacing: CGFloat

}

// MARK: - Actor

actor ImageCacheActor {
    private var images: [Int: UIImage] = [:]
    
    func image(for rating: Int) -> UIImage? {
        images[rating]
    }
    
    func setImage(_ image: UIImage, for rating: Int) {
        images[rating] = image
    }
}

// MARK: - Internal

extension RatingRendererConfig {

  static func `default`() -> Self {
    let starSize = CGSize(width: 16.0, height: 16.0)
    let starImage = UIGraphicsImageRenderer(size: starSize).image {
      UIImage(systemName: "star.fill")?.draw(in: $0.cgContext.boundingBoxOfClipPath)
    }
    return RatingRendererConfig(
      ratingRange: 1...5,
      starImage: starImage,
      tintColor: .systemOrange,
      fadeColor: .systemGray4,
      spacing: 1.0
    )
  }

}

// MARK: - Renderer

/// Класс рисует изображение рейтинга (звёзды) и кэширует его.
final class RatingRenderer {

  private let config: RatingRendererConfig
  private let cache = ImageCacheActor()
  private let imageRenderer: UIGraphicsImageRenderer

  init(
    config: RatingRendererConfig,
    imageRenderer: UIGraphicsImageRenderer)
  {
    self.config = config
    self.imageRenderer = imageRenderer
  }

}

// MARK: - Internal

extension RatingRenderer {

  convenience init(config: RatingRendererConfig = .default()) {
    let size = CGSize(
      width: (config.starImage.size.width + config.spacing)
      * CGFloat(config.ratingRange.upperBound) - config.spacing,
      height: config.starImage.size.height
    )
    self.init(config: config, imageRenderer: UIGraphicsImageRenderer(size: size))
  }

  func ratingImage(_ rating: Int) async -> UIImage {
    if let cachedImage = await cache.image(for: rating) {
      return cachedImage
    }
    return await drawRatingImageAndCache(rating)
  }

}

// MARK: - Private

private extension RatingRenderer {

  func drawRatingImageAndCache(_ rating: Int) async -> UIImage {
    let ratingImage = await drawRatingImage(rating)
    await cache.setImage(ratingImage, for: rating)
    return ratingImage
  }

  func drawRatingImage(_ rating: Int) async -> UIImage {
    let tintedStarImage = config.starImage.withTintColor(config.tintColor)
    let fadedStarImage = config.starImage.withTintColor(config.fadeColor)
    return imageRenderer.image { _ in
      var origin = CGPoint.zero
      for value in config.ratingRange {
        let starImage = value <= rating ? tintedStarImage : fadedStarImage
        starImage.draw(at: origin)
        origin.x += config.starImage.size.width + config.spacing
      }
    }
  }

}
