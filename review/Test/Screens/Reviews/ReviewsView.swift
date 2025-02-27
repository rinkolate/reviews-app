import UIKit

final class ReviewsView: UIView {

  // TODO: - Через протоколы сделать все эти штуки приватными
  let tableView = UITableView()
  let footer = UIView()
  private let countReviewsLabel = UILabel()

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    tableView.frame = bounds.inset(by: safeAreaInsets)
    footer.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50)
    countReviewsLabel.frame = footer.bounds
  }
}

// MARK: - Private

private extension ReviewsView {

  func setupView() {
    backgroundColor = .systemBackground
    setupTableView()
  }

  func setupTableView() {
    addSubview(tableView)
    tableView.separatorStyle = .none
    tableView.allowsSelection = false
    tableView.register(ReviewCell.self, forCellReuseIdentifier: ReviewCellConfig.reuseId)
    footer.addSubview(countReviewsLabel)
    tableView.tableFooterView = footer
    countReviewsLabel.textAlignment = .center
  }
}

// TODO: - Просклонять отзывы
extension ReviewsView {
  func updateFooter(with count: Int) {
    countReviewsLabel.attributedText = ( "\(count) отзывов")
      .attributed(font: .reviewCount, color: .reviewCount)
  }
}
