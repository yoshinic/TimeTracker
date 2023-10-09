import SwiftUI

struct Theme {
    let primaryColor: Color
    let secondaryColor: Color
    let backgroundColor: Color
    let textColor: Color
}

let lightTheme = Theme(
    primaryColor: .white,
    secondaryColor: .gray,
    backgroundColor: .white,
    textColor: .black
)

let darkTheme = Theme(
    primaryColor: .black,
    secondaryColor: .gray,
    backgroundColor: .black,
    textColor: .white
)

// 1. 新しい EnvironmentKey を定義します。
struct ThemeKey: EnvironmentKey {
    static let defaultValue: Theme = lightTheme // あなたのデフォルトのテーマを設定します。
}

// 2. EnvironmentValues の拡張を作成して、新しいキーを追加します。
extension EnvironmentValues {
    var theme: Theme {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
}

// 3. この新しいキーを使用して、ビューの環境を設定します。
// .environment(\.theme, selectedTheme == "Light" ? lightTheme : darkTheme)
