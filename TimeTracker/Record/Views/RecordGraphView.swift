import SwiftUI
import Charts

struct RecordGraphView: View {
    @StateObject var state: RecordGraphViewState

    var body: some View {
        Section("レコード") {
            Chart {
                ForEach(state.records) { record in
                    ForEach(state.division(record.startedAt, record.endedAt ?? Date())) {
                        BarMark(
                            x: .value("Date", $0.start),
                            yStart: .value("Start", $0.start),
                            yEnd: .value("End", $0.end)
                        )
                        .foregroundStyle(state.color(hex: record.activity?.color))
                    }
                }
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) {
                    AxisValueLabel(format: .dateTime.day())
                }
            }
            .chartYAxis {
                AxisMarks(values: .stride(by: 1)) {
//                    AxisValueLabel("\($0)")
                }
            }
        }
    }
}

struct RecordGraphView_Previews: PreviewProvider {
    static var previews: some View {
        RecordGraphView(state: .init())
    }
}
