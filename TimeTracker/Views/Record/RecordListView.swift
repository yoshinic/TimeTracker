import SwiftUI

struct RecordListView: View {
    @ObservedObject var viewModel: RecordViewModel

    var body: some View {
        #if os(macOS)
        _RecordListView(viewModel: viewModel)
        #elseif os(iOS)
        _RecordListView(viewModel: viewModel)
            .navigationBarTitle("記録一覧", displayMode: .inline)
        #else
        EmptyView()
        #endif
    }
}

struct _RecordListView: View {
    @ObservedObject var viewModel: RecordViewModel

    var body: some View {
        VStack {
            List {
                Section(header: HeaderView()) {
                    ForEach(viewModel.records) { record in
                        HStack {
                            VStack(alignment: .leading, spacing: 12) {
                                Text(record.activity?.category.name ?? "未登録")
                                Text(record.activity?.name ?? "未登録")
                            }
                            .font(.system(size: 18))
                            .minimumScaleFactor(0.6)
                            .bold()
                            .lineLimit(1)
                            .truncationMode(.tail)
                            Spacer()
                            DateView(date: record.startedAt)
                            DateView(date: record.endedAt)
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetch()
        }
    }
}

struct HeaderView: View {
    var body: some View {
        HStack {
            VStack(spacing: 5)  {
                Text("カテゴリーと")
                Text("アクティビティ")
            }
            Spacer()
            Text("開始")
            Spacer()
            Text("終了")
        }
        .frame(alignment: .center)
        .font(.system(size: 14))
        .bold()
    }
}

private struct DateView: View {
    private let yyyymmddFormatter: DateFormatter
    private let HHmmssFormatter: DateFormatter

    private let date: Date?

    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            Text(verbatim: date == nil ? "" : yyyymmddFormatter.string(from: date!))
            Text(verbatim: date == nil ? "" : HHmmssFormatter.string(from: date!))
        }
        .frame(width: 80)
        .font(.system(size: 16))
        .bold()
    }

    init(date: Date? = nil) {
        let createTemplateFormatter = {
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .gregorian)
            formatter.locale = Locale(identifier: "ja_JP")
            formatter.timeZone = TimeZone(identifier:  "Asia/Tokyo")
            return formatter
        }

        self.yyyymmddFormatter = {
            let formatter = createTemplateFormatter()
            formatter.dateFormat = DateFormatter.dateFormat(
                fromTemplate: "MM/dd(E)",
                options: 0,
                locale: Locale(identifier: "ja_JP")
            )
            return formatter
        }()

        self.HHmmssFormatter = {
            let formatter = createTemplateFormatter()
            formatter.dateFormat = DateFormatter.dateFormat(
                fromTemplate: "HHmmss",
                options: 0,
                locale: Locale(identifier: "ja_JP")
            )
            return formatter
        }()

        self.date = date
    }
}

struct RecordListView_Previews: PreviewProvider {
    static var previews: some View {
        RecordListView(
            viewModel: .init()
        )
    }
}
