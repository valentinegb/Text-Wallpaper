//
//  ContentView.swift
//  Glyph Wallpaper Generator
//
//  Created by Valentine Briese on 2024-11-04.
//

import SwiftUI

struct ContentView: View {
    enum TextPreset: String {
        case loremIpsum = """
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam auctor, ex sit amet bibendum posuere, metus massa placerat metus, ac tempus sapien orci in sapien. Praesent vehicula quis justo id tempor. Proin condimentum id leo sit amet facilisis. Ut vitae suscipit dui, et blandit ipsum. Suspendisse feugiat maximus ante, in pellentesque augue pellentesque in. Integer nulla lacus, malesuada quis turpis nec, rhoncus tristique risus. Ut hendrerit sodales risus et ullamcorper. Quisque varius ante orci, eget volutpat urna rutrum sit amet. Nulla aliquet justo et nisi dictum, at convallis mauris tincidunt. Nam cursus eleifend tortor, sit amet ultrices sapien porttitor sit amet. Morbi nec feugiat mauris. Donec vitae finibus quam, id cursus nisl. Etiam lobortis eu quam vitae ullamcorper. Sed dictum dapibus felis, dictum blandit nunc bibendum molestie. Quisque sed consectetur arcu, ut accumsan purus. Vivamus pharetra lectus ut aliquam porttitor. Sed a orci sit amet tellus mollis malesuada vitae sit amet ante. Duis ac facilisis purus, in aliquam nulla. Suspendisse potenti. Nam ante sem, varius eget semper eget, gravida non neque. Duis eu lacus interdum, placerat orci vitae, sollicitudin lorem. Integer finibus, lorem id condimentum porttitor, lorem nulla mollis nisl, quis tincidunt magna mauris sed metus. Vivamus venenatis diam ac ipsum iaculis sagittis. Vivamus faucibus tortor in lacus dictum, vel pretium enim congue. Donec pellentesque metus non libero gravida fermentum. Praesent porta lacus vestibulum nibh elementum, in laoreet eros accumsan. Suspendisse non elit consectetur, pulvinar ipsum et, suscipit massa. In nec nisl non nisl imperdiet sollicitudin. In sit amet diam vel tortor porttitor feugiat a sit amet mauris. Donec et turpis eget metus malesuada lobortis in id erat. In hendrerit augue et leo ultrices, ullamcorper fringilla tellus sagittis.
        """
        case repeating
        case custom
    }
    
    @State private var textPreset: TextPreset = .repeating
    @State private var customText: String = "Edit me!"
    @State private var font: String = "SFPro-Black"
    @State private var degrees: Double = 355
    @State private var colors: [Color] = [.black]
    @State private var inverted: Bool = false
    
    @State private var fileExporterIsPresented: Bool = false
    @State private var image: Data?
    @State private var fileExporterErrorAlertIsPresented: Bool = false
    @State private var fileExporterErrorDescription: String?
    @State private var isEditing: Bool = false

    var body: some View {
        let text = if case .custom = textPreset {
            customText
        } else if case .repeating = textPreset {
            if customText.count > 0 {
                Array(repeating: customText, count: 4000 / customText.count).joined(separator: " ")
            } else {
                ""
            }
        } else {
            textPreset.rawValue
        }
        let wallpaper: WallpaperView = WallpaperView(
            text: text,
            font: font,
            angle: .degrees(degrees),
            colors: colors,
            inverted: inverted
        )
        
        VStack {
            wallpaper
                .clipShape(.rect(cornerRadius: 10))
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(.separator, lineWidth: 2)
                }
            Form {
                LabeledContent("Font:") {
                    Menu {
                        ForEach(NSFontManager.shared.availableFonts, id: \.self) { name in
                            Button {
                                font = name
                            } label: {
                                Text(name).font(.custom(name, size: 13))
                            }

                        }
                    } label: {
                        Text(font).font(.custom(font, size: 13))
                    }
                }
                HStack {
                    // FIXME: This functions similarly to the menu above, but it's a picker instead. Inconsistency? Uh ohhh stinkyyyyyy!
                    Picker("Text:", selection: $textPreset) {
                        Text("Lorem Ipsum").tag(TextPreset.loremIpsum)
                        Text("Repeating").tag(TextPreset.repeating)
                        Text("Custom").tag(TextPreset.custom)
                    }
                    
                    if textPreset == .custom || textPreset == .repeating {
                        Button("Edit") {
                            isEditing = true
                        }
                        .sheet(isPresented: $isEditing) {
                            VStack {
                                TextEditor(text: $customText)
                                    .font(.custom(font, size: 13))
                                    .frame(height: 200)
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 5)
                                            .strokeBorder()
                                            .foregroundStyle(.separator)
                                    }
                                HStack {
                                    Spacer()
                                    Button("Close") {
                                        isEditing = false
                                    }
                                    .buttonStyle(.borderedProminent)
                                }
                            }
                            .padding()
                        }
                    }
                }
                LabeledContent("Colors:") {
                    HStack {
                        ForEach(colors.indices, id: \.self) { index in
                            ColorPicker("", selection: $colors[index], supportsOpacity: false)
                                .labelsHidden()
                        }
                        Stepper("", onIncrement: {
                            if colors.count < 6 {
                                colors.append(.black)
                            }
                        }, onDecrement: {
                            if colors.count > 1 {
                                colors.removeLast()
                            }
                        })
                        .labelsHidden()
                    }
                }
                Toggle("Inverted", isOn: $inverted)
                LabeledContent("Rotation:") {
                    CircularSliderRepresentable(value: $degrees, maxValue: 360)
                        .padding(EdgeInsets(top: 16, leading: 0, bottom: -16, trailing: 0))
                        .offset(y: -16)
                }
            }
            .padding(.top)
            .frame(maxWidth: 500)
            Spacer()
            Button("Generate") {
                let renderer: ImageRenderer = ImageRenderer(content: wallpaper.frame(
                    width: 3840,
                    height: 2160
                ))
                
                guard let cgImage = renderer.cgImage else {
                    fileExporterErrorDescription = "Failed to render image"
                    fileExporterErrorAlertIsPresented = true
                    
                    return
                }
                
                guard let pngRepresentation = NSBitmapImageRep(cgImage: cgImage)
                    .representation(using: .png, properties: [:])
                else {
                    fileExporterErrorDescription = "Failed to represent image as PNG"
                    fileExporterErrorAlertIsPresented = true
                    
                    return
                }
                
                image = pngRepresentation
                fileExporterIsPresented = true
            }
            .buttonStyle(.borderedProminent)
            .fileExporter(
                isPresented: $fileExporterIsPresented,
                item: image,
                defaultFilename: "Text Wallpaper.png"
            ) { result in
                if case .failure(let error) = result {
                    fileExporterErrorDescription = error.localizedDescription
                    fileExporterErrorAlertIsPresented = true
                }
            }
            .alert("File Exporter Failure", isPresented: $fileExporterErrorAlertIsPresented, actions: {
                Button("OK") {}
            }, message: {
                if let fileExporterErrorDescription {
                    Text(fileExporterErrorDescription)
                }
            })
            .dialogSeverity(.critical)
        }
        .padding()
        .frame(minWidth: 400, idealWidth: 531, minHeight: 423)
    }
}

#Preview {
    ContentView()
}
