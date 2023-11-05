import SwiftUI

struct SearchRecordTitleView: View {
    let title: String

    init(_ title: String) {
        self.title = title
    }

    var body: some View {
        Text(title)
            .frame(width: 70, alignment: .leading)
            .minimumScaleFactor(0.6)
            .lineLimit(1)
            .truncationMode(.tail)
    }
}

struct SearchRecordTitleView_Previews: PreviewProvider {
    static var previews: some View {
        SearchRecordTitleView("sample")
    }
}
