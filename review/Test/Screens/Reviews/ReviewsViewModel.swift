
import UIKit

protocol ReviewsPresentationLogic: UITableViewDelegate, UITableViewDataSource {

  func getReviews()
  func getState() -> ReviewsViewModelState

}

/// Класс, описывающий бизнес-логику экрана отзывов.
final class ReviewsViewModel: NSObject {
  
  typealias State = ReviewsViewModelState

  private weak var viewController: ReviewsDisplayLogic?

  private var state: State

  private let reviewsProvider: ProvidesReviews
  private let ratingRenderer: RatingRenderer
  private let decoder: JSONDecoder
  
  init(
    viewController: ReviewsDisplayLogic,
    reviewsProvider: ProvidesReviews,
    state: State = State(),
    ratingRenderer: RatingRenderer = RatingRenderer(),
    decoder: JSONDecoder = JSONDecoder())
  {
    self.viewController = viewController
    self.state = state
    self.reviewsProvider = reviewsProvider
    self.ratingRenderer = ratingRenderer
    self.decoder = decoder
  }

}

// MARK: - ReviewsPresentationLogic

extension ReviewsViewModel: ReviewsPresentationLogic {

  /// Метод получения отзывов.
  func getReviews() { Task {
    do {
      guard state.shouldLoad else {
        return
      }
      state.shouldLoad = false
      let result = try await reviewsProvider.getReviews(offset: state.offset)
      await gotReviews(result)
      await viewController?.updateViewSuccess()
    } catch {
      await viewController?.updateViewFailure()
    }
  }}
  
  /// Метод передачи состояния View Model-и
  func getState() -> ReviewsViewModelState {
    state
  }

}

// MARK: - Private

private extension ReviewsViewModel {

  /// Метод обработки получения отзывов.
  func gotReviews(_ result: Data) async {
    do {
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      let reviews = try decoder.decode(Reviews.self, from: result)

      /// Параллельная загрузка отзывов через TaskGroup
      var items = Array<ReviewItem?>(repeating: nil, count: reviews.items.count)
      await withTaskGroup(of: (Int, ReviewItem).self) { group in
        for (index, review) in reviews.items.enumerated() {
          group.addTask {
            let item = await self.makeReviewItem(review)
            return (index, item)
          }
        }
        for await (index, item) in group {
          items[index] = item
        }
      }
      state.items += items.compactMap { $0 }
      state.offset += state.limit
      state.shouldLoad = state.offset < reviews.count
      state.totalReviews = state.shouldLoad ? state.offset : reviews.count
    } catch {
      state.shouldLoad = true
    }
  }

  /// Метод, вызываемый при нажатии на кнопку "Показать полностью...".
  /// Снимает ограничение на количество строк текста отзыва (раскрывает текст).
  func showMoreReview(with id: UUID) {
    guard
      let index = state.items
        .firstIndex(where: { ($0 as? ReviewItem)?.id == id }),
      var item = state.items[index] as? ReviewItem
    else { return }
    item.maxLines = .zero
    state.items[index] = item
    viewController?.showFullReview(at: index)
  }

}

// MARK: - Items

private extension ReviewsViewModel {

  typealias ReviewItem = ReviewCellConfig

  func makeReviewItem(_ review: Review) async -> ReviewItem {
    let avatar = await reviewsProvider.loadImage(from: review.avatarUrl) ?? .avatar
    let userName = (review.firstName + " " + review.lastName).attributed(font: .username)
    let rating = ratingRenderer.ratingImage(review.rating)
    let reviewText = review.text.attributed(font: .text)
    let created = review.created.attributed(font: .created, color: .created)
    let item = ReviewItem(
      avatar: avatar,
      userName: userName,
      rating: rating,
      reviewText: reviewText,
      created: created,
      onTapShowMore: { [weak self] id in
        self?.showMoreReview(with: id)
      }
    )
    return item
  }

}

// MARK: - UITableViewDataSource

extension ReviewsViewModel: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    state.items.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let config = state.items[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: config.reuseId, for: indexPath)
    config.update(cell: cell)
    return cell
  }

}

// MARK: - UITableViewDelegate

extension ReviewsViewModel: UITableViewDelegate {

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    state.items[indexPath.row].height(with: tableView.bounds.size)
  }

  /// Метод дозапрашивает отзывы, если до конца списка отзывов осталось два с половиной экрана по высоте.
  func scrollViewWillEndDragging(
    _ scrollView: UIScrollView,
    withVelocity velocity: CGPoint,
    targetContentOffset: UnsafeMutablePointer<CGPoint>)
  {
    if shouldLoadNextPage(
      scrollView: scrollView,
      targetOffsetY: targetContentOffset.pointee.y)
    {
      getReviews()
    }
  }

  private func shouldLoadNextPage(
    scrollView: UIScrollView,
    targetOffsetY: CGFloat,
    screensToLoadNextPage: Double = 2.5) -> Bool
  {
    let viewHeight = scrollView.bounds.height
    let contentHeight = scrollView.contentSize.height
    let triggerDistance = viewHeight * screensToLoadNextPage
    let remainingDistance = contentHeight - viewHeight - targetOffsetY
    return remainingDistance <= triggerDistance
  }

}
