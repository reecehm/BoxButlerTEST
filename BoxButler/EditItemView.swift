//
//  EditPersonView.swift
//  BoxButler
//
//  Created by 64014784 on 2/29/24.
//
import SwiftData
import SwiftUI

struct EditItemView: View {
    @Bindable var item: Item
    @Query var folders: [Folder]
    
    var body: some View {
        let numberFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .none
            formatter.zeroSymbol  = ""
            return formatter
        }()
        
        Form {
            Section {
                TextField("Item Name", text: $item.itemName)
                TextField("Quantity", text: $item.quantity)
                TextField("Price", value: $item.price, formatter: numberFormatter).keyboardType(.numbersAndPunctuation)
                Picker("Folder", selection: $item.folderName) {
                    ForEach(folders){ folder in
                        Text(folder.folderName)
                    }
                }
            }
            
            Section("Notes"){
                
            }

        }
        .navigationTitle("Edit Item")
        .navigationBarTitleDisplayMode(.inline)
        
    }
}

//#Preview {
//    EditPersonView()
//}
