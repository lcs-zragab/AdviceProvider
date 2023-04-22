//
//  SharedFunctionsAndConstants.swift
//  AdviceProvider
//
//  Created by Zaid Ragab on 2023-04-21.
//

import Foundation

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}

let savedFavouritesLabel = "savedFavourites"
