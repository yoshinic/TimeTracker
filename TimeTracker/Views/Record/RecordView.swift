import SwiftUI

struct RecordView: View {
    @ObservedObject var categoryViewModel: CategoryViewModel
    @ObservedObject var activityViewModel: ActivityViewModel
    @ObservedObject var recordViewModel: RecordViewModel

    @State private var selectedCategory: UUID?
    @State private var selectedActivity: UUID?

    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            ClockView()

            Form {
                Section(header: Text("レコード作成項目")) {
                    Picker("カテゴリー", selection: $selectedCategory) {
                        ForEach(categoryViewModel.categories) {
                            Text($0.name)
                                .tag($0.id as UUID?)
                                .font(.system(size: 12))
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .font(.system(size: 16))
                    .onChange(of: selectedCategory) {
                        activityViewModel.fetch(categoryId: $0)
                    }

                    Picker("アクティビティ", selection: $selectedActivity) {
                        ForEach(activityViewModel.activities) {
                            Text($0.name)
                                .tag($0.id as UUID?)
                        }
                    }
                    .font(.system(size: 16))
                }

                Section(header: Text("")) {
                    HStack {
                        Spacer()
                        Button {
                            recordViewModel.create(activityId: selectedActivity)
                        } label: {
                            Text("開始")
                        }
                        .foregroundColor(.red)
                        .bold()
                        Spacer()
                    }
                }
            }
        }
        .onAppear {
            categoryViewModel.fetch()
            selectedCategory = categoryViewModel.defaultId

            activityViewModel.fetch(categoryId: selectedCategory)
            selectedActivity = nil
        }
    }
}

private struct ClockView: View {
    @State private var currentTime = Date()
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    private let yyyymmddFormatter: DateFormatter
    private let HHmmssFormatter: DateFormatter

    var body: some View {
        VStack {
            Text(verbatim: yyyymmddFormatter.string(from: currentTime))
                .onReceive(timer) { _ in
                    self.currentTime = Date()
                }
                .font(.title2)
                .padding()

            Text(verbatim: HHmmssFormatter.string(from: currentTime))
                .onReceive(timer) { _ in
                    self.currentTime = Date()
                }
                .font(.title)
        }
        .background(.clear)
    }

    init() {
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
                fromTemplate: "ydMMMEEE",
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
    }
}

struct RecordView_Previews: PreviewProvider {
    static var previews: some View {
        RecordView(
            categoryViewModel: .init(),
            activityViewModel: .init(),
            recordViewModel: .init()
        )
    }
}
