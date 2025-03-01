
import UIKit

protocol ReviewsDisplayLogic: AnyObject {
  @MainActor
  func updateViewSuccess()
  @MainActor
  func updateViewFailure()
  
  func showFullReview(at index: Int)
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
    reviewsView.delegate = self
    title = "Отзывы"
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    reviewsView.setupTableViewConfiguration(with: viewModel)
    viewModel.getReviews()
  }
  
}

// MARK: - ReviewsViewDelegate

extension ReviewsViewController: ReviewsViewDelegate {

  func updateTableView() {
    viewModel.getReviews()
  }

}

// MARK: - ReviewsDisplayLogic
extension ReviewsViewController: ReviewsDisplayLogic {
  
  func showFullReview(at index: Int) {
    let indexPath = IndexPath(row: index, section: 0)
    reviewsView.reloadRows(at: [indexPath])
  }
  
  func updateViewSuccess() {
    let state = viewModel.getState()
    reviewsView.reloadTableView()
    reviewsView.updateFooter(with: state.totalReviews)
  }
  
  func updateViewFailure() {
    // Если вы видите этот комментарий, значит я не успела написать эту логику
    // Но в заданиях этого не было, этот метод создан исключительно из моего желания сделать этот код еще прекраснее :)
    assertionFailure("Что-то пошло не так")
  }
  
}
