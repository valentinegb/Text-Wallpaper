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
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur consequat sollicitudin venenatis. Sed tristique condimentum nisi, in interdum sapien varius in. Ut vehicula sem magna. Donec semper leo quam, mattis cursus quam elementum nec. Vestibulum venenatis quis justo vulputate placerat. Cras ut tempor erat, eget consequat dolor. Phasellus facilisis ullamcorper magna quis vestibulum. Donec vel lectus ac augue congue tincidunt. Curabitur bibendum luctus aliquam. In hac habitasse platea dictumst. Vivamus lectus orci, tristique ac urna ac, posuere euismod velit. Donec eget nibh at lacus pharetra congue. Maecenas suscipit auctor ex at laoreet. Ut dapibus sodales varius. Duis tempus, odio a suscipit imperdiet, neque purus ultricies arcu, interdum suscipit enim nisi vel arcu. Ut dolor ante, pretium non elit eget, mollis pellentesque quam. Phasellus ac commodo justo, tincidunt vestibulum nunc. Vestibulum imperdiet metus odio, ut ultricies lectus egestas eu. Ut aliquam in nisi sit amet dignissim. Vivamus id arcu lorem. Phasellus nec scelerisque risus. Etiam auctor eros sed odio ullamcorper laoreet. Quisque gravida rutrum consectetur. Integer semper dignissim purus, vel pulvinar lorem varius vel. Aliquam erat volutpat. Etiam porta urna nisl, eu iaculis orci sollicitudin non. In sagittis nunc et lectus molestie condimentum. In vulputate leo fringilla rhoncus porttitor. In facilisis erat odio, ac consectetur ipsum tincidunt quis. Aliquam erat volutpat. Nulla commodo dui mi, vitae lobortis diam imperdiet vitae. Aliquam porttitor lacinia tellus, id pretium nibh consequat et. Integer vel nisl eget quam viverra rhoncus vitae non dolor. In in nunc sit amet ligula suscipit eleifend sed in lorem. Cras pellentesque mi magna, sed finibus ligula volutpat nec. Aliquam non augue bibendum, feugiat quam id, tempus metus. Curabitur faucibus tempor massa nec sollicitudin. Nulla auctor arcu id leo elementum ultrices. Nullam condimentum ullamcorper fringilla. Sed et dolor leo. Cras ante dui, bibendum non nulla sed, sagittis tristique justo. Nulla non sodales orci. In gravida elementum ligula, id placerat tortor dignissim quis. Fusce fringilla bibendum vestibulum. Phasellus convallis a nunc id aliquet. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Nullam id mi ac neque dignissim dignissim tincidunt eget velit. Fusce in venenatis dolor. Integer porttitor scelerisque nunc ut vestibulum. Morbi mauris neque, fringilla vel molestie vitae, scelerisque in tortor. Vestibulum eget placerat nulla. Duis luctus turpis ac velit tincidunt luctus. Pellentesque et ornare risus. In pulvinar tortor eu metus maximus porttitor. Nullam facilisis neque nec eleifend ornare. Aenean pretium dui libero, nec iaculis sem convallis ut. Donec nibh tellus, accumsan sed odio quis, mattis ultrices purus. Nunc a lorem urna. Etiam rhoncus mauris in elit sollicitudin, ut tincidunt nunc lacinia. Maecenas mollis sagittis velit quis faucibus. Etiam et sem eu enim malesuada congue quis non turpis. Ut eget enim quis ante vulputate pulvinar volutpat ut ipsum. Nunc dapibus nibh dui, ultrices imperdiet risus facilisis a. Praesent ut nisi quis orci faucibus malesuada. Nam luctus consectetur posuere. Praesent mollis in erat ac cursus. Donec sit amet nulla rutrum leo euismod porta. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Phasellus vel lacus faucibus, efficitur nisl ac, posuere justo. Nullam quis consequat turpis. Cras laoreet magna at odio interdum, ac interdum libero gravida. Duis eget vestibulum ex. Vestibulum fermentum commodo ipsum. Maecenas bibendum, libero dictum posuere ornare, orci ante gravida ligula, a maximus urna tortor porta turpis. Donec laoreet porta diam, et molestie dui interdum a. Aliquam erat volutpat. Sed sed pretium orci. Aenean arcu ipsum, semper tempus varius vel, ultrices sit amet ex. Mauris semper eleifend erat eu placerat. Morbi ornare augue nec tempor varius. Nam mattis dolor nulla, sit amet finibus metus consectetur imperdiet. Nunc tincidunt, urna pulvinar mollis egestas, velit neque blandit enim, ut porta lectus mi quis erat. Donec ultricies in arcu ac finibus. Fusce in dui ligula.
        """
        case repeating
        case custom
    }
    
    @State private var textPreset: TextPreset = .loremIpsum
    @State private var customText: String = "Edit me!"
    @State private var font: String = "SFPro-Black"
    @State private var degrees: Double = 350
    @State private var colors: [Color] = [.yellow, .purple, .blue]
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
    }
}

#Preview {
    ContentView()
}
