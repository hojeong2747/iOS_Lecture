//
//  TaskDto.swift
//  MyApp
//
//  Created by cs_mac on 2020/07/22.
//  Copyright © 2020 cs_mac. All rights reserved.
//

import Foundation

class TaskDto {
    var id: Optional<Int>
    var title: String?
    var date: Int32
    var detail: String?
    var icon: String?

    init(id: Optional<Int>, title: String, date: Int32, detail: String, icon: String) {
        self.id = id
        self.title = title
        self.date = date
        self.detail = detail
        self.icon = icon
    }

}


