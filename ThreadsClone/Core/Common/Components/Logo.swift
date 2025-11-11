import SwiftUI

struct Logo: View {
    let size: Double
    
    var body: some View {
        Image(Icons.logo)
            .resizable()
            .scaledToFill()
            .frame(width: size, height: size)
    }
}

#Preview {
    Logo(size: 75)
}
