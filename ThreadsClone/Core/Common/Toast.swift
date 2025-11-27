import SwiftUI
import AlertToast

struct Toast {
    static func show(_ message: String?) -> AlertToast {
        AlertToast(
            displayMode: .hud,
            type: .error(.white),
            title: "Whoops!",
            subTitle: message,
            style: .style(
                backgroundColor: .red.opacity(0.85),
                titleColor: Colors.title,
                subTitleColor: Colors.title
            )
        )
    }
}
