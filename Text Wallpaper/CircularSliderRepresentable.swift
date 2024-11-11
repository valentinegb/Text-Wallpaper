//
//  CircularSliderView.swift
//  Glyph Wallpaper Generator
//
//  Created by Valentine Briese on 2024-11-08.
//

import SwiftUI

struct CircularSliderRepresentable: NSViewRepresentable {
    @Binding var value: Double
    var minValue: Double?
    var maxValue: Double?
    
    class Coordinator {
        var representable: CircularSliderRepresentable
        
        init(representable: CircularSliderRepresentable) {
            self.representable = representable
        }
        
        @objc func valueChanged(_ sender: NSSlider) {
            representable.value = sender.doubleValue
        }
    }
    
    func makeNSView(context: Context) -> NSSlider {
        let nsView = NSSlider(target: context.coordinator, action: #selector(Coordinator.valueChanged))
        
        nsView.sliderType = .circular
        
        if let minValue { nsView.minValue = minValue }
        if let maxValue { nsView.maxValue = maxValue }
        
        return nsView
    }
    
    func updateNSView(_ nsView: NSSlider, context: Context) {        
        if value != nsView.doubleValue {
            nsView.doubleValue = value
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(representable: self)
    }
}

#Preview {
    @Previewable @State var value = 0.0
    
    CircularSliderRepresentable(value: $value)
}
