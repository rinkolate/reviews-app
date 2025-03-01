
import UIKit

protocol DisplaysReviews: UIView {

  var delegate: ReviewsViewDelegate? { get set }

  func reloadTableView()
  func reloadRows(at indexPaths: [IndexPath])
  func setupTableViewConfiguration(with viewModel: ReviewsPresentationLogic)
  func updateFooter(with count: Int)

}

protocol ReviewsViewDelegate: AnyObject {

  func updateTableView()

}

final class ReviewsView: UIView {
  
  weak var delegate: ReviewsViewDelegate?
  
  private let tableView = UITableView()
  private let footer = UIView()
  private let countReviewsLabel = UILabel()
  private let refreshControl = UIRefreshControl()

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

// MARK: - DisplaysReviews
// TODO: - Просклонять отзывы
extension ReviewsView: DisplaysReviews {
  
  func reloadRows(at indexPaths: [IndexPath]) {
    tableView.reloadRows(at: indexPaths, with: .none)
  }

  func setupTableViewConfiguration(with viewModel: ReviewsPresentationLogic) {
    tableView.delegate = viewModel
    tableView.dataSource = viewModel
  }

  func reloadTableView() {
    tableView.reloadData()
  }
  
  func updateFooter(with count: Int) {
    countReviewsLabel.attributedText = ( "\(count) отзывов")
      .attributed(font: .reviewCount, color: .reviewCount)
  }
  

}

// MARK: - Private

private extension ReviewsView {

  func setupView() {
    backgroundColor = .systemBackground
    setupTableView()
    setupRefreshControl()
  }

  func setupTableView() {
    addSubview(tableView)
    tableView.separatorStyle = .none
    tableView.refreshControl = refreshControl
    tableView.allowsSelection = false
    tableView.register(ReviewCell.self, forCellReuseIdentifier: ReviewCellConfig.reuseId)
    footer.addSubview(countReviewsLabel)
    tableView.tableFooterView = footer
    countReviewsLabel.textAlignment = .center
  }
  
  func setupRefreshControl() {
    refreshControl.addAction(UIAction { [weak self] _ in
      guard let self else {
        return
      }
      delegate?.updateTableView()
      refreshControl.endRefreshing()
    }, for: .valueChanged)
  }

}
