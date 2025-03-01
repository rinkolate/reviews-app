
import UIKit

// MARK: - Typealias

fileprivate typealias Layout = ReviewPhotoCellLayout

final class ReviewPhotoCell: UICollectionViewCell {
  
  let imageView = UIImageView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupCell()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    imageView.frame = CGRect(
      origin: CGPoint(x: 0.0, y: 0.0),
      size: Layout.photoSize
    )
  }

}

// MARK: - Private

private extension ReviewPhotoCell {
  
  func setupCell() {
    contentView.addSubview(imageView)
    imageView.layer.cornerRadius = Layout.photoCornerRadius
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true

  }

}

private final class ReviewPhotoCellLayout {
  
  fileprivate static let photoSize = CGSize(width: 55.0, height: 66.0)
  fileprivate static let photoCornerRadius = 8.0
}



