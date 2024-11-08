//
//  ContentView.swift
//  Glyph Wallpaper Generator
//
//  Created by Valentine Briese on 2024-11-04.
//

import SwiftUI

struct ContentView: View {
    @State private var backgroundColor = Color.black
    @State private var fileExporterIsPresented = false
    @State private var image: Data?
    @State private var fileExporterErrorAlertIsPresented = false
    @State private var fileExporterErrorDescription: String?
    @State private var font = "IBMPlexMono-Bold"

    var body: some View {
        let wallpaper = Rectangle()
            .foregroundStyle(backgroundColor)
            .overlay(content: {
                Text("Placeholder").font(.custom(font, size: 13))
            })
            .aspectRatio(16 / 9, contentMode: .fit)
        
        VStack {
            wallpaper
                .clipShape(.rect(cornerRadius: 10))
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(.separator, lineWidth: 2)
                }
            Form {
                Section {
                    Picker("Font", systemImage: "textformat", selection: $font) {
                        ForEach(NSFontManager.shared.availableFonts, id: \.self) { name in
                            Text(name).font(.custom(name, size: 13))
                        }
                    }
                }
                Section {
                    ColorPicker("Background Color", selection: $backgroundColor, supportsOpacity: false)
                }
            }
            .formStyle(.grouped)
            Button("Generate") {
                let renderer = ImageRenderer(content: wallpaper.frame(width: 3840, height: 2160))
                
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
                defaultFilename: "Glyph Wallpaper.png"
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
