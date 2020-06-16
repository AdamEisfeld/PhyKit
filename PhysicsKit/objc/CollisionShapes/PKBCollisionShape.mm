//
//  PKBCollisionShape.m
//  BulletPhysics
//
//  Created by Adam Eisfeld on 2020-06-12.
//  Copyright © 2020 adam. All rights reserved.
//

#import "PKBCollisionShape.h"
#import "PKBGeometry.h"
#import "PKBCollisionShape+Internal.h"
#import "PKBStructs.h"
#import "PKBStructs+Internal.h"
#import "PKBGeometry.h"
#import "PKBMesh.h"
#import "PKBPolygon.h"
#import "PKBVertex.h"
#import "PKBDependencies+Internal.h"

@implementation PKBCollisionShape

- (instancetype)init {
    self = [super init];
    if (self) {
        _c_shape = new btEmptyShape();
        _transform = PKMatrix4MakeIdentity();
    }
    return self;
}

- (instancetype)initWithSerializedData: (NSData *)serializedData {
    self = [super init];
    if (self) {

        int bufferSize = int([serializedData length] / sizeof(char));
        char* buffer = (char*) [serializedData bytes];
        btBulletWorldImporter *importer = new btBulletWorldImporter();
        importer->loadFileFromMemory(buffer, bufferSize);
        int numShape = importer->getNumCollisionShapes();
        if (numShape) {
            _c_shape = (btBvhTriangleMeshShape*)importer->getCollisionShapeByIndex(0);
        } else {
            _c_shape = new btEmptyShape();
        }

        _transform = PKMatrix4MakeIdentity();
    }
    return self;
}

- (instancetype)initSphereWithRadius: (float)radius transform: (struct PKMatrix4)transform {
    self = [super init];
    if (self) {
        _c_shape = new btSphereShape(radius);
        _transform = transform;
    }
    return self;
}

- (instancetype)initBoxWithWidth: (float)width height: (float)height length: (float)length transform: (struct PKMatrix4)transform {
    self = [super init];
    if (self) {
        _c_shape = new btBoxShape(btVector3(width / 2.0, height / 2.0, length / 2.0));
        _transform = transform;
    }
    return self;
}

- (instancetype)initCapsuleWithRadius:(float)radius height:(float)height transform:(struct PKMatrix4)transform {
    self = [super init];
    if (self) {
        _c_shape = new btCapsuleShape(radius, height - (2 * radius));
        _transform = transform;
    }
    return self;
}

- (instancetype)initStaticPlaneWithDirection:(struct PKVector3)direction transform:(struct PKMatrix4)transform {
    self = [super init];
    if (self) {
        btVector3 c_direction = btVector3(direction.x, direction.y, direction.z);
        _c_shape = new btStaticPlaneShape(c_direction, 0);
        _transform = transform;
    }
    return self;
}

- (instancetype)initWithBTCollisionShape: (btCollisionShape *)collisionShape transform: (struct PKMatrix4)transform {
    self = [super init];
    if (self) {
        _c_shape = collisionShape;
        _transform = transform;
    }
    return self;
}
                                      
- (instancetype)initWithCollisionShape:(PKBCollisionShape *)collisionShape transform:(struct PKMatrix4)transform {
    return [self initWithCollisionShapes:@[collisionShape] transform:transform];
}

- (instancetype)initWithCollisionShapes: (NSArray <PKBCollisionShape *>*)collisionShapes transform: (struct PKMatrix4)transform {
    self = [super init];
    if (self) {
        if (collisionShapes.count > 1) {
            btCompoundShape *c_compoundShape = new btCompoundShape();
            for (PKBCollisionShape *collisionShape in collisionShapes) {
                btTransform c_transform = btTransformMakeFrom(collisionShape.transform);
                c_compoundShape->addChildShape(c_transform, collisionShape.c_shape);
            }
            _c_shape = c_compoundShape;
        } else {
            PKBCollisionShape *collisionShape = collisionShapes.firstObject;
            _c_shape = collisionShape.c_shape;
        }

        _transform = transform;
    }
    return self;
}

- (instancetype)initConvexHullWithGeometry: (PKBGeometry *)geometry {
    self = [super init];
    if (self) {

         btCompoundShape *c_compoundShape = new btCompoundShape();
        
         for (PKBMesh *mesh in geometry.meshs) {
             
             btConvexHullShape *c_convexHull = new btConvexHullShape();
             
             for (PKBPolygon *polygon in mesh.polygons) {

                 for (PKBVertex *vertex in polygon.vertices) {

                     btVector3 c_vertexPosition = btVector3(vertex.position.x, vertex.position.y, vertex.position.z);
                     c_convexHull->addPoint(c_vertexPosition);

                 }

             }
             
             btTransform c_localTransform = btTransform();
             c_localTransform.setIdentity();
             c_compoundShape->addChildShape(c_localTransform, c_convexHull);
             
         }
         
         _c_shape = c_compoundShape;
        
    }
    return self;
}

- (instancetype)initTriangleMeshWithGeometry: (PKBGeometry *)geometry {
    self = [super init];
    if (self) {
        
        btTriangleMesh *c_mesh = new btTriangleMesh();
        
        for (PKBMesh *mesh in geometry.meshs) {
            
            for (PKBPolygon *polygon in mesh.polygons) {

                btVector3 c_vertexPosition1 = btVector3(polygon.vertices[0].position.x, polygon.vertices[0].position.y, polygon.vertices[0].position.z);
                btVector3 c_vertexPosition2 = btVector3(polygon.vertices[1].position.x, polygon.vertices[1].position.y, polygon.vertices[1].position.z);
                btVector3 c_vertexPosition3 = btVector3(polygon.vertices[2].position.x, polygon.vertices[2].position.y, polygon.vertices[2].position.z);
                
                c_mesh->addTriangle(c_vertexPosition1, c_vertexPosition2, c_vertexPosition3);

            }
            
        }

        _c_shape = new btBvhTriangleMeshShape(c_mesh, true);

    }
    return self;
}

- (NSData *)serialize {
    
    int maxSerializeBufferSize = 1024*1024*5;
    btDefaultSerializer*    serializer = new btDefaultSerializer(maxSerializeBufferSize);
    serializer->startSerialization();
    _c_shape->serializeSingleShape(serializer);
    serializer->finishSerialization();
    const unsigned char *bufferBytes = serializer->getBufferPointer();
    int bufferSize = serializer->getCurrentBufferSize();
    NSData *data = [NSData dataWithBytes:bufferBytes length:bufferSize];
    return data;
    
}

@end
