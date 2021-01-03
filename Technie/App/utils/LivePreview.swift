//
//  LivePreview.swift
//  Technie
//
//  Created by Valter A. Machado on 12/18/20.
//

//#if DEBUG
import UIKit
import SwiftUI

// Previews extension for UIView
extension UIView {
    
    var liveView: some View {
        LiveView(view: self)
    }
    
    struct LiveView<V: UIView>: UIViewRepresentable{
        let view: V
        
        func makeUIView(context: UIViewRepresentableContext<LiveView<V>>) -> V {
            return view
        }
        
        func updateUIView(_ uiView: V, context: UIViewRepresentableContext<LiveView<V>>) {
            print("updateUIView")
        }
    }
}

// Previews extension for UIViewController
extension UIViewController {
    
    var liveViewController: some View {
        LiveView(viewController: self)
    }
    
    struct LiveView<VC: UIViewController>: UIViewControllerRepresentable{
        typealias UIViewControllerType = VC
        
        let viewController: VC
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<LiveView<VC>>) -> VC {
            return viewController
        }
        
        func updateUIViewController(_ uiView: VC, context: UIViewControllerRepresentableContext<LiveView<VC>>) {
            print("updateUIView")
        }
    }
}

//#endif
