import SwiftUI

struct CustomizeView: View {
    @Environment(\.dismiss) private var dismiss
    
    // TODO: Make view dynamic in that it know how many attributes that can be coloured on the object
    @State private var corkColor: Color = .white
    @State private var bottleColor: Color = .white
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack {
                        ColorPicker(selection: $corkColor) {
                            Text("Cork Colour")
                        }
                        
                        ColorPicker(selection: $bottleColor) {
                            Text("Bottle Colour")
                        }
                    }
                    .padding()
                    .frame(maxWidth: 1000)
                }
                
                Button {
                    // Apply changes
                } label: {
                    Text("Apply")
                        .padding()
                }
                .padding()
            }
            .navigationTitle("Customise")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Close")
                    }
                }
            }
        }
        .glassBackgroundEffect()
    }
}

#Preview {
    CustomizeView()
}
