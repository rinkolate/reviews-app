# reviews-app

+ Язык разработки: Swift 6.0
+ IDE: Xcode 16.0

Проект реализован с упором на чистую архитектуру, асинхронные операции и следование современным стандартам кодирования.

### Основные изменения и оптимизации
#### 1 Добавление footer с количеством отзывов
+ В конец UITableView добавлен UIView, содержащий UILabel, отображающий общее количество отзывов.
+ В State ViewModel добавлена переменная totalReviews для хранения этого количества и динамического обновления значения в UILbael.
+ Настроено постепенное прибавление числа отзывов в футере путём изменения totalReviews в State.

#### 2 Исправление бага со скроллом
+ Логика получения отзывов в провайдере переписана с использованием async/await.
+ Ранее метод внутри провайдера выполнялся на главном потоке, из-за чего интерфейс зависал.
+ Изначально я использовала GCD, но в итоге остановились на async/await из-за его читабельности и современного подхода к работе с асинхронностью.

#### 3 Исправлен цикл сильных ссылок 
+ Внутри ViewModel был обнаружен цикл сильных ссылок в замыкании, назначенном кнопке «Показать больше».
+ Замыкание переписано с использованием [weak self], что позволяет избегать утечек памяти и гарантирует, что ViewModel корректно освобождается

#### 4 Закончена верстка ячейки отзыва согласно примеру
Нужно ли здесь что-то пояснять?

#### 5 Внедрение протоколов
+ Внедрены протоколы для Provider, ViewModel, ViewController и View.
+ Это позволило ослабить зависимости между классами и сделать их менее связанными напрямую.
+ Многие свойства теперь private благодаря дополнительной инкапсуляции через протоколы.
  (А еще это полезно для тестирования)

#### 6 Код был отрефакторен в соответсвии с Airbnb Guide

#### 7 Упрощение обновления данных
+ Убрано замыкание onStateChange из View Model
+ Обновление таблицы реализовано через вызовы методов контроллера, определённых в протоколе.
+ во ViewModel методы для успешного и неуспешного сценария во ViewController вызываются через do-catch блоки, тк я отказалась completion handler.

#### 8 Обновление ячейки по тапу на «Показать полностью»
Добавлен метод для reloadRows в таблице, который позволяет обновлять размер только одной ячейки без перезагрузки всей таблицы. Ну и кнопка теперь кликабельна.

#### 9 Добавила loader и pull to refresh
+ Реализованы методы  появления и скрытия стандартного лоадера
+ Реализована функция pull to refresh
+ Добавлены методы обновления данных при свайпе вниз

#### 10 Асинхронная загрузка изображений с кэшированием
+ Реализован метод загрузки изображений через URLSession.
+ Введён класс для кэширования изображений на базе NSCache.
+ Реализована параллельная загрузка отзывов через TaskGroup со строгой сохранностью порядка отзывов

#### 11 Отображение фотографий отзывов через CollectionView
+ Фотографии отзывов загружаются из сети и отображаются в UICollectionView
+ (Это решение пока требует доработки, но рабочее)

#### 12 Actor для Rating rendere
+ Обернула словарь для кеширования изображений в актор, ибо так как несколько потоков обращались к нему одновременно у нас возникали race conditions
+ Но теперь ничего плохого не возникает!

Проделана большая работа по улучшению отзывчивости, производительности и читаемости кода. Проект стал гибче и устойчивее к изменениям, а пользовательский опыт — плавнее и приятнее.

Автор-редактор: Митина Екатерина
















