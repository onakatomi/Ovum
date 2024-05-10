import SwiftUI
import Foundation

func getRandomColor() -> Color {
    let chatHistoryColours = [AppColours.green, AppColours.indigo, AppColours.mint, AppColours.peach, AppColours.pink]
    let randomIndex = Int.random(in: 0..<chatHistoryColours.count)
    return chatHistoryColours[randomIndex]
}

func splitDateTime(datetimeString: String, start: Bool, number: Int) -> String {
    let words = datetimeString.split(separator: " ")  // Split by space
    if start {
        let groupedWords = words.prefix(number)  // Take the first x elements
        let result = groupedWords.joined(separator: " ")  // Reconstruct the sentence        
        return result
    } else {
        let groupedWords = words.suffix(number)  // Take the last x elements
        let result = groupedWords.joined(separator: " ")  // Reconstruct the sentence
        return result
    }
}

func getDateAsString(date: Date) -> String {
    let dateFormatter = DateFormatter()

    // Set the date format you desire
    dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"

    // Create a Date object
//    let date = Date()

    // Convert the Date object to a string
    return dateFormatter.string(from: date)
}

enum DateFormats {
    case basic
    case elegant
    case noTime
    case overview
}

func stripDateString(dateString: String, format: DateFormats) -> String {
    // Convert to date object
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
    let date = dateFormatter.date(from: dateString)
    
    // Convert to modified String form
    let modifiedDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        switch format {
        case .basic:
            formatter.dateFormat = "MMMM yy"
        case .noTime:
            formatter.dateFormat = "dd/MM/yy"
        case .elegant:
            formatter.dateFormat = "d MMM yyyy h:mm a"
        case .overview:
            formatter.dateFormat = "dd MMM yyyy"
        }
        return formatter
    }()
    
    if (date != nil) {
        return modifiedDateFormatter.string(from: date!)
    } else {
        return "FAILED DATE"
    }
}

func convertToDate(dateString: String) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
    let val = dateFormatter.date(from: dateString)
    return val
}

func monthFromDate(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM, YY"
    return formatter.string(from: date)
}

func addOrSubtractDay(day:Int) -> Date {
  return Calendar.current.date(byAdding: .day, value: day, to: Date())!
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

func stringBeforeComma(from input: String) -> String {
    // Split the string into an array using "," as a separator
    let components = input.components(separatedBy: ",")
    
    // Take the first element (before the first comma)
    if let firstComponent = components.first {
        return firstComponent
    } else {
        // If no comma is found, return the whole input string
        return input
    }
}

// Helper enum to detect image format
enum ImageFormat {
    case png
    case jpeg
}
