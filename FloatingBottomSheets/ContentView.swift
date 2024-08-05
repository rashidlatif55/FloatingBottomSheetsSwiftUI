//
//  ContentView.swift
//  FloatingBottomSheets
//
//  Created by Rashid Latif on 05/08/2024.
//
import SwiftUI

#Preview {
    ContentView()
}

struct ContentView: View {
    
    @State private var presentSheet:Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                Button("Present Sheet") {
                    self.presentSheet.toggle()
                }
            }
            .floatingBottomSheet(isPresenting: $presentSheet) {
                SheetView(
                    title: "Facing Issues or Need Support?",
                    description: "Please feel free to reach out to us using email ID provided if you require any assistance or facing any issues while using App",
                    image: .init(
                        content: "error.icon",
                        tint: .clear,
                        foreground: .white
                    ),
                    button1: .init(
                        content: "Contact Us",
                        tint: .blue,
                        foreground: .white
                    ),
                    button2: .init(
                        content: "Cancel",
                        tint: .primary.opacity(
                            0.08
                        ),
                        foreground: .primary
                    )
                ) // sheet end
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                .presentationDetents([.height(400), .fraction(0.999)])
                .presentationBackgroundInteraction(.enabled(upThrough: .height(400)))
            }
        }
    }
}

struct SheetView: View {
    
    var title:String
    var description:String
    var image:configuration
    var button1:configuration
    var button2:configuration?
    
    struct configuration{
        var content:String
        var tint:Color
        var foreground:Color
    }
    
    var body: some View {
        VStack(spacing: 15) {
            Image(self.image.content)
                .resizable()
                .font(.title2)
                .foregroundStyle(self.image.foreground)
                .frame(width: 65, height: 65)
                .background(image.tint.gradient, in: .circle)
            
            Text(self.title)
                .font(.title3.bold())
            
            Text(self.description)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundStyle(.primary.opacity(0.5))
            
            ButtonView(self.button1)
            
            if let button2 = self.button2 {
                ButtonView(button2)
            }
        }
        .padding([.horizontal, .bottom], 15)
        .background {
            RoundedRectangle(cornerRadius: 15)
                .fill(.background)
                .padding(.top, 30)
        }
        .shadow(color: .black.opacity(0.12), radius: 8)
        .padding(.horizontal, 15)
    }
    
    @ViewBuilder
    func ButtonView(_ config:configuration) -> some View {
        Button {
            
            
        } label: {
            Text(config.content)
                .foregroundStyle(config.foreground)
                .fontWeight(.bold)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(config.tint.gradient, in: .rect(cornerRadius: 10))
        }
    }
}


extension View {
    @ViewBuilder
    func floatingBottomSheet<Content:View>(isPresenting: Binding<Bool>, onDismiss: @escaping () -> () = {}, @ViewBuilder content: @escaping () -> Content) -> some View {
        self
            .sheet(isPresented: isPresenting,onDismiss: onDismiss) {
                content()
                    .presentationCornerRadius(0)
                    .presentationBackground(.clear)
                    .presentationDragIndicator(.hidden)
                    .background(SheetShadowRemover())
                    
            }
    }
}

struct SheetShadowRemover: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.06) {
            if let uiSheetView = view.viewBeforeWidow {
                for view in uiSheetView.subviews {
                    view.layer.shadowColor = UIColor.clear.cgColor
                }
            }
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
    
}

extension UIView {
    var viewBeforeWidow: UIView? {
        if let superview, superview is UIWindow {
            return self
        }
        
        return superview?.viewBeforeWidow
    }
}
