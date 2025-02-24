/// Модель отзыва.
struct Review: Decodable {
    ///Имя
    let first_name: String
    //Фамилия
    let last_name: String
    /// Рейтинг
    let rating: Int
    /// Текст отзыва.
    let text: String
    /// Время создания отзыва.
    let created: String

}
