/// Модель, хранящая состояние вью модели.
struct ReviewsViewModelState {

  var items = [any TableCellConfig]()
  let limit = 20
  var offset = 0
  var shouldLoad = true
  var totalReviews: Int = 0
}
