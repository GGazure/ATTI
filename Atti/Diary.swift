//
//  Diary.swift
//  Atti
//
//  Created by 장선영 on 2021/09/29.
//

import Foundation

struct Diary: Codable {
    let id: Int
    let rank: Int
    let name: String
    let cardImageURL : String
//    let promotionDetail: PromotionDetail
//    let isSelected: Bool?
}

//struct PromotionDetail: Codable {
//    let companyName: String
//    let period: String
//    let amount: Int
//    let condition: String
//    let benefitCondition: String
//    let benefitDetail: String
//    let benefitDate: String
//}
