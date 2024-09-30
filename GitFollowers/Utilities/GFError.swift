//
//  GFError.swift
//  GitFollowers
//
//  Created by Matheus Henrique on 18/03/24.
//


import Foundation

enum GFError: String, Error {
    case invalidUsername = "This username created a invalid request. Please try again."
    case unableToComplete = "Unable to complete your request. Please check your internet connection."
    case invalidResponse = "Invalid responde from the server. Please try again."
    case invalidData = "The data received from the server was invalid. Please try again."
    case unableToFavorite = "There was an error favoriting this user. Please try again."
    case alreadyInFavorites = "You've already favorite this user."
}
