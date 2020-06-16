//
//  PKGeometry.swift
//  PhysicsKit
//
//  Created by Adam Eisfeld on 2020-06-16.
//  Copyright © 2020 adameisfeld. All rights reserved.
//

import Foundation
import SceneKit

public class PKGeometry {
    
    public let internalGeometry: PKBGeometry
    
    public init(scnGeometry: SCNGeometry) {
        internalGeometry = PKGeometry.getGeometry(scnGeometry)
    }
    
    private static func getGeometry(_ scnGeometry: SCNGeometry) -> PKBGeometry {
        let vertexPositions = Self.getVertexPositions(scnGeometry)
        var meshs: [PKBMesh] = []
        
        for scnGeometryElement in scnGeometry.elements {
            let polygons = Self.getPolygons(scnGeometryElement, vertexPositions: vertexPositions)
            let mesh = PKBMesh(polygons: polygons)
            meshs.append(mesh)
        }
        
        let internalGeometry = PKBGeometry(meshs: meshs)
        return internalGeometry
    }
    
    private static func getPolygons(_ scnGeometryElement: SCNGeometryElement, vertexPositions: [NSValue]) -> [PKBPolygon] {
    
        var polygons: [PKBPolygon] = []
        
        switch scnGeometryElement.primitiveType {
        case .polygon:
            // First we need to extract how many vertices each polygon has
            
            var polygonVertexCounts: [Int] = []
            
            var totalVertices: Int = 0
            for i in stride(from: 0, to: scnGeometryElement.primitiveCount * scnGeometryElement.bytesPerIndex, by: scnGeometryElement.bytesPerIndex) {
                let range: Range<Data.Index> = i..<(i + scnGeometryElement.bytesPerIndex)
                var totalVerticesForPolygon: Int = 0
                let _ = withUnsafeMutableBytes(of: &totalVerticesForPolygon, { scnGeometryElement.data.copyBytes(to: $0, from: range)} )
                totalVertices += totalVerticesForPolygon
                polygonVertexCounts.append(totalVerticesForPolygon)
            }
            
            // Now we need to iterate over each polygon's vertices, turning them into triangles
            
            let vertexDataStart = scnGeometryElement.primitiveCount * scnGeometryElement.bytesPerIndex
            var vertexDataOffset: Int = 0
            
            for polygonVertexCount in polygonVertexCounts {
                
                var vertices: [PKBVertex] = []
                
                for _ in 0..<polygonVertexCount {
                    
                    let start = vertexDataStart + vertexDataOffset
                    let end = start + scnGeometryElement.bytesPerIndex
                    let range: Range<Data.Index> = start..<end
                    var vertexIndex: Int = 0
                    let _ = withUnsafeMutableBytes(of: &vertexIndex, { scnGeometryElement.data.copyBytes(to: $0, from: range)} )
                    vertexDataOffset += scnGeometryElement.bytesPerIndex
                    
                    let vertexPosition = vertexPositions[vertexIndex]
                    let vertex = PKBVertex(position: vertexPosition.pkVector3Value)
                    
                    vertices.append(vertex)
                    
                }
                
                let polygon = PKBPolygon(vertices: vertices)
                polygons.append(polygon)
                
            }
        case .triangles:
            
            var vIndex: Int = 0
            for _: Int in 0..<scnGeometryElement.primitiveCount {

                let range1: Range<Data.Index> = vIndex..<(vIndex + scnGeometryElement.bytesPerIndex)
                var v1: Int = 0
                vIndex += scnGeometryElement.bytesPerIndex
                let _ = withUnsafeMutableBytes(of: &v1, { scnGeometryElement.data.copyBytes(to: $0, from: range1)} )

                let range2: Range<Data.Index> = vIndex..<(vIndex + scnGeometryElement.bytesPerIndex)
                var v2: Int = 0
                vIndex += scnGeometryElement.bytesPerIndex
                let _ = withUnsafeMutableBytes(of: &v2, { scnGeometryElement.data.copyBytes(to: $0, from: range2)} )

                let range3: Range<Data.Index> = vIndex..<(vIndex + scnGeometryElement.bytesPerIndex)
                var v3: Int = 0
                vIndex += scnGeometryElement.bytesPerIndex
                let _ = withUnsafeMutableBytes(of: &v3, { scnGeometryElement.data.copyBytes(to: $0, from: range3)} )

                let vertexPosition1 = vertexPositions[v1]
                let vertex1 = PKBVertex(position: vertexPosition1.pkVector3Value)
                
                let vertexPosition2 = vertexPositions[v2]
                let vertex2 = PKBVertex(position: vertexPosition2.pkVector3Value)
                
                let vertexPosition3 = vertexPositions[v3]
                let vertex3 = PKBVertex(position: vertexPosition3.pkVector3Value)
                
                let polygon = PKBPolygon(vertices: [vertex1, vertex2, vertex3])
                
                polygons.append(polygon)

            }

        default:
            break
        }
        
        return polygons

    }
        
    private static func getVertexPositions(_ geometry: SCNGeometry) -> [NSValue] {
        let sources = geometry.sources(for: .vertex)

        guard let source  = sources.first else { return [] }

        let stride = source.dataStride / source.bytesPerComponent
        let offset = source.dataOffset / source.bytesPerComponent
        let vectorCount = source.vectorCount

        return source.data.withUnsafeBytes { (buffer : UnsafePointer<Float>) -> [NSValue] in

            var result = Array<NSValue>()
            for i in 0...vectorCount - 1 {
                let start = i * stride + offset
                let x = buffer[start]
                let y = buffer[start + 1]
                let z = buffer[start + 2]
                result.append(NSValue(pkVector3: PKVector3(x, y, z)))
            }
            return result
        }
    }
    
}
