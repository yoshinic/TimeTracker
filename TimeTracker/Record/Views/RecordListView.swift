import SwiftUI
import TimeTrackerAPI

struct RecordListView: View {
    @StateObject var state: RecordListViewState

    var body: some View {
        Section(header: RecordHeaderView()) {
            ForEach(state.records) { record in
                HStack {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(record.activity?.category?.name ?? "未登録")
                        Text(record.activity?.name ?? "未登録")
                    }
                    .font(.system(size: 18))
                    .minimumScaleFactor(0.6)
                    .bold()
                    .lineLimit(1)
                    .truncationMode(.tail)
                    Spacer()
                    RecordListDateView(state: .init(record.startedAt))
                    RecordListDateView(state: .init(record.endedAt))
                }
                .onTapGesture { state.onTapRecordRow(record) }
            }
            .onDelete { idx in Task { await state.onDelete(idx) }}
        }
        .sheet(item: $state.selectedRecord) {
            UpdateRecordView(state: .init($0))
        }
        .navigationBarTitle("記録一覧", displayMode: .inline)
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
            Text("開始")
            Spacer()
            Text("終了")
        }
        .frame(alignment: .center)
        .font(.system(size: 14))
        .bold()
    }
}

private struct RecordListDateView: View {
    @StateObject var state: RecordListDateViewState

    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            Text(verbatim: state.formatedDateString)
            Text(verbatim: state.formatedTimeString)
        }
        .frame(width: 80)
        .font(.system(size: 16))
        .bold()
    }
}

struct RecordListView_Previews: PreviewProvider {
    static var previews: some View {
        RecordListView(state: .init())
    }
}
