import SwiftUI

struct TextTitle: View {
    let title: String
    let width: CGFloat?

    init(
        _ title: String,
        width: CGFloat? = nil
    ) {
        self.title = title
        self.width = width
    }

    var body: some View {
        Text(title)
            .frame(width: width, alignment: .leading)
            .minimumScaleFactor(0.6)
            .lineLimit(1)
            .truncationMode(.tail)
    }
}

struct TextTitle_Previews: PreviewProvider {
    static var previews: some View {
        TextTitle("sample")
    }
}
