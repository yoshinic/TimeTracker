import SwiftUI

struct RecordListView: View {
    @StateObject var state: RecordListViewState

    var body: some View {
        Section(header: RecordHeaderView()) {
            ForEach(state.records) { record in
                HStack(spacing: 10) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(record.activity?.category?.name ?? "未登録")
                        Text(record.activity?.name ?? "未登録")
                    }

                    .frame(width: 120, alignment: .leading)
                    .font(.system(size: 16))
                    .minimumScaleFactor(0.6)
                    .bold()
                    .lineLimit(1)
                    .truncationMode(.tail)

                    VStack(alignment: .center, spacing: 8) {
                        RecordDateTimeView(state: state, date: record.startedAt)
                        RecordDateTimeView(state: state, date: record.endedAt)
                    }
                    .frame(alignment: .center)

                    RecordProgressView(
                        state: state,
                        startDate: record.startedAt,
                        endDate: record.endedAt
                    )
                    .frame(width: 60, alignment: .center)
                }
                .onTapGesture { state.onTapRecordRow(record) }
            }
            .onDelete { idx in Task { await state.onDelete(idx) }}
        }
        .sheet(item: $state.selectedRecord) {
            UpdateRecordView(state: .init($0))
        }
    }
}

private struct RecordHeaderView: View {
    var body: some View {
        HStack {
            VStack(spacing: 5)  {
                Text("カテゴリーと")
                Text("アクティビティ")
            }
            Spacer()
            VStack(spacing: 5) {
                Text("開始時間")
                Text("終了時間")
            }
            Spacer()

            Text("経過時間")
        }
        .frame(alignment: .center)
        .font(.system(size: 14))
        .bold()
    }
}

private struct RecordDateTimeView: View {
    @ObservedObject var state: RecordListViewState

    let date: Date?

    var body: some View {
        Text(verbatim: date == nil ? "(未設定)" : state.formatedDateString(date))
            .font(.system(size: 16))
            .bold()
            .lineLimit(1)
            .minimumScaleFactor(0.6)
            .truncationMode(.tail)
    }
}

private struct RecordProgressView: View {
    @ObservedObject var state: RecordListViewState

    let startDate: Date
    let endDate: Date?

    var body: some View {
        Text(verbatim: state.calcProgressString(startDate, endDate))
            .frame(width: 60)
            .font(.system(size: 16))
            .bold()
            .lineLimit(1)
            .minimumScaleFactor(0.6)
            .truncationMode(.tail)
    }
}

struct RecordListView_Previews: PreviewProvider {
    static var previews: some View {
        RecordListView(state: .init())
    }
}
