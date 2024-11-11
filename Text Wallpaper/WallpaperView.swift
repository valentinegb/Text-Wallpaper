//
//  WallpaperView.swift
//  Glyph Wallpaper Generator
//
//  Created by Valentine Briese on 2024-11-08.
//

import SwiftUI

struct WallpaperView: View {
    private let resolution: CGSize = CGSize(width: 3840, height: 2160) // 4K
    
    @Environment(\.self) var environment: EnvironmentValues
    
    var text: String
    var font: String
    var angle: Angle
    var colors: [Color]
    var inverted: Bool
    
    var body: some View {
        GeometryReader { geometry in
            let luminances: [Float] = colors.map { color in
                let resolved: Color.Resolved = color.resolve(in: environment)
                let red: Float = 0.2126 * resolved.red
                let green: Float = 0.7152 * resolved.green
                let blue: Float = 0.722 * resolved.blue
                
                return red + green + blue
            }
            let averageLuminance: Float = luminances.reduce(0, { x, y in
                x + y
            }) / Float(luminances.count)
            
            Rectangle()
                .foregroundStyle(averageLuminance < 0.5 ? .white : .black)
                .overlay(content: {
                    var transform: CGAffineTransform = CGAffineTransform(
                        rotationAngle: angle.radians
                    )
                    let boundingBox: CGRect = CGPath(
                        rect: CGRect(origin: .zero, size: resolution),
                        transform: withUnsafePointer(to: &transform, { pointer in
                            pointer
                        })
                    ).boundingBox
                    let diagonal: CGFloat = (pow(resolution.width, 2) + pow(resolution.height, 2)).squareRoot()
                    let textView: some View = Text(text)
                        .foregroundStyle(.thinMaterial)
                        .font(.custom(font, fixedSize: 100))
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(width: diagonal)
                        .environment(\.colorScheme, averageLuminance < 0.5 ? .light : .dark)
                    let textContainer: some View = Rectangle()
                        .frame(width: boundingBox.width, height: boundingBox.height)
                        .foregroundStyle(.linearGradient(
                            colors: colors,
                            startPoint: .top,
                            endPoint: .bottom
                        ))
                    
                    if inverted {
                        textContainer
                            .mask {
                                textView
                            }
                            .rotationEffect(angle)
                    } else {
                        textContainer
                            .overlay {
                                textView
                            }
                            .rotationEffect(angle)
                    }
                })
                .frame(width: resolution.width, height: resolution.height)
                .scaleEffect(min(
                    geometry.size.width / resolution.width,
                    geometry.size.height / resolution.height
                ))
                .offset(
                    x: -(resolution.width / 2 - geometry.size.width / 2),
                    y: -(resolution.height / 2 - geometry.size.height / 2)
                )
        }
        .aspectRatio(resolution, contentMode: .fit)
        .clipped()
    }
}

#Preview {
    @Previewable @State var degrees: Double = 0
    
    WallpaperView(
        text: "Helloooo!!! :3",
        font: "SFPro-Bold",
        angle: .degrees(degrees),
        colors: [.black],
        inverted: false
    )
    CircularSliderRepresentable(value: $degrees, maxValue: 360)
}
