import UIKit

final class ReviewsViewController: UIViewController {

  private lazy var reviewsView: DisplaysReviews = ReviewsView()
  private let viewModel: ReviewsViewModel

  init(viewModel: ReviewsViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func loadView() {
    view = reviewsView
    reviewsView.delegate = self
    title = "Отзывы"
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupViewModel()
    viewModel.getReviews()
  }
}

extension ReviewsViewController: ReviewsViewDelegate {
  func returnConfiguration() -> ReviewsViewModel {
    return viewModel
  }
}

// MARK: - Private

private extension ReviewsViewController {
    
  func setupViewModel() {
    viewModel.onStateChange = { [weak self] state in
      guard let self else {
        return
      }
      reviewsView.reloadTableView()
      reviewsView.updateFooter(with: state.totalReviews)
    }
  }
}
