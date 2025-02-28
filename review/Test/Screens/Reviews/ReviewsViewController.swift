import UIKit

protocol ReviewsDisplayLogic: AnyObject {
  @MainActor
  func updateViewSuccess()
  @MainActor
  func updateViewFailure()
}

final class ReviewsViewController: UIViewController {

  private lazy var reviewsView: DisplaysReviews = ReviewsView()
  var viewModel: ReviewsPresentationLogic!

  init() {
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func loadView() {
    view = reviewsView
    title = "Отзывы"
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    reviewsView.setupTableViewConfiguration(with: viewModel)
    viewModel.getReviews()
  }
}

// MARK: - ReviewsViewDelegate

extension ReviewsViewController: ReviewsDisplayLogic {
  func updateViewSuccess() {
    let state = viewModel.getState()
    reviewsView.reloadTableView()
    reviewsView.updateFooter(with: state.totalReviews)
  }
  
  func updateViewFailure() {
    // TODO: - 
  }
}
