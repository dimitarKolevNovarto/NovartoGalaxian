//
//  Levels.swift
//  NovartoGalaxian
//
//  Created by Dimitar Kolev on 10/19/17.
//  Copyright © 2017 Dimitar Kolev. All rights reserved.
//

import Foundation
import SpriteKit
class Level{
    var invaders: [AlienInvader] = []
    var levelNumber: Int = 0
    init(levelNumber: Int, startingPoint: CGPoint){
        self.levelNumber = levelNumber
        var invaderRowCount: Int = 0
        var invaderColCount: Int = 0
        var invaderGridSpacing: CGSize = CGSize(width: 12, height: 12)
        switch levelNumber{
        case 1:
            invaderRowCount = 3
            invaderColCount = 6
            invaderGridSpacing = CGSize(width: 12, height: 36)
            let baseOrigin = startingPoint
            let defaultInvaderSize = CGSize(width: 24, height: 16)
            for row in 0..<invaderRowCount {
                let invaderType: InvaderType = .a
                let invaderPositionY = CGFloat(row) * (defaultInvaderSize.height + invaderGridSpacing.height) + baseOrigin.y
                var invaderPosition = CGPoint(x: baseOrigin.x, y: invaderPositionY)
                for col in 0..<invaderColCount {
                    if invaderType == .b{
                        if col == 0 || col == invaderColCount - 1{
                            invaderPosition = CGPoint(
                                x: invaderPosition.x + defaultInvaderSize.width + invaderGridSpacing.width,
                                y: invaderPositionY
                            )
                            continue
                        }
                    }
                    if invaderType == .c{
                        if (col == 0 || col == 1 || col == invaderColCount - 1 || col == invaderColCount - 2) {
                            invaderPosition = CGPoint(
                                x: invaderPosition.x + defaultInvaderSize.width + invaderGridSpacing.width,
                                y: invaderPositionY
                            )
                            continue
                        }
                    }
                    let invader = AlienInvader(type: invaderType)
                    invader.position = invaderPosition
                    invader.initialPosition = invader.position
                    invaders.append(invader)
                    invaderPosition = CGPoint(
                        x: invaderPosition.x + defaultInvaderSize.width + invaderGridSpacing.width,
                        y: invaderPositionY
                    )
                }
            }
        case 2:
            invaderRowCount = 3
            invaderColCount = 6
            invaderGridSpacing = CGSize(width: 12, height: 36)
            
            let baseOrigin = startingPoint
            let defaultInvaderSize = CGSize(width: 24, height: 16)
            for row in 0..<invaderRowCount {
                let invaderType: InvaderType
                if row == 2{
                    invaderType = .b
                }
                else{
                    invaderType = .a
                }
                let invaderPositionY = CGFloat(row) * (defaultInvaderSize.height + invaderGridSpacing.height) + baseOrigin.y
                var invaderPosition = CGPoint(x: baseOrigin.x, y: invaderPositionY)
                for col in 0..<invaderColCount {
                    if invaderType == .b{
                        if col == 0 || col == invaderColCount - 1{
                            invaderPosition = CGPoint(
                                x: invaderPosition.x + defaultInvaderSize.width + invaderGridSpacing.width,
                                y: invaderPositionY
                            )
                            continue
                        }
                    }
                    if invaderType == .c{
                        if (col == 0 || col == 1 || col == invaderColCount - 1 || col == invaderColCount - 2){
                            invaderPosition = CGPoint(
                                x: invaderPosition.x + defaultInvaderSize.width + invaderGridSpacing.width,
                                y: invaderPositionY
                            )
                            continue
                        }
                    }
                    let invader = AlienInvader(type: invaderType)
                    invader.position = invaderPosition
                    invader.initialPosition = invader.position
                    invaders.append(invader)
                    invaderPosition = CGPoint(
                        x: invaderPosition.x + defaultInvaderSize.width + invaderGridSpacing.width,
                        y: invaderPositionY
                    )
                }
            }
        case 3:
            invaderRowCount = 4
            invaderColCount = 6
            invaderGridSpacing = CGSize(width: 12, height: 16)
            let baseOrigin = startingPoint
            let defaultInvaderSize = CGSize(width: 24, height: 16)
            for row in 0..<invaderRowCount {
                let invaderType: InvaderType
                if row == 2{
                    invaderType = .b
                }
                else if row == 3{
                    invaderType = .c
                }
                else{
                    invaderType = .a
                }
                let invaderPositionY = CGFloat(row) * (defaultInvaderSize.height + invaderGridSpacing.height) + baseOrigin.y
                var invaderPosition = CGPoint(x: baseOrigin.x, y: invaderPositionY)
                for col in 0..<invaderColCount {
                    if invaderType == .b{
                        if col == 0 || col == invaderColCount - 1{
                            invaderPosition = CGPoint(
                                x: invaderPosition.x + defaultInvaderSize.width + invaderGridSpacing.width,
                                y: invaderPositionY
                            )
                            continue
                        }
                    }
                    if invaderType == .c{
                        if (col == 0 || col == 1 || col == invaderColCount - 1 || col == invaderColCount - 2){
                            invaderPosition = CGPoint(
                                x: invaderPosition.x + defaultInvaderSize.width + invaderGridSpacing.width,
                                y: invaderPositionY
                            )
                            continue
                        }
                    }
                    let invader = AlienInvader(type: invaderType)
                    invader.position = invaderPosition
                    invader.initialPosition = invader.position
                    invaders.append(invader)
                    invaderPosition = CGPoint(
                        x: invaderPosition.x + defaultInvaderSize.width + invaderGridSpacing.width,
                        y: invaderPositionY
                    )
                }
            }
        case 4:
            invaderRowCount = 3
            invaderColCount = 6
            invaderGridSpacing = CGSize(width: 12, height: 24)
            let baseOrigin = startingPoint
            let defaultInvaderSize = CGSize(width: 24, height: 16)
            for row in 0..<invaderRowCount {
                let invaderType: InvaderType = .b
                let invaderPositionY = CGFloat(row) * (defaultInvaderSize.height + invaderGridSpacing.height) + baseOrigin.y
                var invaderPosition = CGPoint(x: baseOrigin.x, y: invaderPositionY)
                for col in 0..<invaderColCount {
                    if invaderType == .b{
                        if col == 0 || col == invaderColCount - 1{
                            invaderPosition = CGPoint(
                                x: invaderPosition.x + defaultInvaderSize.width + invaderGridSpacing.width,
                                y: invaderPositionY
                            )
                            continue
                        }
                    }
                    if invaderType == .c{
                        if (col == 0 || col == 1 || col == invaderColCount - 1 || col == invaderColCount - 2){
                            invaderPosition = CGPoint(
                                x: invaderPosition.x + defaultInvaderSize.width + invaderGridSpacing.width,
                                y: invaderPositionY
                            )
                            continue
                        }
                    }
                    let invader = AlienInvader(type: invaderType)
                    invader.position = invaderPosition
                    invader.initialPosition = invader.position
                    invaders.append(invader)
                    invaderPosition = CGPoint(
                        x: invaderPosition.x + defaultInvaderSize.width + invaderGridSpacing.width,
                        y: invaderPositionY
                    )
                }
            }
        case 5:
            invaderRowCount = 3
            invaderColCount = 8
            invaderGridSpacing = CGSize(width: 12, height: 24)
            let baseOrigin = startingPoint
            let defaultInvaderSize = CGSize(width: 24, height: 16)
            for row in 0..<invaderRowCount {
                let invaderType: InvaderType = .c
                let invaderPositionY = CGFloat(row) * (defaultInvaderSize.height + invaderGridSpacing.height) + baseOrigin.y
                var invaderPosition = CGPoint(x: baseOrigin.x, y: invaderPositionY)
                for col in 0..<invaderColCount {
                    if invaderType == .b{
                        if col == 0 || col == invaderColCount - 1{
                            invaderPosition = CGPoint(
                                x: invaderPosition.x + defaultInvaderSize.width + invaderGridSpacing.width,
                                y: invaderPositionY
                            )
                            continue
                        }
                    }
                    if invaderType == .c{
                        if (col == 0 || col == 1 || col == invaderColCount - 1 || col == invaderColCount - 2){
                            invaderPosition = CGPoint(
                                x: invaderPosition.x + defaultInvaderSize.width + invaderGridSpacing.width,
                                y: invaderPositionY
                            )
                            continue
                        }
                    }
                    let invader = AlienInvader(type: invaderType)
                    invader.position = invaderPosition
                    invader.initialPosition = invader.position
                    invaders.append(invader)
                    invaderPosition = CGPoint(
                        x: invaderPosition.x + defaultInvaderSize.width + invaderGridSpacing.width,
                        y: invaderPositionY
                    )
                }
            }
        case 6:
            invaderRowCount = 6
            invaderColCount = 8
            invaderGridSpacing = CGSize(width: 12, height: 12)
            let baseOrigin = startingPoint
            let defaultInvaderSize = CGSize(width: 24, height: 16)
            for row in 0..<invaderRowCount {
                let invaderType: InvaderType = .a
                let invaderPositionY = CGFloat(row) * (defaultInvaderSize.height + invaderGridSpacing.height) + baseOrigin.y
                var invaderPosition = CGPoint(x: baseOrigin.x, y: invaderPositionY)
                for col in 0..<invaderColCount {
                    if invaderType == .b{
                        if col == 0 || col == invaderColCount - 1{
                            invaderPosition = CGPoint(
                                x: invaderPosition.x + defaultInvaderSize.width + invaderGridSpacing.width,
                                y: invaderPositionY
                            )
                            continue
                        }
                    }
                    if invaderType == .c{
                        if (col == 0 || col == 1 || col == invaderColCount - 1 || col == invaderColCount - 2){
                            invaderPosition = CGPoint(
                                x: invaderPosition.x + defaultInvaderSize.width + invaderGridSpacing.width,
                                y: invaderPositionY
                            )
                            continue
                        }
                    }
                    let invader = AlienInvader(type: invaderType)
                    invader.position = invaderPosition
                    invader.initialPosition = invader.position
                    invaders.append(invader)
                    invaderPosition = CGPoint(
                        x: invaderPosition.x + defaultInvaderSize.width + invaderGridSpacing.width,
                        y: invaderPositionY
                    )
                }
            }
        case 7:
            invaderRowCount = 6
            invaderColCount = 8
            invaderGridSpacing = CGSize(width: 12, height: 12)
            let baseOrigin = startingPoint
            let defaultInvaderSize = CGSize(width: 24, height: 16)
            for row in 0..<invaderRowCount {
                let invaderType: InvaderType
                if row == 3 || row == 4{
                    invaderType = .b
                }
                else if row == 5{
                    invaderType = .c
                }
                else{
                    invaderType = .a
                }
                let invaderPositionY = CGFloat(row) * (defaultInvaderSize.height + invaderGridSpacing.height) + baseOrigin.y
                var invaderPosition = CGPoint(x: baseOrigin.x, y: invaderPositionY)
                for col in 0..<invaderColCount {
                    if invaderType == .b{
                        if col == 0 || col == invaderColCount - 1{
                            invaderPosition = CGPoint(
                                x: invaderPosition.x + defaultInvaderSize.width + invaderGridSpacing.width,
                                y: invaderPositionY
                            )
                            continue
                        }
                    }
                    if invaderType == .c{
                        if (col == 0 || col == 1 || col == invaderColCount - 1 || col == invaderColCount - 2){
                            invaderPosition = CGPoint(
                                x: invaderPosition.x + defaultInvaderSize.width + invaderGridSpacing.width,
                                y: invaderPositionY
                            )
                            continue
                        }
                    }
                    let invader = AlienInvader(type: invaderType)
                    invader.position = invaderPosition
                    invader.initialPosition = invader.position
                    invaders.append(invader)
                    invaderPosition = CGPoint(
                        x: invaderPosition.x + defaultInvaderSize.width + invaderGridSpacing.width,
                        y: invaderPositionY
                    )
                }
            }
        case 8:
            invaderRowCount = 7
            invaderColCount = 10
            invaderGridSpacing = CGSize(width: 12, height: 12)
            let baseOrigin = startingPoint
            let defaultInvaderSize = CGSize(width: 24, height: 16)
            for row in 0..<invaderRowCount {
                let invaderType: InvaderType
                if row == 3 || row == 4{
                    invaderType = .b
                }
                else if row == 5 || row == 6{
                    invaderType = .c
                }
                else{
                    invaderType = .a
                }
                let invaderPositionY = CGFloat(row) * (defaultInvaderSize.height + invaderGridSpacing.height) + baseOrigin.y
                var invaderPosition = CGPoint(x: baseOrigin.x, y: invaderPositionY)
                for col in 0..<invaderColCount {
                    if invaderType == .b{
                        if col == 0 || col == invaderColCount - 1{
                            invaderPosition = CGPoint(
                                x: invaderPosition.x + defaultInvaderSize.width + invaderGridSpacing.width,
                                y: invaderPositionY
                            )
                            continue
                        }
                    }
                    if invaderType == .c{
                        if (col == 0 || col == 1 || col == invaderColCount - 1 || col == invaderColCount - 2){
                            invaderPosition = CGPoint(
                                x: invaderPosition.x + defaultInvaderSize.width + invaderGridSpacing.width,
                                y: invaderPositionY
                            )
                            continue
                        }
                    }
                    let invader = AlienInvader(type: invaderType)
                    invader.position = invaderPosition
                    invader.initialPosition = invader.position
                    invaders.append(invader)
                    invaderPosition = CGPoint(
                        x: invaderPosition.x + defaultInvaderSize.width + invaderGridSpacing.width,
                        y: invaderPositionY
                    )
                }
            }
        default:
            break
        }
    }
}
