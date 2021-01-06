//
//  PHYGeometry.swift
//  PhyKit
//
//  Created by Adam Eisfeld on 2020-06-16.
//  Copyright © 2020 adameisfeld. All rights reserved.
//

import Foundation
import SceneKit

/// Geometry instances represent a relationship of vertices->polygons->meshs that build up a 3D model
public class PHYGeometry {
    
    /// The internal geometry to pass around objc land
    public let internalGeometry: CPHYGeometry
    
    
    /// Initialized a new geometry instance from the provided scenekit geometry.
    /// Currently PHYGeometry only supports geometry containing geometry elements with a primitiveType of either .polygon or .triangle.
    /// - Parameter scnGeometry: The scenekit geometry to construct this geometry from
    public init(scnGeometry: SCNGeometry) {
        internalGeometry = PHYGeometry.getGeometry(scnGeometry)
    }
    
    private static func getGeometry(_ scnGeometry: SCNGeometry) -> CPHYGeometry {
        let vertexPositions = Self.getVertexPositions(scnGeometry)
        
        var meshs: [CPHYMesh] = []
        
        for scnGeometryElement in scnGeometry.elements {
            let polygons = Self.getPolygons(scnGeometryElement, vertexPositions: vertexPositions)
            let mesh = CPHYMesh(polygons: polygons)
            meshs.append(mesh)
        }
        
        let internalGeometry = CPHYGeometry(meshs: meshs)
        return internalGeometry
    }
    
    private static func getPolygons(_ scnGeometryElement: SCNGeometryElement, vertexPositions: [PHYVector3]) -> [CPHYPolygon] {
    
        var polygons: [CPHYPolygon] = []
        
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
                
                var vertices: [CPHYVertex] = []
                
                for _ in 0..<polygonVertexCount {
                    
                    let start = vertexDataStart + vertexDataOffset
                    let end = start + scnGeometryElement.bytesPerIndex
                    let range: Range<Data.Index> = start..<end
                    var vertexIndex: Int = 0
                    let _ = withUnsafeMutableBytes(of: &vertexIndex, { scnGeometryElement.data.copyBytes(to: $0, from: range)} )
                    vertexDataOffset += scnGeometryElement.bytesPerIndex
                    
                    let vertexPosition = vertexPositions[vertexIndex]
                    let vertex = CPHYVertex(position: vertexPosition)
                    
                    vertices.append(vertex)
                    
                }
                
                let polygon = CPHYPolygon(vertices: vertices)
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
                let vertex1 = CPHYVertex(position: vertexPosition1)
                
                let vertexPosition2 = vertexPositions[v2]
                let vertex2 = CPHYVertex(position: vertexPosition2)
                
                let vertexPosition3 = vertexPositions[v3]
                let vertex3 = CPHYVertex(position: vertexPosition3)
                
                let polygon = CPHYPolygon(vertices: [vertex1, vertex2, vertex3])
                
                polygons.append(polygon)

            }

        default:
            break
        }
        
        return polygons

    }
    
    private static func getVertexPositions(_ geometry: SCNGeometry) -> [PHYVector3] {
        
        guard let source = geometry.sources(for: .vertex).first else {
            return []
        }
        
        let stride = source.dataStride
        let offset = source.dataOffset
        let componentsPerVector = source.componentsPerVector
        let bytesPerVector = componentsPerVector * source.bytesPerComponent
        let vectors = [SCNVector3](repeating: SCNVector3Zero, count: source.vectorCount)
        let vertices = vectors.enumerated().map({ (index: Int, element: SCNVector3) -> PHYVector3 in

            let vectorData = UnsafeMutablePointer<Float>.allocate(capacity: componentsPerVector)
            let nsByteRange = NSMakeRange(index * stride + offset, bytesPerVector)
            let byteRange = Range(nsByteRange)

            let buffer = UnsafeMutableBufferPointer(start: vectorData, count: componentsPerVector)
            _ = source.data.copyBytes(to: buffer, from: byteRange)
            let vector = PHYVector3.vector(Float(buffer[0]), Float(buffer[1]), Float(buffer[2]))
            return vector
            
        })
        return vertices
        
    }
    
}
