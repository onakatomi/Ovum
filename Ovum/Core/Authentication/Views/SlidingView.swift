//import Combine
//import Introspect
//import SwiftUI
//
//struct SlidingKeyboardTest: View {
//    @State var inputText = "Placeholder"
//    @State var keyboardHeight = CGFloat(0)
//    @State var scrollView: UIScrollView? = nil
//
//    var body: some View {
//        VStack {
//            ScrollView {
//                LazyVStack {
//                    ForEach(1 ... 100, id: \.self) { id in
//                        HStack {
//                            Spacer()
//                            Text("message \(id)")
//                            Spacer()
//                        }
//                    }
//                }
//            }.introspectScrollView {
//                scrollView = $0
//            }
//            TextEditor(text: $inputText)
//                .frame(height: 50)
//        }.onReceive(Publishers.keyboardHeight) { height in
//            if height > 0 {
//                self.scrollView!.setContentOffset(CGPoint(x: 0, y: self.scrollView!.contentOffset.y + height), animated: true)
//            } else {
//                self.scrollView!.contentOffset.y = max(self.scrollView!.contentOffset.y - keyboardHeight, 0)
//            }
//
//            keyboardHeight = height
//        }
//
//        .background(LinearGradient(gradient: Gradient(colors: [.white, .blue, .white]), startPoint: .top, endPoint: .bottom))
//        .onTapGesture { UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil) }
//    }
//}
//
//struct SlidingKeyboardTest_Previews: PreviewProvider {
//    static var previews: some View {
//        SlidingKeyboardTest()
//    }
//}
