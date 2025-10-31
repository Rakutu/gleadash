## Roadmap: gleadash — минималистичный lodash-подобный набор утилит на Gleam для JS

Цель — создать небольшую, производительную и удобную библиотеку из "80/20" самых часто используемых функций lodash + щепотка функционального подхода (pipe/compose/curry/partial и т.п.), компилируемую из Gleam в JavaScript и публикуемую в npm.

### Принципы
- **Минимализм**: только самые нужные функции; без избыточности.
- **Чистота и иммутабельность**: не мутировать входные структуры данных.
- **Прозрачный DX**: предсказуемые названия, хорошая документация, примеры.
- **Tree-shaking**: модульные экспорт/импорт, отсутствие сайд-эффектов.
- **Совместимость**: ESM по умолчанию, поддержка Node и бандлеров.

---

## Этап 0. База проекта и инфраструктура
1) Инициализация и настройки
- Инициализировать проект `gleam` (уже сделано), включить таргет JS в `gleam.toml` (`target = "javascript"`).
- Стандартизировать структуру модулей: публичный API из `src/gleadash.gleam` и подмодулей `src/gleadash/*`.
- Выбрать MIT лицензирование.

2) Тесты и качество
- Подключить `gleeunit` и написать smoke-тесты для сборки JS.
- Настроить GitHub Actions: линт/тест/сборка на Node LTS (минимум 18, 20).

3) Документация
- Обновить `README.md`: цели, установка, быстрая демонстрация.
- Добавить `CONTRIBUTING.md`, `CHANGELOG.md`.

4) Релизы и npm
- Добавить `package.json` (ESM, `sideEffects: false`, скрипты сборки/тестов).
- Настроить автоматическую сборку на публикацию (`prepublishOnly`).

Пример (набросок) `package.json`:
```json
{
  "name": "@your-scope/gleadash",
  "version": "0.1.0",
  "description": "Minimal lodash-like utils compiled from Gleam to JS",
  "type": "module",
  "sideEffects": false,
  "exports": {
    ".": "./build/prod/javascript/gleadash.mjs"
  },
  "files": [
    "build/prod/javascript",
    "README.md",
    "LICENSE"
  ],
  "scripts": {
    "dev": "gleam build -t javascript",
    "build": "gleam build -t javascript --release",
    "test": "gleam test -t javascript",
    "prepublishOnly": "npm run build"
  },
  "keywords": ["gleam", "lodash", "fp", "utils"],
  "license": "MIT"
}
```

---

## Этап 1. Фундаментальные утилиты (MVP ядро)
Цель — закрыть базовые потребности и выстроить стиль API.

- **Функции-основания**: `identity`, `constant`, `noop`.
- **Проверки/агрегации**: `is_nil`, `is_empty`, `size`.
- **Числа**: `clamp`, `in_range`, `range` (диапазон чисел), `times(n, f)`.
- **Сравнение**: простое `eq` (строгое/поверхностное; глубокое — позже, если потребуется).

Тесты и примеры в `README` для каждого пункта.

---

## Этап 2. Функциональные комбинаторы (FP-акценты)
- **Композиция**: `pipe` (как функция для JS-пользователей), `flow`, `compose`.
- **Адаптеры функций**: `curry`, `partial`, `flip`.
- **Контроль вызовов**: `once`, `memoize` (на shalow-ключах), `debounce`, `throttle`.
- **Логические комбинаторы предикатов**: `negate`, `both`, `either`.
- **Безопасное выполнение**: `try_catch` → `Result` для интеропа с JS.

Примечание: в самом Gleam уже есть оператор `|>`, но JS-потребителям удобнее иметь `pipe/flow` как функции.

---

## Этап 3. Массивы/списки (основа lodash-уровня)
- **Фильтрация/форма**: `compact`, `chunk`, `flatten`, `flatten_depth`.
- **Множества**: `uniq`, `uniq_by`, `union`, `intersection`, `difference`.
- **Извлечение**: `first`, `last`, `nth`, `take`, `take_right`, `drop`, `drop_right`, `slice`.
- **Группировка**: `group_by`, `key_by`, `count_by`.
- **Композиции**: `zip`, `unzip`, `partition`.
- **Сортировка**: `sort_by` (стабильная), `order_by` (мульти-ключи позже).

Все операции — иммутабельные (возвращают новые структуры).

---

## Этап 4. Объекты/записи (работа с путями и преобразованиями)
- **Доступ**: `get(path)`, `has(path)`; безопасная навигация по вложенным полям.
- **Мутации (иммутабельные)**: `set(path, value)` без изменения исходника.
- **Проекции**: `pick(keys)`, `omit(keys)`.
- **Преобразования**: `map_values`, `map_keys`.
- **Слияние**: `merge` (shallow), `merge_deep` (по необходимости).
- **Pairs**: `entries`, `from_pairs`.

Опционально: глубокое сравнение и равенство — только если реальный спрос.

---

## Этап 5. Строки (кейсы и форматирование)
- **Кейсы**: `camel_case`, `kebab_case`, `snake_case`, `pascal_case`, `start_case`.
- **Регистр**: `capitalize`, `uncapitalize`.
- **Паддинги/тримы**: `pad`, `pad_start`, `pad_end`, `trim*`.
- Опционально: `words`, `deburr` (нормализация диакритики).

---

## Этап 6. Числа и статистика
- **Агрегации**: `sum`, `mean`, `median`.
- **Выборки**: `min_by`, `max_by`.
- **Диапазоны**: `random`, `random_int`, `round_to`.

---

## Этап 7. Асинхронность и тайминг
- **Утилиты**: `delay/sleep`.
- **Контроль**: `debounce_async`, `throttle_async`.
- **Пулы**: `p_map_limit` (ограничение конкуренции, хорош для IO-задач).

---

## Этап 8. DX, документация и примеры
- Сгенерированные доки (через `gleam`), плюс ручные примеры в `README`.
- Примеры использования на JS/TS и на Gleam.
- Краткие заметки о производительности и иммутабельности.

---

## Этап 9. Производительность, совместимость, размер
- Микробенчмарки: сравнить ключевые функции с lodash/ramda.
- Совместимость: Node (LTS), бандлеры (Vite/Rollup/Webpack) — убедиться в tree-shaking.
- Размер: проверить, что импорт отдельных функций (ESM) действительно выкидывает лишнее.

---

## Этап 10. Стабилизация и релиз 1.0
- Заморозка API; аудиты имен/аргументов/поведения.
- Changelog, семантическое версионирование.
- Публикация на npm: `npm publish --access public` (после `npm login`).

---

## Приоритеты функций (первая версия → последующие)

### MVP (v0.1.x)
- База: `identity`, `constant`, `noop`, `is_nil`, `is_empty`, `size`.
- Числа: `clamp`, `in_range`, `range`, `times`.
- FP: `pipe`, `flow`, `compose`, `once`, `memoize`, `debounce`, `throttle`.
- Массивы: `compact`, `chunk`, `uniq`, `uniq_by`, `flatten`, `group_by`, `key_by`, `take/drop/slice`, `first/last`, `difference`, `intersection`, `union`.
- Объекты: `get`, `set` (иммутабельно), `pick`, `omit`, `map_values`.

### Next (v0.2.x)
- `count_by`, `zip/unzip`, `partition`, `sort_by`, `order_by` (базовый), `map_keys`, `merge`.
- Строки: кейс-конвертеры (`camel_case`, `kebab_case`, ...).
- Статистика: `sum`, `mean`, `min_by`, `max_by`.

### Later (v0.3+)
- `merge_deep`, `median`, `round_to`, `debounce_async`, `throttle_async`, `p_map_limit`.
- Глубокое сравнение/равенство (если реально потребуется).

---

## Сборка и публикация

### Настройки Gleam
В `gleam.toml` должно быть:
```toml
name = "gleadash"
version = "0.1.0"
# Ключевая настройка для таргета JS
target = "javascript"

[dependencies]
# пример зависимости стандартной библиотеки
gleam_stdlib = "~> 0.36"
```

### Скрипты
- `npm run dev` — быстрая сборка JS.
- `npm run build` — релизная сборка JS (минимум для публикации).
- `npm test` — юнит-тесты (JS-таргет).
- `npm publish` — публикация (после логина и увеличения версии).

### Импорт в JS (ожидаемо ESM)
```js
import { chunk /* и т.п. */ } from '@your-scope/gleadash'

const result = chunk([1,2,3,4,5], 2) // => [[1,2],[3,4],[5]]
```

Для надёжности: добавить раздел «Совместимость» в `README` и зафиксировать проверенные сценарии (Node 18/20, Vite/webpack, TS).

---

## Критерии готовности (Definition of Done) по этапам
- Реализованы функции этапа + покрытие тестами (минимум happy-path + крайние случаи).
- Документация и примеры обновлены.
- Проверка tree-shaking на простом проекте с бандлером.
- Семантическая версия обновлена, changelog пополнен.

---

## Риски и как их адресовать
- **Глубокие операции (mergeDeep, deepEqual)**: сложность и производительность — отложить до реального спроса.
- **TS-типов не будет «из коробки» от Gleam**: по возможности добавить JSDoc/ручные `.d.ts` для ключевых модулей в следующих версиях.
- **ESM/CJS**: фокус на ESM; CJS поддержка — только если будет запрос.

---

## Мини-план реализации ближайших задач
1) Этап 0: настроить JS-таргет, скрипты npm, CI и базовые тесты.
2) Этап 1: реализовать `identity`, `constant`, `noop`, `is_empty`, `size`, `clamp`, `in_range`, `range`, `times`.
3) Этап 2: `pipe`, `flow`, `compose`, `once`, `memoize`, `debounce`, `throttle`.
4) Этап 3: `compact`, `chunk`, `uniq`, `uniq_by`, `flatten`, `group_by`, `key_by`, `take/drop/slice`, `first/last`, `difference`, `intersection`, `union`.
5) Подготовить `README` с примерами и опубликовать v0.1.0 в npm.
