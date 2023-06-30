//
//  ItemDto.swift
//  TableViewTest
//
//  Created by Dongduk1 on 2023/06/30.
//

import Foundation

class ItemDto {
    var item: String?
    var imageFile: String?
    
    init(_ newItem: String, _ newImage: String) {
        item = newItem
        imageFile = newImage
    }
}
