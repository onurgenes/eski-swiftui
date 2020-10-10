//
//  TextView.swift
//  eskiclient
//
//  Created by Onur Geneş on 10.10.2020.
//

import SwiftUI

struct TextView: View {
    var text: NSAttributedString
    
    @State private var height: CGFloat = .zero
    @Binding private var clickedLink: ClickedLink?
    
    init(text: NSAttributedString, clickedLink: Binding<ClickedLink?>) {
        self._clickedLink = clickedLink
        self.text = text
    }
    
    var body: some View {
        InternalTextView(text: text, dynamicHeight: $height, clickedLink: $clickedLink)
            .frame(minHeight: height)
    }
    
    struct InternalTextView: UIViewRepresentable {
        var text: NSAttributedString
        @Binding var dynamicHeight: CGFloat
        @Binding var clickedLink: ClickedLink?
        
        func makeUIView(context: Context) -> UITextView {
            let textView = UITextView()
            textView.dataDetectorTypes = [.link]
            textView.isEditable = false
            textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            textView.delegate = context.coordinator
            return textView
        }
        
        func updateUIView(_ uiView: UITextView, context: Context) {
            uiView.attributedText = text
            let traits = UITraitCollection(traitsFrom: [
                uiView.traitCollection
            ])
            uiView.font = UIFont.preferredFont(forTextStyle: .body, compatibleWith: traits)
            DispatchQueue.main.async {
                dynamicHeight = uiView.sizeThatFits(CGSize(width: uiView.bounds.width, height: CGFloat.greatestFiniteMagnitude)).height
            }
        }
        
        class Coordinator: NSObject, UITextViewDelegate {
            var parent: InternalTextView
            
            init(_ parent: InternalTextView) {
                self.parent = parent
            }
            
            func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
                parent.clickedLink = ClickedLink(url: URL, text: URL.absoluteString)
                return false
            }
        }
        
        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }
    }
}

