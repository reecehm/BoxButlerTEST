//
//  EditPersonView.swift
//  BoxButler
//
//  Created by 64014784 on 2/29/24.
//
import PhotosUI
import SwiftData
import SwiftUI

struct EditItemView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var item: Item
    @Query var boxes: [Box]
    
    @State private var selectedItem: PhotosPickerItem?
    @Binding var isShowingAddLocationSheet: Bool
    @Binding var shouldShowPlus: Bool
    @Query var changes: [Change]
    

    var body: some View {
        
        Form {
            Section{
                if let imageData = item.photo, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                }
                
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    Label("Select a photo",systemImage: "camera.on.rectangle")
                }
            }
            
            Section {
                TextField("Item Name", text: $item.itemName)
                TextField("Quantity", text: $item.quantity)
                    .keyboardType(.numberPad)
                TextField("Price", value: $item.price, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    .keyboardType(.numberPad)
            }
            Section("Quantity Warning Threshold"){
                
                TextField("Min Level", text:$item.quantityWarn)
                    .keyboardType(.numberPad)
            }
            Section{
                HStack{
                    Button{
                        isShowingAddLocationSheet = true
                    } label: {
                        Text("Edit Location Tags")
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                ForEach(item.location) { tag in
                    HStack{
                        Text(tag.name)
                            .foregroundColor(Color.white)
                            .fixedSize(horizontal: false, vertical: true)
                            .multilineTextAlignment(.center)
                            .padding()
                            .frame(height: 27)
                            .background(Rectangle().fill(Color(.red))
                                .opacity(0.8))
                            .cornerRadius(10)
                        Spacer()
                    }
                }
            }
            
            Section("Notes"){
                TextField("Details about this Item", text: $item.itemDetails, axis: .vertical)
            }
        }
        .onChange(of: selectedItem, loadPhoto)
        .onAppear{
            shouldShowPlus = true
                itemStruct.originalItem.itemName = item.itemName
                itemStruct.originalItem.quantity = item.quantity
                itemStruct.originalItem.itemDetails = item.itemDetails
                itemStruct.originalItem.location = item.location
                itemStruct.originalItem.quantityWarn = item.quantityWarn
        }
        .onDisappear{
            if item.itemName != itemStruct.originalItem.itemName && !itemStruct.originalItem.itemName.isEmpty {
                let change = Change(changeType: "Item Name", originalVar: itemStruct.originalItem.itemName, newVar: item.itemName)
                    modelContext.insert(change)
                 }
            if item.quantity != itemStruct.originalItem.quantity && !itemStruct.originalItem.quantity.isEmpty{
                let change = Change(changeType: "Quantity", originalVar: itemStruct.originalItem.quantity, newVar: item.quantity)
                    modelContext.insert(change)
                 }
            if item.price != itemStruct.originalItem.price && !itemStruct.originalItem.price.isNaN{
            let change = Change(changeType: "Price", originalVar: String(format: "%.2f", itemStruct.originalItem.price as CVarArg), newVar: String(format: "%.2f", item.price as CVarArg))
                    modelContext.insert(change)
                 }
            if item.itemDetails != itemStruct.originalItem.itemDetails && !itemStruct.originalItem.itemDetails.isEmpty {
                let change = Change(changeType: "Item Details", originalVar: itemStruct.originalItem.itemDetails, newVar: item.itemDetails)
                    modelContext.insert(change)
                 }
//            if item.location != itemStruct.originalItem.location && !itemStruct.originalItem.location.isEmpty{
//                let change = Change(changeType: "Location", originalVar: itemStruct.originalItem.location[0].name, newVar: item.location[0].name)
//                    modelContext.insert(change)
//                 }
            if item.quantityWarn != itemStruct.originalItem.quantityWarn && !itemStruct.originalItem.quantityWarn.isEmpty{
                let change = Change(changeType: "Quantity Warn", originalVar: itemStruct.originalItem.quantityWarn, newVar: item.quantityWarn)
                    modelContext.insert(change)
                 }
            if item.photo != itemStruct.originalItem.photo {
                let change = Change(changeType: "Photo", originalVar: itemStruct.originalItem.itemName, newVar: item.itemName)
                    modelContext.insert(change)
                 }
             
        }
    }
        
    
    
    
    
    
    func loadPhoto () {
        Task { @MainActor in
            item.photo = try await
            selectedItem?.loadTransferable(type: Data.self)
        }
    }
    
}



//#Preview {
//    EditPersonView()
//}
