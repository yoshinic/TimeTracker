import SwiftUI
import TimeTrackerAPI

struct RecordView: View {
    @ObservedObject var categoryViewModel: CategoryViewModel
    @ObservedObject var activityViewModel: ActivityViewModel
    @ObservedObject var recordViewModel: RecordViewModel

    @State private var categories: [CategoryData] = []
    @State private var activities: [ActivityData] = []

    @State private var selectedCategoryId: UUID = .init()
    @State private var selectedActivityId: UUID = .init()

    @State private var defaultCategoryId: UUID = .init()
    @State private var defaultActivityId: UUID = .init()

    var body: some View {
        Form {
            Section("") {
                ClockView()
            }
            Section("カテゴリの絞込み") {
                Picker("カテゴリ", selection: $selectedCategoryId) {
                    ForEach(categories) {
                        Text($0.name).tag($0.id)
                    }
                }
                .pickerStyle(.menu)
                .font(.system(size: 16))
                .onChange(of: selectedCategoryId) { id in
                    if id != defaultCategoryId {
                        selectedActivityId = filteredActivities(id).first?.id
                            ?? defaultActivityId
                    }
                }
            }
            Section("アクティビティの選択") {
                Picker("アクティビティ", selection: $selectedActivityId) {
                    ForEach(filteredActivities(selectedCategoryId)) {
                        Text($0.name).tag($0.id)
                    }
                }
                .pickerStyle(.menu)
                .font(.system(size: 16))
            }

            Section(header: Text("")) {
                HStack {
                    Spacer()
                    Button {
                        Task {
                            try await recordViewModel.create(activityId: selectedActivityId)
                        }
                    } label: {
                        Text("開始")
                    }
                    .foregroundColor(
                        selectedActivityId == defaultActivityId
                            ? .gray : .red
                    )
                    .bold()
                    .disabled(selectedActivityId == defaultActivityId)
                    Spacer()
                }
            }
        }
        .onAppear {
            Task {
                defaultCategoryId = .init()
                defaultActivityId = .init()
                let defaultCategory: CategoryData = .init(
                    id: defaultCategoryId,
                    name: "未設定",
                    color: "",
                    order: -1
                )

                let defaultActivity: ActivityData = .init(
                    id: defaultActivityId,
                    category: defaultCategory,
                    name: "未設定",
                    color: "",
                    order: -1
                )

                try await categoryViewModel.fetch()
                categories = [defaultCategory] + categoryViewModel.categories
                selectedCategoryId = defaultCategory.id

                try await activityViewModel.fetch()
                activities = [defaultActivity] + activityViewModel.activities
                selectedActivityId = defaultActivity.id
            }
        }
    }

    private func filteredActivities(_ categoryId: UUID) -> [ActivityData] {
        if categoryId == defaultCategoryId {
            activities
        } else {
            activities.filter { $0.category.id == categoryId }
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
