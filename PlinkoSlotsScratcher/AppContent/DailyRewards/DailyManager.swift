import Foundation

class DailyManager: ObservableObject {
    private let defaults = UserDefaults.standard
    private let bonusBaseAmount = 5000
    private let maxBonusDays = 7
    
    // Ключи для сохранения в UserDefaults
    private let lastBonusDateKey = "lastBonusDate"
    private let currentDayKey = "currentBonusDay"
    
    @Published var currentBonusAmount: Int = 0
    @Published var isBonusAvailable: Bool = false
    @Published var bonusDay: Int = 1 // Текущий день бонуса

    init() {
        loadBonusState()
    }
    
    // Метод для загрузки состояния бонусов
    private func loadBonusState() {
        let lastBonusDate = defaults.object(forKey: lastBonusDateKey) as? Date
        let today = Date()

        // Проверка, если бонус уже был получен сегодня
        if let lastBonusDate = lastBonusDate, Calendar.current.isDate(lastBonusDate, inSameDayAs: today) {
            isBonusAvailable = false
            bonusDay = getCurrentBonusDay() // Загружаем текущий день
        } else {
            isBonusAvailable = true
            bonusDay = getCurrentBonusDay() // Загружаем текущий день
            currentBonusAmount = bonusBaseAmount * bonusDay
        }
    }
    
    func getBonusAmountFor(day: Int) -> Int {
        return bonusBaseAmount * day
    }
    
    // Метод для проверки доступности бонуса на конкретный день
    func isBonusAvailable(for day: Int) -> Bool {
       // Получаем текущий день
       let currentDay = getCurrentBonusDay()
       // Проверяем, что запрашиваемый день меньше или равен текущему доступному дню
        return day == currentDay && isBonusAvailable
    }
    
    // Метод для получения текущего дня бонуса
    private func getCurrentBonusDay() -> Int {
        return defaults.integer(forKey: currentDayKey) == 0 ? 1 : defaults.integer(forKey: currentDayKey)
    }
    
    // Метод для получения бонуса
    func claimBonus() -> Bool {
        guard isBonusAvailable else {
            return false
        }
        
        // Получаем текущий день бонуса
        let currentDay = getCurrentBonusDay()

        // Проверяем, доступен ли текущий день
        if currentDay <= maxBonusDays {
            // Обновляем последний день получения бонуса
            defaults.set(Date(), forKey: lastBonusDateKey)

            // Увеличиваем день для следующего бонуса
            defaults.set(currentDay + 1, forKey: currentDayKey)
            
            // Обновляем состояние
            loadBonusState()
            
            return true
        } else {
            return false
        }
    }
    
    // Метод для сброса бонусов (например, для тестирования)
    func resetBonus() {
        defaults.removeObject(forKey: lastBonusDateKey)
        defaults.removeObject(forKey: currentDayKey)
        loadBonusState() // Обновляем состояние после сброса
    }
}
