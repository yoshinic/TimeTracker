import SwiftUI

struct RecordingView: View {
    @StateObject var state: RecordingViewState

    var body: some View {
        NavigationView {
            Form {
                Section("") { ClockView() }
                Section("カテゴリの絞込み") {
                    Picker("カテゴリ", selection: $state.selectedCategoryId) {
                        ForEach(state.categories) {
                            Text($0.name).tag($0.id)
                        }
                    }
                    .pickerStyle(.menu)
                    .font(.system(size: 16))
                    .onChange(of: state.selectedCategoryId) { id in
                        state.onChange(id: id)
                    }
                }

                Section("アクティビティの選択") {
                    if state.filteredActivities.isEmpty {
                        SearchRecordTitleView("アクティビティ")
                    } else {
                        Picker(selection: $state.selectedActivityId) {
                            ForEach(state.filteredActivities) {
                                Text($0.name).tag($0.id)
                            }
                        } label: {
                            SearchRecordTitleView("アクティビティ")
                        }
                        .pickerStyle(.menu)
                        .font(.system(size: 16))
                    }
                }

                Section("") {
                    HStack {
                        Spacer()
                        Button {
                            Task { await state.onTapStart() }
                        } label: {
                            Text("開始")
                        }
                        .foregroundColor(
                            state.selectedActivityId == state.dummyActivityId
                                ? .gray : .red
                        )
                        .bold()
                        .disabled(state.selectedActivityId == state.dummyActivityId)
                        Spacer()
                    }
                }
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
        RecordingView(state: .init())
    }
}
