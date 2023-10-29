import SwiftUI

struct CommonTextTitleModifier: ViewModifier {
    @Binding var isSelected: Bool

    let color: Color
    let fontSize: CGFloat?
    let opacity: Double
    let togglable: Bool
    let onTapGesture: ((Bool) -> Void)?

    init(
        isSelected: Binding<Bool>,
        color: Color,
        fontSize: CGFloat? = nil,
        opacity: Double = 0.2,
        togglable: Bool = false,
        onTapGesture: ((Bool) -> Void)? = nil
    ) {
        self._isSelected = isSelected
        self.color = color
        self.fontSize = fontSize
        self.opacity = opacity
        self.togglable = togglable
        self.onTapGesture = onTapGesture
    }

    func body(content: Content) -> some View {
        if !togglable || isSelected {
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
            .onTapGesture {
                if togglable {
                    isSelected.toggle()
                }
                onTapGesture?(isSelected)
            }
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
        isSelected: Binding<Bool> = .constant(false),
        _ color: Color,
        fontSize: CGFloat? = nil,
        _ opacity: Double = 0.2,
        _ togglable: Bool = false,
        _ onTapGesture: ((Bool) -> Void)? = nil
    ) -> some View {
        modifier(CommonTextTitleModifier(
            isSelected: isSelected,
            color: color,
            fontSize: fontSize,
            opacity: opacity,
            togglable: togglable,
            onTapGesture: onTapGesture
        ))
    }
}
