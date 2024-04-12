import UserNotifications

func scheduleAppReminderNotification() {
    // 1. Request permission to display alerts and play sounds.
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
        if granted {
            print("Permission already granted")
        } else if let error = error {
            print(error.localizedDescription)
        }
    }
    
    // Clear out pending notifications
    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()

    // 2. Create the content for the notification
    let content = UNMutableNotificationContent()
    content.title = "How are you feeling?"
    content.body = "It’s been 24 hours since you logged your last symptom, I’d love an update."
    content.sound = UNNotificationSound.default

    // 3. Set up a trigger for the notification
    // For example, 1 day from now
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: (86400), repeats: false)

    // 4. Create the request
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

    // 5. Add the request to the notification center
    UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
            print(error.localizedDescription)
        } else {
            print("Notification scheduled")
        }
    }
}

func logFirstSymptomNotification() {
    // 1. Request permission to display alerts and play sounds.
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
        if granted {
            print("Permission already granted")
        } else if let error = error {
            print(error.localizedDescription)
        }
    }

    // 2. Create the content for the notification
    let content = UNMutableNotificationContent()
    content.title = "Just checking in"
    content.body = "Help me help you better — log a symptom if you have any."
    content.sound = UNNotificationSound.default

    // 3. Set up a trigger for the notification
    // For example, 1 day from now
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: (345600), repeats: false)

    // 4. Create the request
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

    // 5. Add the request to the notification center
    UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
            print(error.localizedDescription)
        } else {
            print("Notification scheduled")
        }
    }
}
