# [CWAPI-A] Refill by Kill

Способность для кастомных оружий Custom Weapons API, восполняющая патроны после убийства.

Название способности: `RefillByKill`.

## Требования

- Custom Weapons API v0.8

## Параметры

| Название     | Тип    | Обязательный? | Описание                                                                  |
| :----------- | :----- | :------------ | :------------------------------------------------------------------------ |
| `RefillType` | Строка | Да            | Способ блокировки поднятия (см. [таблицу](#доступные-значение-refilltype) ниже) |

### Доступные значение `RefillType`

| Значение | Описание                                 |
| :------- | :--------------------------------------- |
| `Clip`   | Впосполнить патроны тольо в магазине     |
| `BpAmmo` | Восполнить патроны только в запасе       |
| `Both`   | Восполнить патроны в запасе и в магазине |
