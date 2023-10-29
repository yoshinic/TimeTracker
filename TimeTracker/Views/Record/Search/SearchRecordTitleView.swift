import SwiftUI

struct SearchTitleView: View {
    let title: String
    var body: some View {
        Text(title)
            .frame(width: 70, alignment: .leading)
            .minimumScaleFactor(0.6)
            .lineLimit(1)
            .truncationMode(.tail)
    }
}

struct SearchTitleView_Previews: PreviewProvider {
    static var previews: some View {
        SearchTitleView(title: "sample")
    }
}
