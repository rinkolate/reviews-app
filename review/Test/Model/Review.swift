/// Модель отзыва.
struct Review: Decodable {
  ///Имя
  let firstName: String
  //Фамилия
  let lastName: String
  /// Рейтинг
  let rating: Int
  /// Текст отзыва.
  let text: String
  /// Время создания отзыва.
  let created: String
}
