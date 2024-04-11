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
    content.title = "Reminder"
    content.body = "It's been 24 hours since you chatted to Ovum, don't forget to log today's session!"
    content.sound = UNNotificationSound.default

    // 3. Set up a trigger for the notification
    // For example, 10 seconds from now
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
