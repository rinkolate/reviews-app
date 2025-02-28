
import UIKit

// MARK: - Typealias

fileprivate typealias Config = ReviewCellConfig
fileprivate typealias Layout = ReviewCellLayout

// MARK: - ReviewCellConfig

/// Конфигурация ячейки. Содержит данные для отображения в ячейке.
struct ReviewCellConfig {

  /// Идентификатор для переиспользования ячейки.
  static let reuseId = String(describing: ReviewCellConfig.self)

  /// Идентификатор конфигурации. Можно использовать для поиска конфигурации в массиве.
  let id = UUID()
  /// Аватар пользователя
  let avatar: UIImage
  /// Имя пользователя.
  let userName: NSAttributedString
  /// Оценка пользователя
  let rating: UIImage
  /// Текст отзыва.
  let reviewText: NSAttributedString
  /// Максимальное отображаемое количество строк текста. По умолчанию 3.
  var maxLines = 3
  /// Время создания отзыва.
  let created: NSAttributedString
  /// Замыкание, вызываемое при нажатии на кнопку "Показать полностью...".
  let onTapShowMore: (UUID) -> Void

  /// Объект, хранящий посчитанные фреймы для ячейки отзыва.
  fileprivate let layout = ReviewCellLayout()

}

// MARK: - TableCellConfig

extension ReviewCellConfig: TableCellConfig {

  /// Метод обновления ячейки.
  /// Вызывается из `cellForRowAt:` у `dataSource` таблицы.
  func update(cell: UITableViewCell) {
    guard let cell = cell as? ReviewCell else {
      return
    }
    cell.avatarImage.image = avatar
    cell.userNameLabel.attributedText = userName
    cell.ratingImage.image = rating
    cell.reviewTextLabel.attributedText = reviewText
    cell.reviewTextLabel.numberOfLines = maxLines
    cell.createdLabel.attributedText = created
    cell.config = self
  }

  /// Метод, возвращаюший высоту ячейки с данным ограничением по размеру.
  /// Вызывается из `heightForRowAt:` делегата таблицы.
  func height(with size: CGSize) -> CGFloat {
    layout.height(config: self, maxWidth: size.width)
  }

}

// MARK: - Private

private extension ReviewCellConfig {
  
  /// Текст кнопки "Показать полностью...".
  static let showMoreText = "Показать полностью..."
    .attributed(font: .showMore, color: .showMore)

}

// MARK: - Cell

final class ReviewCell: UITableViewCell {

  fileprivate var config: Config?

  fileprivate let avatarImage = UIImageView()
  fileprivate let userNameLabel = UILabel()
  fileprivate let ratingImage = UIImageView()
  fileprivate let reviewTextLabel = UILabel()
  fileprivate let createdLabel = UILabel()
  fileprivate let showMoreButton = UIButton()

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
    
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupCell()
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    guard let layout = config?.layout else {
      return
    }
    avatarImage.frame = layout.avatarImageViewFrame
    userNameLabel.frame = layout.userNameLabelFrame
    ratingImage.frame = layout.ratingViewFrame
    reviewTextLabel.frame = layout.reviewTextLabelFrame
    createdLabel.frame = layout.createdLabelFrame
    showMoreButton.frame = layout.showMoreButtonFrame
  }

}

// MARK: - Private

private extension ReviewCell {

  func setupCell() {
    setupAvatarImage()
    setupUserNameLabel()
    setupRatingImage()
    setupReviewTextLabel()
    setupCreatedLabel()
    setupShowMoreButton()
  }

  func setupAvatarImage() {
    contentView.addSubview(avatarImage)
    avatarImage.layer.cornerRadius =  ReviewCellLayout.avatarCornerRadius
    avatarImage.clipsToBounds = true
  }

  func setupUserNameLabel() {
    contentView.addSubview(userNameLabel)
  }

  func setupRatingImage() {
    contentView.addSubview(ratingImage)
    ratingImage.clipsToBounds = true
  }

  func setupReviewTextLabel() {
    contentView.addSubview(reviewTextLabel)
    reviewTextLabel.lineBreakMode = .byWordWrapping
  }

  func setupCreatedLabel() {
    contentView.addSubview(createdLabel)
  }

  func setupShowMoreButton() {
    contentView.addSubview(showMoreButton)
    showMoreButton.contentVerticalAlignment = .fill
    showMoreButton.setAttributedTitle(Config.showMoreText, for: .normal)
  }

}

// MARK: - Layout

/// Класс, в котором происходит расчёт фреймов для сабвью ячейки отзыва.
/// После расчётов возвращается актуальная высота ячейки.
private final class ReviewCellLayout {

  // MARK: - Размеры
  private static let avatarSize = CGSize(width: 36.0, height: 36.0)
  private static let photoSize = CGSize(width: 55.0, height: 66.0)
  private static let showMoreButtonSize = Config.showMoreText.size()

  fileprivate static let avatarCornerRadius = 18.0
  fileprivate static let photoCornerRadius = 8.0

  // MARK: - Фреймы

  private(set) var avatarImageViewFrame = CGRect.zero
  private(set) var userNameLabelFrame = CGRect.zero
  private(set) var ratingViewFrame = CGRect.zero
  private(set) var reviewTextLabelFrame = CGRect.zero
  private(set) var showMoreButtonFrame = CGRect.zero
  private(set) var createdLabelFrame = CGRect.zero

  // MARK: - Отступы

  /// Отступы от краёв ячейки до её содержимого.
  private let insets = UIEdgeInsets(top: 9.0, left: 12.0, bottom: 9.0, right: 12.0)
  /// Горизонтальный отступ от аватара до имени пользователя.
  private let avatarToUsernameSpacing = 10.0
  /// Вертикальный отступ от имени пользователя до вью рейтинга.
  private let usernameToRatingSpacing = 6.0
  /// Вертикальный отступ от вью рейтинга до текста (если нет фото).
  private let ratingToTextSpacing = 6.0
  /// Вертикальный отступ от вью рейтинга до фото.
  private let ratingToPhotosSpacing = 10.0
  /// Горизонтальные отступы между фото.
  private let photosSpacing = 8.0
  /// Вертикальный отступ от фото (если они есть) до текста отзыва.
  private let photosToTextSpacing = 10.0
  /// Вертикальный отступ от текста отзыва до времени создания отзыва или кнопки "Показать полностью..." (если она есть).
  private let reviewTextToCreatedSpacing = 6.0
  /// Вертикальный отступ от кнопки "Показать полностью..." до времени создания отзыва.
  private let showMoreToCreatedSpacing = 6.0

  // MARK: - Расчёт фреймов и высоты ячейки

  /// Возвращает высоту ячейку с данной конфигурацией `config` и ограничением по ширине `maxWidth`.
  func height(config: Config, maxWidth: CGFloat) -> CGFloat {
    var width = maxWidth - insets.left - insets.right
    var maxY = insets.top
    var maxX = insets.left
    var showShowMoreButton = false
    
    avatarImageViewFrame = CGRect(
      origin: CGPoint(x: maxX, y: maxY),
      size: ReviewCellLayout.avatarSize
    )
    
    maxX = avatarImageViewFrame.maxX + avatarToUsernameSpacing
    
    if !config.userName.isEmpty() {
      let currentTextHeight = (config.userName.font()?.lineHeight ?? .zero)
      
      userNameLabelFrame = CGRect(
        origin: CGPoint(x: maxX, y: maxY),
        size: config.userName.boundingRect(width: width, height: currentTextHeight).size
      )
      maxY = userNameLabelFrame.maxY + reviewTextToCreatedSpacing
      width -= avatarImageViewFrame.width + avatarToUsernameSpacing
    }
    
    ratingViewFrame = CGRect(
      origin: CGPoint(x: maxX, y: maxY),
      size: config.rating.size
    )
    
    maxY = ratingViewFrame.maxY + ratingToTextSpacing
    
    if !config.reviewText.isEmpty() {
      // Высота текста с текущим ограничением по количеству строк.
      let currentTextHeight = (config.reviewText.font()?.lineHeight ?? .zero)
      * CGFloat(config.maxLines)
      // Максимально возможная высота текста, если бы ограничения не было.
      let actualTextHeight = config.reviewText.boundingRect(width: width).size.height
      // Показываем кнопку "Показать полностью...", если максимально возможная высота текста больше текущей.
      showShowMoreButton = config.maxLines != .zero && actualTextHeight > currentTextHeight
      
      reviewTextLabelFrame = CGRect(
        origin: CGPoint(x: maxX, y: maxY),
        size: config.reviewText.boundingRect(width: width, height: currentTextHeight).size
      )
      maxY = reviewTextLabelFrame.maxY + reviewTextToCreatedSpacing
    }

    if showShowMoreButton {
      showMoreButtonFrame = CGRect(
        origin: CGPoint(x: maxX, y: maxY),
        size: Self.showMoreButtonSize
      )
      maxY = showMoreButtonFrame.maxY + showMoreToCreatedSpacing
    } else {
      showMoreButtonFrame = .zero
    }
    createdLabelFrame = CGRect(
      origin: CGPoint(x: maxX, y: maxY),
      size: config.created.boundingRect(width: width).size
    )
    return createdLabelFrame.maxY + insets.bottom
  }

}
