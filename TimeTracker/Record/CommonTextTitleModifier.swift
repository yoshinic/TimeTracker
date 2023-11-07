import SwiftUI

struct CommonTextTitleModifier: ViewModifier {
    let color: Color
    let fontSize: CGFloat?
    let opacity: Double
    let paddingH: CGFloat
    let paddingV: CGFloat
    let lineLimit: Int?
    let active: Bool

    init(
        color: Color = .gray,
        fontSize: CGFloat? = nil,
        opacity: Double = 0.4,
        paddingH: CGFloat = 14,
        paddingV: CGFloat = 5,
        lineLimit: Int? = 1,
        active: Bool = true
    ) {
        self.color = color
        self.fontSize = fontSize
        self.opacity = opacity
        self.paddingH = paddingH
        self.paddingV = paddingV
        self.lineLimit = lineLimit
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
            .padding([.horizontal], paddingH)
            .padding([.vertical], paddingV)
            .lineLimit(lineLimit)
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
        paddingH: CGFloat = 14,
        paddingV: CGFloat = 5,
        lineLimit: Int? = 1,
        active: Bool = true
    ) -> some View {
        modifier(CommonTextTitleModifier(
            color: color,
            fontSize: fontSize,
            opacity: opacity,
            paddingH: paddingH,
            paddingV: paddingV,
            lineLimit: lineLimit,
            active: active
        ))
    }
}

struct TextTitle: View {
    let title: String
    let color: Color
    let fontSize: CGFloat?
    let opacity: Double
    let paddingH: CGFloat
    let paddingV: CGFloat
    let lineLimit: Int?
    let active: Bool

    init(
        _ title: String,
        color: Color = .gray,
        fontSize: CGFloat? = nil,
        opacity: Double = 0.4,
        paddingH: CGFloat = 14,
        paddingV: CGFloat = 5,
        lineLimit: Int? = 1,
        active: Bool = true
    ) {
        self.title = title
        self.color = color
        self.fontSize = fontSize
        self.opacity = opacity
        self.paddingH = paddingH
        self.paddingV = paddingV
        self.lineLimit = lineLimit
        self.active = active
    }

    init(
        _ title: String,
        color: String = "",
        fontSize: CGFloat? = nil,
        opacity: Double = 0.4,
        paddingH: CGFloat = 14,
        paddingV: CGFloat = 5,
        lineLimit: Int? = 1,
        active: Bool = true
    ) {
        self.init(
            title,
            color: Color(hex: color),
            fontSize: fontSize,
            opacity: opacity,
            paddingH: paddingH,
            paddingV: paddingV,
            lineLimit: lineLimit,
            active: active
        )
    }

    var body: some View {
        Text(title)
            .titleProps(
                color: color,
                fontSize: fontSize,
                opacity: opacity,
                paddingH: paddingH,
                paddingV: paddingV,
                lineLimit: lineLimit,
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
    let paddingH: CGFloat
    let paddingV: CGFloat
    let lineLimit: Int?
    let active: Bool
    let toggleIf: ((Bool) -> Bool)?
    let complition: ((Bool, Bool) -> Void)?

    init(
        _ title: String,
        color: Color = .gray,
        fontSize: CGFloat? = nil,
        opacity: Double = 0.4,
        paddingH: CGFloat = 14,
        paddingV: CGFloat = 5,
        lineLimit: Int? = 1,
        active: Bool = true,
        toggleIf: ((Bool) -> Bool)? = nil,
        complition: ((Bool, Bool) -> Void)? = nil
    ) {
        self.title = title
        self.color = color
        self.fontSize = fontSize
        self.opacity = opacity
        self.paddingH = paddingH
        self.paddingV = paddingV
        self.lineLimit = lineLimit
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
        paddingH: CGFloat = 14,
        paddingV: CGFloat = 5,
        lineLimit: Int? = 1,
        active: Bool = true,
        toggleIf: ((Bool) -> Bool)? = nil,
        complition: ((Bool, Bool) -> Void)? = nil
    ) {
        self.init(
            title,
            color: Color(hex: color),
            fontSize: fontSize,
            opacity: opacity,
            paddingH: paddingH,
            paddingV: paddingV,
            lineLimit: lineLimit,
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
                paddingH: paddingH,
                paddingV: paddingV,
                lineLimit: lineLimit,
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
