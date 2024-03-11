import SwiftUI
import Foundation

struct AppColours {
    static let brown = Color(red: 0.98, green: 0.96, blue: 0.92)
    static let green = Color(red: 0.7, green: 0.88, blue: 0.61)
    static let indigo = Color(red: 0.76, green: 0.73, blue: 0.95)
    static let maroon = Color(red: 0.4, green: 0.16, blue: 0.06)
    static let mint = Color(red: 0.74, green: 0.95, blue: 0.92)
    static let peach = Color(red: 1, green: 0.82, blue: 0.6)
    static let pink = Color(red: 0.95, green: 0.82, blue: 0.83)
}

func getRandomColor() -> Color {
    let chatHistoryColours = [AppColours.green, AppColours.indigo, AppColours.mint, AppColours.peach, AppColours.pink]
    let randomIndex = Int.random(in: 0..<chatHistoryColours.count)
    return chatHistoryColours[randomIndex]
}

func getDateAsString(date: Date) -> String {
    let dateFormatter = DateFormatter()

    // Set the date format you desire
    dateFormatter.dateFormat = "dd/MM/yyyy K:mm a"

    // Create a Date object
    let date = Date()

    // Convert the Date object to a string
    return dateFormatter.string(from: date)
}

func base64ToImage(_ base64String: String) -> Image? {
    // Convert the base64 string to data
    let afterEqualsTo: String
    if let index = base64String.firstIndex(of: ",") {
        afterEqualsTo = String(base64String.suffix(from: index).dropFirst())
    } else { return nil }
    
    guard let imageData = Data(base64Encoded: afterEqualsTo) else {
        return nil
    }
    
    // Convert the data to UIImage
    guard let image = UIImage(data: imageData) else {
        return nil
    }
    
    return Image(uiImage: image)
}

func imageToBase64(_ image: UIImage) -> String? {
    // Detect image format
    let imageData: Data
    var format: ImageFormat?
    
    if let pngData = image.pngData() {
        imageData = pngData
        format = .png
    } else if let jpegData = image.jpegData(compressionQuality: 1.0) {
        imageData = jpegData
        format = .jpeg
    } else {
        return nil // Unable to convert to data
    }
    
    // Encode image data to base64 string
    let base64EncodedString = imageData.base64EncodedString()
    
    // Append appropriate prefix based on image format
    var formattedBase64String: String
    if let format = format {
        switch format {
        case .png:
            formattedBase64String = "data:image/png;base64," + base64EncodedString
        case .jpeg:
            formattedBase64String = "data:image/jpeg;base64," + base64EncodedString
        }
        return formattedBase64String
    }
    
    return nil // Unknown format
}

// Helper enum to detect image format
enum ImageFormat {
    case png
    case jpeg
}
