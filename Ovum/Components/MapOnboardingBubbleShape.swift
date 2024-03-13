import SwiftUI

struct MapOnboardingBubbleShape: Shape {
    var cornerRadius: CGFloat = 12
    var arrowRectSize: CGFloat = 10
    var arcLength: CGFloat = 12

    /// 0.0 = left, 0.5 = center, 1.0 = right
    var arrowOffsetFraction: CGFloat = 0.5

    func baseXPos(for rect: CGRect) -> CGFloat {
        (rect.maxX - cornerRadius - cornerRadius - arrowRectSize) * arrowOffsetFraction + cornerRadius
    }

    func path(in rect: CGRect) -> Path {
        let roundedRect = Path(roundedRect: rect, cornerRadius: cornerRadius)
        let arrowPath = Path { p in
            p.move(to: .init(x: baseXPos(for: rect), y: rect.maxY))
            p.addLine(to: .init(
                x: baseXPos(for: rect) + arrowRectSize - arcLength,
                y: rect.maxY + arrowRectSize - arcLength
            ))
            p.addQuadCurve(
                to: .init(
                    x: baseXPos(for: rect) + arrowRectSize,
                    y: rect.maxY + arrowRectSize - arcLength
                ),
                control: .init(
                    x: baseXPos(for: rect) + arrowRectSize,
                    y: rect.maxY + arrowRectSize
                )
            )
            p.addLine(to: .init(x: baseXPos(for: rect) + arrowRectSize, y: rect.maxY))
            p.closeSubpath()
        }
        let combinedCGPath = roundedRect.cgPath.union(arrowPath.cgPath)
        let combinedPath = Path(combinedCGPath)
        return combinedPath
    }
}
