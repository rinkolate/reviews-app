/// Модель отзыва.
struct Review: Decodable {
  /// Аватар
  let avatarUrl: String
  /// Имя
  let firstName: String
  // Фамилия
  let lastName: String
  /// Рейтинг
  let rating: Int
  /// Текст отзыва.
  let text: String
  /// Фото отзыва
  let photoUrls: [String]?
  /// Время создания отзыва.
  let created: String
}
