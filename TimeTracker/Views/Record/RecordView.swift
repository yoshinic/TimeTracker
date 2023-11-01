import SwiftUI
import TimeTrackerAPI

struct RecordView: View {
    @ObservedObject var categoryViewModel: CategoryViewModel
    @ObservedObject var activityViewModel: ActivityViewModel
    @ObservedObject var recordViewModel: RecordViewModel

    @State private var selectedCategory: UUID = .init()
    @State private var selectedActivity: UUID? = nil

    @State private var categories: [CategoryData] = []
    @State private var activities: [UUID: [ActivityData]] = [:]

    var body: some View {
        Form {
            Section("") {
                ClockView()
            }
            Section(header: Text("レコード作成項目")) {
                Picker("カテゴリ", selection: $selectedCategory) {
                    ForEach(categories) {
                        Text($0.name)
                            .tag($0.id as UUID?)
                            .font(.system(size: 12))
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .font(.system(size: 16))
                .onChange(of: selectedCategory) { categoryId in
                    selectedActivity = activities[categoryId]?.first?.id
                }

                Picker("アクティビティ", selection: $selectedActivity) {
                    ForEach(activities[selectedCategory] ?? []) {
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
                        Task {
                            try await recordViewModel.create(activityId: selectedActivity)
                        }
                    } label: {
                        Text("開始")
                    }
                    .foregroundColor(.red)
                    .bold()
                    Spacer()
                }
            }
        }
        .onAppear {
            Task {
                try await categoryViewModel.fetch()
                selectedCategory = categoryViewModel.defaultId
                categories = categoryViewModel.categories

                try await activityViewModel.fetch()
                selectedActivity = nil
                activities = activityViewModel.activities.toUUIDDic
            }
        }
    }
}

private struct ClockView: View {
    @State private var currentTime = Date()
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    private let yyyymmddFormatter: DateFormatter
    private let HHmmssFormatter: DateFormatter

    var body: some View {
        VStack(alignment: .center) {
            Text(verbatim: yyyymmddFormatter.string(from: currentTime))
                .onReceive(timer) { _ in
                    self.currentTime = Date()
                }
                .font(.system(size: 28))
                .minimumScaleFactor(0.6)
                .lineLimit(1)
                .truncationMode(.tail)
                .padding()

            Text(verbatim: HHmmssFormatter.string(from: currentTime))
                .onReceive(timer) { _ in
                    self.currentTime = Date()
                }
                .font(.system(size: 28))
                .minimumScaleFactor(0.6)
                .lineLimit(1)
                .truncationMode(.tail)
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
