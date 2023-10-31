import SwiftUI

struct CommonTextTitleModifier: ViewModifier {
    let color: Color
    let fontSize: CGFloat?
    let opacity: Double
    let active: Bool

    init(
        color: Color = .gray,
        fontSize: CGFloat? = nil,
        opacity: Double = 0.4,
        active: Bool = true
    ) {
        self.color = color
        self.fontSize = fontSize
        self.opacity = opacity
        self.active = active
    }

    func body(content: Content) -> some View {
        if active {
            viewWithFontSize(content)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(color.opacity(opacity))
                )
        } else {
            viewWithFontSize(content)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(lineWidth: 1.2)
                )
                .foregroundColor(color)
        }
    }

    private func view(_ content: Content) -> some View {
        content
            .padding([.horizontal], 14)
            .padding([.vertical], 5)
            .lineLimit(1)
            .minimumScaleFactor(0.6)
            .truncationMode(.tail)
    }

    private func viewWithFontSize(_ content: Content) -> some View {
        Group {
            if fontSize == nil {
                view(content)
            } else {
                view(content).font(.system(size: fontSize!))
            }
        }
    }
}

extension View {
    func titleProps(
        color: Color = .gray,
        fontSize: CGFloat? = nil,
        opacity: Double = 0.4,
        active: Bool = true
    ) -> some View {
        modifier(CommonTextTitleModifier(
            color: color,
            fontSize: fontSize,
            opacity: opacity,
            active: active
        ))
    }
}

struct TextTitle: View {
    let title: String
    let color: Color
    let fontSize: CGFloat?
    let opacity: Double
    let active: Bool

    init(
        _ title: String,
        color: Color = .gray,
        fontSize: CGFloat? = nil,
        opacity: Double = 0.4,
        active: Bool = true
    ) {
        self.title = title
        self.color = color
        self.fontSize = fontSize
        self.opacity = opacity
        self.active = active
    }

    init(
        _ title: String,
        color: String = "",
        fontSize: CGFloat? = nil,
        opacity: Double = 0.4,
        active: Bool = true
    ) {
        self.init(
            title,
            color: Color(hex: color),
            fontSize: fontSize,
            opacity: opacity,
            active: active
        )
    }

    var body: some View {
        Text(title)
            .titleProps(
                color: color,
                fontSize: fontSize,
                opacity: opacity,
                active: active
            )
    }
}

struct TogglableTextTitle: View {
    @State var isSelected: Bool

    let title: String
    let color: Color
    let fontSize: CGFloat?
    let opacity: Double
    let active: Bool
    let toggleIf: ((Bool) -> Bool)?
    let complition: ((Bool, Bool) -> Void)?

    init(
        _ title: String,
        color: Color = .gray,
        fontSize: CGFloat? = nil,
        opacity: Double = 0.4,
        active: Bool = true,
        toggleIf: ((Bool) -> Bool)? = nil,
        complition: ((Bool, Bool) -> Void)? = nil
    ) {
        self.title = title
        self.color = color
        self.fontSize = fontSize
        self.opacity = opacity
        self.active = active
        self.toggleIf = toggleIf
        self.complition = complition

        self._isSelected = .init(initialValue: self.active)
    }

    init(
        _ title: String,
        color: String = "",
        fontSize: CGFloat? = nil,
        opacity: Double = 0.4,
        active: Bool = true,
        toggleIf: ((Bool) -> Bool)? = nil,
        complition: ((Bool, Bool) -> Void)? = nil
    ) {
        self.init(
            title,
            color: Color(hex: color),
            fontSize: fontSize,
            opacity: opacity,
            active: active,
            toggleIf: toggleIf,
            complition: complition
        )
    }

    var body: some View {
        Text(title)
            .titleProps(
                color: color,
                fontSize: fontSize,
                opacity: opacity,
                active: isSelected
            )
            .onTapGesture {
                let old = isSelected

                if toggleIf == nil || toggleIf!(isSelected) {
                    isSelected.toggle()
                }
                complition?(old, isSelected)
            }
    }
}

struct RadioTextTitle: View {
    @State var activeIndex: Int? = nil
    let items: [RadioTextTitleData]

    init(
        activeIndex: Int? = nil,
        _ items: [RadioTextTitleData]
    ) {
        self.activeIndex = activeIndex
        self.items = items
    }

    var body: some View {
        ForEach(items.indices, id: \.self) { i in
            TextTitle(
                items[i].name,
                color: .gray,
                active: activeIndex == i
            )
            .onTapGesture {
                let old = activeIndex
                activeIndex = i
                items[i].complition?(old, activeIndex!)
            }
        }
    }

    struct RadioTextTitleData {
        let name: String
        let complition: ((Int?, Int) -> Void)?

        init(
            _ name: String,
            complition: ((Int?, Int) -> Void)? = nil
        ) {
            self.name = name
            self.complition = complition
        }
    }
}
