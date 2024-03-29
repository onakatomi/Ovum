import SwiftUI
import Foundation

func getRandomColor() -> Color {
    let chatHistoryColours = [AppColours.green, AppColours.indigo, AppColours.mint, AppColours.peach, AppColours.pink]
    let randomIndex = Int.random(in: 0..<chatHistoryColours.count)
    return chatHistoryColours[randomIndex]
}

func getDateAsString(date: Date) -> String {
    let dateFormatter = DateFormatter()

    // Set the date format you desire
    dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"

    // Create a Date object
    let date = Date()

    // Convert the Date object to a string
    return dateFormatter.string(from: date)
}

enum DateFormats {
    case basic
    case elegant
    case noTime
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
            formatter.dateFormat = "d MMMM yyyy"
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
