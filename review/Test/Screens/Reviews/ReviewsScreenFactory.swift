final class ReviewsScreenFactory {

  /// Создаёт контроллер списка отзывов, проставляя нужные зависимости.
  func makeReviewsController() -> ReviewsViewController {
    let reviewsProvider = ReviewsProvider()
    let controller = ReviewsViewController()
    let viewModel = ReviewsViewModel(viewController: controller, reviewsProvider: reviewsProvider)
    
    controller.viewModel = viewModel
    return controller
  }
}
