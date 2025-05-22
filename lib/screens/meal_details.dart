import 'package:flutter/material.dart'; // Імпорт основної бібліотеки віджетів Flutter (для Material Design)
import 'package:meals/models/meal.dart'; // Імпорт файлу з моделлю даних Страви

// Віджет MealDetailsScreen є StatelessWidget, оскільки він відображає дані, передані йому через конструктор
class MealDetailsScreen extends StatelessWidget {
  const MealDetailsScreen({
    super.key,
    required this.meal,
    required this.onToggleFavorite,
    required this.isFavorite, // ← Додано новий параметр
  });

  final Meal meal;
  final void Function(Meal meal) onToggleFavorite;
  final bool isFavorite; // ← Збереження статусу "улюблене"


  @override
  Widget build(BuildContext context) {
    // Метод build описує UI екрану деталей страви
    return Scaffold(
      // Віджет Scaffold надає базову структуру екрану
      appBar: AppBar(
  title: Text(meal.title),
  actions: [
    IconButton(
      onPressed: () {
        onToggleFavorite(meal);
      },
      icon: Icon(
        isFavorite ? Icons.star : Icons.star_border, // ← Умовна іконка
      ),
    ),
  ],
),

      body: SingleChildScrollView(
        // Тіло екрану, обгорнуте в SingleChildScrollView для можливості прокручування
        child: Column(
          // Вміст тіла екрану, розташований у вертикальному стовпці
          children: [
            // Відображення зображення страви з мережі
            Image.network(
              meal.imageUrl, // URL зображення страви
              height: 300, // Висота зображення
              width:
                  double.infinity, // Ширина зображення (на всю доступну ширину)
              fit:
                  BoxFit
                      .cover, // Масштабування зображення для заповнення області зі збереженням співвідношення сторін
            ),
            const SizedBox(height: 14), // Додавання вертикального відступу
            // Заголовок "Ingredients" (Інгредієнти)
            Text(
              'Ingredients',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                // Стиль заголовка
                color:
                    Theme.of(
                      context,
                    ).colorScheme.primary, // Колір з колірної схеми теми
                fontWeight: FontWeight.bold, // Жирний шрифт
              ),
            ),
            const SizedBox(height: 14), // Додавання вертикального відступу
            // Перебір списку інгредієнтів та відображення кожного як окремого текстового елемента
            for (final ingredient in meal.ingredients)
              Text(
                ingredient, // Текст інгредієнта
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  // Стиль тексту інгредієнта
                  color:
                      Theme.of(
                        context,
                      ).colorScheme.onBackground, // Колір тексту на фоні
                ),
              ),
            const SizedBox(
              height: 24,
            ), // Додавання більшого вертикального відступу
            // Заголовок "Steps" (Кроки)
            Text(
              'Steps',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                // Стиль заголовка
                color:
                    Theme.of(
                      context,
                    ).colorScheme.primary, // Колір з колірної схеми теми
                fontWeight: FontWeight.bold, // Жирний шрифт
              ),
            ),
            const SizedBox(height: 14), // Додавання вертикального відступу
            // Перебір списку кроків приготування та відображення кожного як окремого текстового елемента
            for (final step in meal.steps)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12, // Горизонтальні відступи навколо тексту кроку
                  vertical: 8, // Вертикальні відступи навколо тексту кроку
                ),
                child: Text(
                  step, // Текст кроку
                  textAlign: TextAlign.center, // Вирівнювання тексту по центру
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    // Стиль тексту кроку
                    color:
                        Theme.of(
                          context,
                        ).colorScheme.onBackground, // Колір тексту на фоні
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
